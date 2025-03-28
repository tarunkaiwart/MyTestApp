//
//  UserEntity+CoreDataProperties.swift
//  
//
//  Created by Tarun Kaiwart on 27/03/25.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension UserEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserEntity> {
        return NSFetchRequest<UserEntity>(entityName: "UserEntity")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?

}

extension UserEntity : Identifiable {

}
