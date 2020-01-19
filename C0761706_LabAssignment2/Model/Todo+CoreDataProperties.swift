//
//  Todo+CoreDataProperties.swift
//  
//
//  Created by Ramanpreet Singh on 2020-01-19.
//
//

import Foundation
import CoreData


extension Todo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Todo> {
        return NSFetchRequest<Todo>(entityName: "Todo")
    }

    @NSManaged public var title: String
    @NSManaged public var desc: String
    @NSManaged public var dateTime: Date
    @NSManaged public var totalDays: Double

}
