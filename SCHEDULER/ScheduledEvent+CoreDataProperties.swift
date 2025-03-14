//
//  ScheduledEvent+CoreDataProperties.swift
//  SCHEDULER
//
//  Created by Levi Y.C. Chow on 2025/3/12.
//
//

import Foundation
import CoreData

extension ScheduledEvent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ScheduledEvent> {
        return NSFetchRequest<ScheduledEvent>(entityName: "ScheduledEvent")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var date: Date?
    @NSManaged public var teamName: String?
    @NSManaged public var assignedMembers: Set<Member>?

}

extension ScheduledEvent: Identifiable { }
