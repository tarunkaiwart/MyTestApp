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
                storedUsers.forEach { context.delete($0) }
                
                // Step 2: Insert new user data
                for user in users {
                    let entity = UserEntity(context: context)
                    entity.id = Int64(user.id)
                    entity.name = user.name
                    
                    entity.username = user.username
                    entity.email = user.email
                    entity.phone = user.phone
                    entity.website = user.website
                    
                    
                    
                    //Handle `Company` Entity properly
                    if let companyData = user.company {
                        let companyEntity = Company(context: context) // Create a new CompanyEntity
                        companyEntity.name = companyData.name
                        entity.company = companyEntity // Assign to UserEntity
                    }
                    
                    // Fix: Ensure `guard let` does not exit the entire function
                    if let userAddress = user.address {
                        let addressEntity = Address(context: context)// Use AddressEntity
                        addressEntity.street = userAddress.street
                        addressEntity.suite = userAddress.suite
                        addressEntity.city = userAddress.city
                        addressEntity.zipcode = userAddress.zipcode
                        
                        entity.address = addressEntity
                        
                        if let geoData = user.address?.geo {
                            let geoEntity = Geo(context: context) // Create a new CompanyEntity
                            geoEntity.lat = geoData.lat
                            geoEntity.lng = geoData.lng
                            entity.address?.geo = geoEntity // Assign to UserEntity
                        }
                    }
                }
                
                
                // Step 3: Save changes if modifications exist
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

            return storedUsers.map { userEntity in
                User(
                    id: Int(userEntity.id),
                    name: userEntity.name ?? "",
                    username: userEntity.username ?? "",
                    email: userEntity.email ?? "",
                    address: mapAddress(userEntity.address),  // Map AddressEntity to User.Address
                    phone: userEntity.phone,
                    website: userEntity.website,
                    company: mapCompany(userEntity.company)  // Map CompanyEntity to User.Company
                )
            }
        } catch {
            print("Failed to fetch users: \(error.localizedDescription)")
            return []
        }
    }
    
    // Mapping function to convert CompanyEntity to User.Company
    private func mapCompany(_ companyEntity: Company?) -> User.Company? {
        guard let companyEntity = companyEntity else { return nil }
        
        return User.Company(
            name: companyEntity.name
        )
    }

    // Mapping function to convert AddressEntity to User.Address
    private func mapAddress(_ addressEntity: Address?) -> User.Address? {
        guard let addressEntity = addressEntity else { return nil }
        
        return User.Address(
            street: addressEntity.street,
            suite: addressEntity.suite,
            city: addressEntity.city,
            zipcode: addressEntity.zipcode,
            geo: mapGeo(addressEntity.geo)  // Map GeoEntity to User.Geo
        )
    }

    // Mapping function to convert GeoEntity to User.Geo
    private func mapGeo(_ geoEntity: Geo?) -> User.Geo? {
        guard let geoEntity = geoEntity else { return nil }
        
        return User.Geo(
            lat: geoEntity.lat,
            lng: geoEntity.lng
        )
    }

}
