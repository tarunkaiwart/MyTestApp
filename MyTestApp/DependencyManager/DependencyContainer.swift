//
//  DependencyContainer.swift
//  MyTestApp
//
//  Created by Tarun Kaiwart on 25/03/25.
//

import Foundation

class DependencyContainer {
    static let shared = DependencyContainer()

        let apiService: APIServiceProtocol
        let networkManager : NetworkManagerProtocol
        let coreDataManager: CoreDataManagerProtocol
        let cacheManager: CacheManagerProtocol

    private init() {
        self.apiService = APIService()
        self.networkManager = NetworkManager(apiService: apiService)
        self.coreDataManager = CoreDataManager() // Injected instead of singleton
        self.cacheManager = CacheManager()
        
    }
    ///Currently not in use :- This method was used to create dependency from SceneDelegate
    func createUserViewModel() -> UserViewModel {
        let networkManager = NetworkManager(apiService: apiService)
        return UserViewModel(networkManager: networkManager, coreDataManager: coreDataManager, cacheManager: cacheManager)
    }
}
