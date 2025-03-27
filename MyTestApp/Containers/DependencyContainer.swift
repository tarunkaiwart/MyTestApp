//
//  DependencyContainer.swift
//  MyTestApp
//
//  Created by Tarun Kaiwart on 25/03/25.
//

import Foundation

class DependencyContainer {
    static let shared = DependencyContainer()

    private let apiService: APIServiceProtocol
    private let coreDataManager: CoreDataManagerProtocol
    private let cacheManager: CacheManagerProtocol

    private init() {
        self.apiService = APIService()
        self.coreDataManager = CoreDataManager() // Injected instead of singleton
        self.cacheManager = CacheManager()
    }

    func createUserViewModel() -> UserViewModel {
        let networkManager = NetworkManager(apiService: apiService)
        return UserViewModel(networkManager: networkManager, coreDataManager: coreDataManager, cacheManager: cacheManager)
    }
}
