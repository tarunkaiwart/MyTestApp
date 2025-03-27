import CoreData
import UIKit

protocol CoreDataManagerProtocol {
    func saveUsers(_ users: [User])
    func fetchUsers() -> [User]
}

class CoreDataManager: CoreDataManagerProtocol {
    private let persistentContainer: NSPersistentContainer

    init() {
        persistentContainer = NSPersistentContainer(name: "MyTestApp")
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error.localizedDescription)")
            }
        }
    }

    func saveUsers(_ users: [User]) {
        let context = persistentContainer.newBackgroundContext() // Use a background context for thread safety

        context.perform {
            do {
                
                // Step 1: Clear old data
                let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
                let storedUsers = try context.fetch(fetchRequest)
                for user in storedUsers {
                    context.delete(user)
                }
                
                // Step 2: Insert new data
                for user in users {
                    let entity = UserEntity(context: context)
                    entity.id = Int64(user.id)
                    entity.name = user.name
                }

                // Step 3: Save context
                if context.hasChanges {
                    try context.save()
                    print("Users successfully saved to Core Data.")
                }
            } catch {
                print("Failed to save users: \(error.localizedDescription)")
            }
        }
    }

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
            return storedUsers.map { User(id: Int($0.id), name: $0.name ?? "", username: "", email: "", address: nil, phone: nil, website: nil, company: nil) }
        } catch {
            print("Failed to fetch users: \(error.localizedDescription)")
            return []
        }
    }
}
