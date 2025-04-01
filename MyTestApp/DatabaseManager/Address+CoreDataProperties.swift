//
//  Address+CoreDataProperties.swift
//  
//
//  Created by Tarun Kaiwart on 01/04/25.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Address {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Address> {
        return NSFetchRequest<Address>(entityName: "Address")
    }

    @NSManaged public var city: String?
    @NSManaged public var street: String?
    @NSManaged public var suite: String?
    @NSManaged public var zipcode: String?
    @NSManaged public var geo: Geo?
    @NSManaged public var user: UserEntity?

}

extension Address : Identifiable {

}
