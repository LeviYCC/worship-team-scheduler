//
//  Persistence.swift
//  SCHEDULER
//
//  Created by Levi Y.C. Chow on 2025/2/16.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    var viewContext: NSManagedObjectContext {
        return container.viewContext
    }

    init() {
        container = NSPersistentContainer(name: "SCHEDULER") // ⚠️ 確保這個名稱與 `xcdatamodeld` 一致
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
}
