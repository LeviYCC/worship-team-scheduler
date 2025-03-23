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
    @NSManaged public var assignedMembers: String?
    @NSManaged public var members: Set<Member>?

}

// MARK: Generated accessors for assignedMembers
extension ScheduledEvent {

    @objc(addMembersObject:)
    @NSManaged public func addToMembers(_ value: Member)

    @objc(removeMembersObject:)
    @NSManaged public func removeFromMembers(_ value: Member)

    @objc(addMembers:)
    @NSManaged public func addToMembers(_ values: NSSet)

    @objc(removeMembers:)
    @NSManaged public func removeFromMembers(_ values: NSSet)

}

extension ScheduledEvent: Identifiable { }
