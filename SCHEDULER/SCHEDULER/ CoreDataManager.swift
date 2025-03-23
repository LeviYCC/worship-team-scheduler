//
//  CoreDataManager.swift
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
        
        // 設定合併政策，避免衝突
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        persistentContainer.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                print("❌ 儲存失敗: \(nsError.localizedDescription)")
                print("❌ 詳細錯誤: \(nsError.userInfo)")
            }
        }
    }
    
    // 檢查衝突的方法
    func checkConflicts(forMember memberName: String, onDate date: Date) -> [ScheduledEvent] {
        let request: NSFetchRequest<ScheduledEvent> = ScheduledEvent.fetchRequest()
        
        // 取得同一天的開始與結束
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        // 設定查詢條件
        let datePredicate = NSPredicate(format: "date >= %@ AND date < %@", startOfDay as NSDate, endOfDay as NSDate)
        let memberPredicate = NSPredicate(format: "assignedMembers CONTAINS %@", memberName)
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [datePredicate, memberPredicate])
        
        do {
            return try context.fetch(request)
        } catch {
            print("❌ 檢查衝突失敗: \(error.localizedDescription)")
            return []
        }
    }
}
