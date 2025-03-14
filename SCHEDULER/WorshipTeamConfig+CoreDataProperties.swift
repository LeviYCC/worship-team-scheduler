//
//  WorshipTeamConfig+CoreDataProperties.swift
//  SCHEDULER
//
//  Created by Levi Y.C. Chow on 2025/3/12.
//
//

import Foundation
import CoreData

extension WorshipTeamConfig {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WorshipTeamConfig> {
        return NSFetchRequest<WorshipTeamConfig>(entityName: "WorshipTeamConfig")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var requiredRoles: Set<String>?

}

extension WorshipTeamConfig: Identifiable { }
