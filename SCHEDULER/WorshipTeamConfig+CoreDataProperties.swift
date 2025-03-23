//
//  WorshipTeamConfig+CoreDataProperties.swift
//  SCHEDULER
//
//  Created by Levi Y.C. Chow on 2025/3/16.
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
    @NSManaged public var roles: String?
    @NSManaged public var requiredRoles: String?
    @NSManaged public var singerCount: Int16

}

extension WorshipTeamConfig : Identifiable {

}
