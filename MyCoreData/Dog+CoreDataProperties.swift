//
//  Dog+CoreDataProperties.swift
//  MyCoreData
//
//  Created by Superpingos on 07.01.18.
//
//

import Foundation
import CoreData


extension Dog {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Dog> {
        return NSFetchRequest<Dog>(entityName: "Dog")
    }

    @NSManaged public var age: Int32
    @NSManaged public var id_dog: String?
    @NSManaged public var name: String?
    @NSManaged public var owner: Person?

}
