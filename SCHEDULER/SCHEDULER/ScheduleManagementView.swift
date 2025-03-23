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
    @State private var assignedMembers: [String: Member] = [:]
    @State private var isShowingMemberPicker = false
    @State private var editingRole: String?
    @State private var eventName: String = ""
    @State private var conflicts: [String] = []
    @State private var showingConflictAlert = false
    @State private var isEditMode = false
    @State private var editingEvent: ScheduledEvent?

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("活動資訊")) {
                        TextField("活動名稱", text: $eventName)
                        DatePicker("活動日期", selection: $selectedDate, displayedComponents: .date)
                    }

                    Section(header: Text("選擇團隊配置")) {
                        Picker("團隊", selection: $selectedTeam) {
                            Text("選擇團隊").tag(nil as WorshipTeamConfig?)
                            ForEach(teams, id: \ .self) { team in
                                Text(team.name ?? "未知").tag(team as WorshipTeamConfig?)
                            }
                        }
                        .onChange(of: selectedTeam) {
                            assignedMembers.removeAll()
                        }
                    }

                    if let selectedTeam = selectedTeam {
                        Section(header: Text("成員分配")) {
                            let requiredRoles = selectedTeam.requiredRoles?.components(separatedBy: ",") ?? []
                            ForEach(requiredRoles, id: \ .self) { role in
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

                    Button(isEditMode ? "更新排班" : "儲存排班") {
                        checkConflicts()
                    }
                    .disabled(selectedTeam == nil || eventName.isEmpty || assignedMembers.isEmpty)
                }

                Section(header:
                    HStack {
                        Text("已排班活動")
                        Spacer()
                        Button("今天") {
                            scrollToToday()
                        }
                    }
                ) {
                    List {
                        ForEach(events) { event in
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(formatDate(event.date ?? Date()))
                                        .font(.headline)
                                    Text(event.teamName ?? "未知團隊")
                                        .font(.subheadline)
                                    Spacer()
                                    Button("編輯") {
                                        editEvent(event)
                                    }
                                }
                                Text("成員: \(event.assignedMembers ?? "無")")
                                    .font(.caption)
                            }
                        }
                        .onDelete(perform: deleteEvent)
                    }
                }
            }
            .navigationTitle("排班管理")
            .sheet(isPresented: $isShowingMemberPicker) {
                if let role = editingRole {
                    memberPickerView(role: role)
                }
            }
            .alert(isPresented: $showingConflictAlert) {
                Alert(
                    title: Text("排班衝突警告"),
                    message: Text("發現以下衝突:\n\(conflicts.joined(separator: "\n"))\n是否仍要儲存?"),
                    primaryButton: .default(Text("仍要儲存")) {
                        saveScheduleWithConflicts()
                    },
                    secondaryButton: .cancel(Text("取消"))
                )
            }
        }
    }
}
