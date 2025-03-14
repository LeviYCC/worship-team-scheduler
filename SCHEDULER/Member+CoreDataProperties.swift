//
//  Member+CoreDataProperties.swift
//  SCHEDULER
//
//  Created by Levi Y.C. Chow on 2025/3/12.
//
//
import Foundation
import CoreData

extension Member {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Member> {
        return NSFetchRequest<Member>(entityName: "Member")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var availableDays: String?
    @NSManaged public var role: String?
    @NSManaged public var scheduledEvents: Set<ScheduledEvent>?

}

extension Member: Identifiable { }
