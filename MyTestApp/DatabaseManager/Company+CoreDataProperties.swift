//
//  Company+CoreDataProperties.swift
//  
//
//  Created by Tarun Kaiwart on 01/04/25.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Company {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Company> {
        return NSFetchRequest<Company>(entityName: "Company")
    }

    @NSManaged public var name: String?
    @NSManaged public var relationship: UserEntity?

}

extension Company : Identifiable {

}
