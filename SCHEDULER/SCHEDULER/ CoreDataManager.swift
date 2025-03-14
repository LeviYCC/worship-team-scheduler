//
//   CoreDataManager.swift
//  SCHEDULER
//
//  Created by Levi Y.C. Chow on 2025/2/16.
//

import CoreData

class CoreDataManager {
    static let shared = CoreDataManager() // 單例模式

    let persistentContainer: NSPersistentContainer
    var context: NSManagedObjectContext { persistentContainer.viewContext }

    private init() {
        persistentContainer = NSPersistentContainer(name: "SCHEDULER") // 確保名稱與 xcdatamodeld 一致
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("載入 Core Data 失敗: \(error.localizedDescription)")
            }
        }
    }

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("❌ 儲存失敗: \(error.localizedDescription)")
            }
        }
    }
}
