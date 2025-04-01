//
//  Geo+CoreDataProperties.swift
//  
//
//  Created by Tarun Kaiwart on 01/04/25.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Geo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Geo> {
        return NSFetchRequest<Geo>(entityName: "Geo")
    }

    @NSManaged public var lat: String?
    @NSManaged public var lng: String?
    @NSManaged public var relationship: Address?

}

extension Geo : Identifiable {

}
