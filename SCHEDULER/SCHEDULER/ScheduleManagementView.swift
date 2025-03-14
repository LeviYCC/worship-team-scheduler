import SwiftUI
import CoreData

struct ScheduleManagementView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: ScheduledEvent.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \ScheduledEvent.date, ascending: true)]
    ) var events: FetchedResults<ScheduledEvent>

    @FetchRequest(
        entity: WorshipTeamConfig.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \WorshipTeamConfig.name, ascending: true)]
    ) var teams: FetchedResults<WorshipTeamConfig>

    @FetchRequest(
        entity: Member.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Member.name, ascending: true)]
    ) var members: FetchedResults<Member>

    @State private var selectedDate = Date()
    @State private var selectedTeam: WorshipTeamConfig?
    @State private var assignedMembers: [String: Member] = [:] // 存儲角色對應的成員
    @State private var isShowingMemberPicker = false
    @State private var editingRole: String?

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("選擇活動日期")) {
                        DatePicker("活動日期", selection: $selectedDate, displayedComponents: .date)
                    }

                    Section(header: Text("選擇團隊配置")) {
                        Picker("團隊", selection: $selectedTeam) {
                            Text("選擇團隊").tag(nil as WorshipTeamConfig?)
                            ForEach(teams, id: \.self) { team in
                                Text(team.name ?? "未知").tag(team as WorshipTeamConfig?)
                            }
                        }
                    }

                    if let selectedTeam = selectedTeam {
                        Section(header: Text("成員分配")) {
                            ForEach(selectedTeam.requiredRoles?.components(separatedBy: ",") ?? [], id: \.self) { role in
                                HStack {
                                    Text(role)
                                    Spacer()
                                    if let member = assignedMembers[role] {
                                        Text(member.name ?? "未選擇")
                                            .foregroundColor(.blue)
                                    } else {
                                        Text("未選擇").foregroundColor(.gray)
                                    }
                                    Button("選擇") {
                                        editingRole = role
                                        isShowingMemberPicker = true
                                    }
                                }
                            }
                        }
                    }

                    Button("儲存排班") {
                        saveSchedule()
                    }
                    .disabled(selectedTeam == nil || assignedMembers.isEmpty)
                }

                Section(header: Text("已排班活動")) {
                    List {
                        ForEach(events) { event in
                            VStack(alignment: .leading) {
                                Text(event.teamName ?? "未知團隊").font(.headline)
                                Text("日期: \(event.date ?? Date(), formatter: dateFormatter)")
                                Text("成員: \(event.assignedMembers ?? "無")").font(.subheadline)
                            }
                        }
                        .onDelete(perform: deleteEvent)
                    }
                }
            }
            .navigationTitle("排班管理")
            .sheet(isPresented: $isShowingMemberPicker) {
                if let role = editingRole {
                    MemberPickerView(role: role, members: members, selectedMember: { selected in
                        assignedMembers[role] = selected
                    })
                }
            }
        }
    }

    // ✅ 儲存排班
    private func saveSchedule() {
        let newEvent = ScheduledEvent(context: viewContext)
        newEvent.id = UUID()
        newEvent.date = selectedDate
        newEvent.teamName = selectedTeam?.name
        newEvent.assignedMembers = assignedMembers.map { "\($0.key): \($0.value.name ?? "未知")" }.joined(separator: ",")
        saveContext()
    }

    // ✅ 刪除排班
    private func deleteEvent(at offsets: IndexSet) {
        for index in offsets {
            let event = events[index]
            viewContext.delete(event)
        }
        saveContext()
    }

    // ✅ 儲存 Core Data 變更
    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            print("❌ 儲存失敗: \(error.localizedDescription)")
        }
    }
}

// 日期格式
private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
}()
