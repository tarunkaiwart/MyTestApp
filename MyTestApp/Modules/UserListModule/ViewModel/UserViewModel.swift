import Foundation

class UserViewModel {
    
    // Dependencies for handling network requests, local database (Core Data), and caching
    private let networkManager: NetworkManagerProtocol
    private let coreDataManager: CoreDataManagerProtocol
    private let cacheManager: CacheManagerProtocol

    // Holds the list of users
    private(set) var users: [User] = []
    
    // Callback closures for UI updates and error handling
    var onDataUpdate: (() -> Void)?
    var onError: ((String) -> Void)?

    // Dependency injection through initializer, using shared instances by default
    init(
        networkManager: NetworkManagerProtocol = DependencyContainer.shared.networkManager,
        coreDataManager: CoreDataManagerProtocol = DependencyContainer.shared.coreDataManager,
        cacheManager: CacheManagerProtocol = DependencyContainer.shared.cacheManager)
    {
        self.networkManager = networkManager
        self.coreDataManager = coreDataManager
        self.cacheManager = cacheManager
    }

    /// Fetches users following a fallback mechanism:
    /// 1. Attempts to load from cache first.
    /// 2. If not available in cache, tries Core Data (currently commented out).
    /// 3. If not available in Core Data, fetches from API.
    /// 4. If API call fails, falls back to Core Data again before showing an error.
    func fetchUsers() {
        Task {
            // Step 1: Check if data exists in cache
            if let cachedUsers: [User] = cacheManager.getData(ofType: [User].self), !cachedUsers.isEmpty {
                self.users = cachedUsers
                onDataUpdate?()
                print("Loaded users from CacheManager.")
                return
            }
            
            // Core Data loading is commented out. Uncomment if Core Data should be checked before making a network request.
            if !coreDataManager.fetchUsers().isEmpty {
                let coreDataStoredUser = coreDataManager.fetchUsers()
                if !coreDataStoredUser.isEmpty {
                    self.users = coreDataStoredUser
                }
                onDataUpdate?()
                print("Loaded users from Core Data.")
                return
            }

            do {
                // Step 2: Fetch from API if no cached data is found
                let users = try await networkManager.getUsers()
                self.users = users
                
                // Store fetched data into Core Data for persistence
                coreDataManager.saveUsers(users)
                
                // Cache the fetched data to improve performance
                cacheManager.saveData(users)
                
                // Notify UI about the data update
                onDataUpdate?()
            } catch {
                print("Network error: Fetching from Core Data...")

                // Step 3: If API call fails, attempt to load from Core Data
                let localUsers = coreDataManager.fetchUsers()
                if !localUsers.isEmpty {
                    self.users = localUsers
                    onDataUpdate?()
                    print("Loaded users from Core Data.")
                } else {
                    // Step 4: If no local data exists, notify UI about the error
                    self.onError?(error.localizedDescription)
                }
            }
        }
    }
}

