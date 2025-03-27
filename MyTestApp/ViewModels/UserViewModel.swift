import Foundation

class UserViewModel {
    private let networkManager: NetworkManagerProtocol
    private let coreDataManager: CoreDataManagerProtocol
    private let cacheManager: CacheManagerProtocol

    var users: [User] = []
    var onDataUpdate: (() -> Void)?
    var onError: ((String) -> Void)?

    init(networkManager: NetworkManagerProtocol, coreDataManager: CoreDataManagerProtocol, cacheManager: CacheManagerProtocol) {
        self.networkManager = networkManager
        self.coreDataManager = coreDataManager
        self.cacheManager = cacheManager
    }

    func fetchUsers() {
        Task {
            // Step 1: Check cache first
            if let cachedUsers: [User] = cacheManager.getData(ofType: [User].self), !cachedUsers.isEmpty {
                self.users = cachedUsers
                onDataUpdate?()
                print("Loaded users from CacheManager.")
                return
            }
            
//            if !coreDataManager.fetchUsers().isEmpty{
//                let coreDataStoredUser = coreDataManager.fetchUsers()
//                if !coreDataStoredUser.isEmpty {
//                    self.users = coreDataStoredUser
//                }
//                onDataUpdate?()
//                print("Loaded users from Core Data.")
//                return
//            }

            do {
                // Step 2: Fetch from API if cache is empty
                let users = try await networkManager.getUsers()
                self.users = users
                coreDataManager.saveUsers(users) // Store in Core Data
                cacheManager.saveData(users) // Store in CacheManager
                onDataUpdate?()
            } catch {
                print("Network error: Fetching from Core Data...")

                let localUsers = coreDataManager.fetchUsers()
                if !localUsers.isEmpty {
                    self.users = localUsers
                    onDataUpdate?()
                    print("Loaded users from Core Data.")
                } else {
                    self.onError?(error.localizedDescription) // Show error only if no data exists
                }
            }
        }
    }


}
