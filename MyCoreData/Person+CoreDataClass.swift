//
//  Person+CoreDataClass.swift
//  MyCoreData
//
//  Created by Superpingos on 29.12.17.
//
//

import Foundation
import CoreData


public class Person: NSManagedObject
{
    func getFetchRequest() -> NSFetchRequest<Person>
    {
        return Person.fetchRequest()
    }
    
    func allWithFullnameSortDesc() -> NSFetchRequest<Person>
    {
        let tmp:NSFetchRequest<Person> = Person.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "fullname", ascending: false)
        tmp.sortDescriptors = [sortDescriptor]
        
        return tmp
    }
    
    @nonobjc public func sayHello() -> String
    {
        return "Hello"
    }
}

