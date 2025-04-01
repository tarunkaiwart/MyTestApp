//
//  UserEntity+CoreDataProperties.swift
//  
//
//  Created by Tarun Kaiwart on 01/04/25.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension UserEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserEntity> {
        return NSFetchRequest<UserEntity>(entityName: "UserEntity")
    }

    @NSManaged public var email: String?
    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var phone: String?
    @NSManaged public var username: String?
    @NSManaged public var website: String?
    @NSManaged public var address: Address?
    @NSManaged public var company: Company?

}

extension UserEntity : Identifiable {

}
