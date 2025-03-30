//
//  APIService.swift
//  MyTestApp
//
//  Created by Tarun Kaiwart on 25/03/25.
//

import Foundation

enum HTTPMethod: String {
    case GET, POST, PUT, DELETE
}


protocol APIServiceProtocol {
    func request<T: Decodable>(_ endpoint: Endpoints, method: HTTPMethod, body: Data?) async throws -> T
}
// MARK: API Service Management

class APIService: APIServiceProtocol {
    
        /// Performs an asynchronous network request to the specified endpoint, decoding the response into the specified Decodable type.
        ///
        /// - Parameters:
        ///   - endpoint: The API endpoint to request.
        ///   - method: The HTTP method (e.g., GET, POST, PUT, DELETE).
        ///   - body: The optional request body data.
        ///
        /// - Returns: The decoded response object of type T.
        ///
        /// - Throws: An error if the request fails or the response cannot be decoded.
    func request<T: Decodable>(_ endpoint: Endpoints, method: HTTPMethod, body: Data? = nil) async throws -> T {
        var request = URLRequest(url: endpoint.url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                throw APIError.invalidResponse
            }
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw APIError.networkError(error.localizedDescription)
        }
    }
}

// MARK: API Endpoints
enum Endpoints {
    
    //Loading the APIBaseURL from info.plist
    static let baseURL: String = {
           guard let urlString = Bundle.main.object(forInfoDictionaryKey: "APIBaseURL") as? String,
                 !urlString.isEmpty else {
               fatalError("APIBaseURL not found or empty in Info.plist")
           }
           return urlString
       }()

    case getUsers
    

    var url: URL {
        switch self {
        case .getUsers:
            return URL(string: "\(Endpoints.baseURL)/users")!
        }
    }
}

