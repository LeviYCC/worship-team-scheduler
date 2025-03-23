import Foundation
import CoreData

class MemberViewModel: ObservableObject {
    @Published var members: [Member] = []
    
    let context = CoreDataManager.shared.context // ✅ 統一使用 CoreDataManager

    init() {
        fetchMembers()
    }

    // 讀取成員
    func fetchMembers() {
        let request: NSFetchRequest<Member> = Member.fetchRequest()
        do {
            members = try context.fetch(request)
        } catch {
            print("❌ 讀取成員失敗: \(error.localizedDescription)")
        }
    }

    // 新增成員
    func addMember(name: String, role: String, availableDays: String) {
        let newMember = Member(context: context)
        newMember.id = UUID()
        newMember.name = name
        newMember.role = role
        newMember.availableDays = availableDays
        
        save()
    }

    // 刪除成員
    func deleteMember(member: Member) {
        context.delete(member)
        save()
    }
    
    // 儲存變更
    private func save() {
        CoreDataManager.shared.saveContext() // ✅ 統一使用 CoreDataManager 來儲存
        fetchMembers() // 重新載入資料
    }
}
