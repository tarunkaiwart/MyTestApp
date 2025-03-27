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

class APIService: APIServiceProtocol {
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


enum Endpoints {
    static let baseURL = "https://jsonplaceholder.typicode.com"

    case getUsers

    var url: URL {
        switch self {
        case .getUsers:
            return URL(string: "\(Endpoints.baseURL)/users")!
        }
    }
}

