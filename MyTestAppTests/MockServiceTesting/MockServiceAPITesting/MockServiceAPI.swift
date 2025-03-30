//
//  MockServiceAPI.swift
//  MyTestAppTests
//
//  Created by Tarun Kaiwart on 26/03/25.
//

import Foundation
@testable import MyTestApp

class MockServiceAPI : APIServiceProtocol{
    var mockData: Data?
    var mockError: Error?
    
    func request<T:Decodable>(_ endpoint: Endpoints, method: HTTPMethod, body: Data?) async throws -> T {
        if let mockError = mockError {
            throw mockError
        }
        guard let data = mockData else {
            throw APIError.networkError("Mocked No data error")
        }
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    
}
