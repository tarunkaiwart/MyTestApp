//
//  NetworkManager.swift
//  MyTestApp
//
//  Created by Tarun Kaiwart on 25/03/25.
//

import Foundation

// Defines a protocol for network operations related to fetching users.
protocol NetworkManagerProtocol {
    /// Asynchronously fetches a list of users.
    /// - Returns: An array of `User` objects.
    /// - Throws: An error if the network request fails.
    func getUsers() async throws -> [User]
}
//MARK: - NetworkManager Implementation
// Concrete implementation of `NetworkManagerProtocol` that handles API requests.
class NetworkManager: NetworkManagerProtocol {
    // Dependency injection for API service to facilitate network requests.
    private let apiService: APIServiceProtocol

    /// Initializes the network manager with an API service dependency.
    /// - Parameter apiService: An instance conforming to `APIServiceProtocol` for making API requests.
    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }

    /// Fetches users from the API.
    /// - Returns: A list of `User` objects fetched from the API.
    /// - Throws: An error if the request fails.
    func getUsers() async throws -> [User] {
        return try await apiService.request(Endpoints.getUsers, method: .GET, body: nil)
    }
}

