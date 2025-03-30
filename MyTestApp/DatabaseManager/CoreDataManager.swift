import CoreData
import UIKit

protocol CoreDataManagerProtocol {
    /// Saves a list of users to Core Data.
    func saveUsers(_ users: [User])

    /// Fetches the list of users from Core Data.
    /// - Returns: An array of `User` objects retrieved from storage.
    func fetchUsers() -> [User]
}

class CoreDataManager: CoreDataManagerProtocol {
    /// Persistent container to manage the Core Data stack.
    private let persistentContainer: NSPersistentContainer

    /// Initializes the Core Data stack with a persistent container.
    init() {
        persistentContainer = NSPersistentContainer(name: "MyTestApp")
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error.localizedDescription)")
            }
        }
    }

    /// Saves an array of `User` objects to Core Data.
    /// - Parameter users: The list of users to be stored.
    func saveUsers(_ users: [User]) {
        let context = persistentContainer.newBackgroundContext() // Use a background context for thread safety

        context.perform {
            do {
                // Step 1: Clear existing user data to prevent duplicates
                let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
                let storedUsers = try context.fetch(fetchRequest)
                for user in storedUsers {
                    context.delete(user)
                }

                // Step 2: Insert new user data
                for user in users {
                    let entity = UserEntity(context: context)
                    entity.id = Int64(user.id)
                    entity.name = user.name
                }

                // Step 3: Save changes if there are modifications
                if context.hasChanges {
                    try context.save()
                    print("Users successfully saved to Core Data.")
                }
            } catch {
                print("Failed to save users: \(error.localizedDescription)")
            }
        }
    }

    /// Fetches stored users from Core Data.
    /// - Returns: An array of `User` objects mapped from `UserEntity`.
    func fetchUsers() -> [User] {
        let context = persistentContainer.viewContext
        let request: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()

        do {
            let storedUsers = try context.fetch(request)
            if storedUsers.isEmpty {
                print("No users found in Core Data.")
                return []
            }

            print("Users fetched successfully from Core Data.")
            // Convert `UserEntity` objects into `User` model instances
            return storedUsers.map {
                User(
                    id: Int($0.id),
                    name: $0.name ?? "",
                    username: "",
                    email: "",
                    address: nil,
                    phone: nil,
                    website: nil,
                    company: nil
                )
            }
        } catch {
            print("Failed to fetch users: \(error.localizedDescription)")
            return []
        }
    }
}
