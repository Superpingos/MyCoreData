//
//  Person+CoreDataProperties.swift
//  MyCoreData
//
//  Created by Superpingos on 07.01.18.
//
//

import Foundation
import CoreData


extension Person {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Person> {
        return NSFetchRequest<Person>(entityName: "Person")
    }

    @NSManaged public var fullname: String?
    @NSManaged public var id_person: String?
    @NSManaged public var dogs: NSSet?

}

// MARK: Generated accessors for dogs
extension Person {

    @objc(addDogsObject:)
    @NSManaged public func addToDogs(_ value: Dog)

    @objc(removeDogsObject:)
    @NSManaged public func removeFromDogs(_ value: Dog)

    @objc(addDogs:)
    @NSManaged public func addToDogs(_ values: NSSet)

    @objc(removeDogs:)
    @NSManaged public func removeFromDogs(_ values: NSSet)

}
