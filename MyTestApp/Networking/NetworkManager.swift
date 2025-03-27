//
//  NetworkManager.swift
//  MyTestApp
//
//  Created by Tarun Kaiwart on 25/03/25.
//

import Foundation

protocol NetworkManagerProtocol {
    func getUsers() async throws -> [User]
}

class NetworkManager: NetworkManagerProtocol {
    private let apiService: APIServiceProtocol

    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }

    func getUsers() async throws -> [User] {
        return try await apiService.request(Endpoints.getUsers, method: .GET, body: nil)
    }
}
