import SwiftUI
import CoreData

struct TeamSetupView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: WorshipTeamConfig.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \WorshipTeamConfig.name, ascending: true)]
    ) var teams: FetchedResults<WorshipTeamConfig>

    @State private var teamName: String = ""
    @State private var selectedRoles: Set<String> = []
    @State private var singerCount: Int = 1

    private let roles: [String] = [
        "WL", "Piano.WL", "Guitar.WL", "Drum", "Singer", "EGT", "KB", "Guitar",
        "Bass", "Rapper", "Piano", "PPT", "Sound", "Livestream"
    ]

    var body: some View {
        VStack {
            Form {
                Section(header: Text("建立團隊配置")) {
                    TextField("團隊名稱", text: $teamName)
                    
                    Text("選擇角色")
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 2), spacing: 10) {
                        ForEach(roles, id: \.self) { role in
                            if role == "Singer" {
                                Picker("歌手數量", selection: $singerCount) {
                                    ForEach(1...4, id: \.self) { num in
                                        Text("\(num) 位")
                                    }
                                }
                                .pickerStyle(MenuPickerStyle())
                            } else {
                                Toggle(role, isOn: Binding(
                                    get: { selectedRoles.contains(role) },
                                    set: { isSelected in
                                        updateSelectedRoles(role: role, isSelected: isSelected)
                                    }
                                ))
                            }
                        }
                    }
                    
                    Button("儲存團隊") {
                        saveTeam()
                    }
                }

                Section(header: Text("現有團隊配置")) {
                    List {
                        ForEach(teams, id: \.self) { team in  // ✅ 確保有 ID
                            VStack(alignment: .leading) {
                                Text(team.name ?? "未命名").font(.headline)
                                Text("角色: \(team.roles ?? "無")").font(.subheadline) // ✅ 確保 roles 存在
                                Text("歌手數量: \(team.singerCount)").font(.footnote) // ✅ 確保 singerCount 存在
                            }
                        }
                        .onDelete(perform: deleteTeam)
                    }
                }
            }
        }
        .frame(width: 450, height: 600)
    }

    private func updateSelectedRoles(role: String, isSelected: Bool) {
        if isSelected {
            switch role {
            case "WL":
                selectedRoles.insert("WL")
                selectedRoles.remove("Piano.WL")
                selectedRoles.remove("Guitar.WL")
            case "Piano.WL":
                selectedRoles.insert("Piano.WL")
                selectedRoles.remove("WL")
                selectedRoles.remove("Piano")
            case "Guitar.WL":
                selectedRoles.insert("Guitar.WL")
                selectedRoles.remove("WL")
                selectedRoles.remove("Guitar")
            default:
                selectedRoles.insert(role)
            }
        } else {
            selectedRoles.remove(role)
        }
    }

    private func saveTeam() {
        let newTeam = WorshipTeamConfig(context: viewContext)
        newTeam.id = UUID()
        newTeam.name = teamName
        newTeam.roles = selectedRoles.joined(separator: ",")
        newTeam.singerCount = Int16(singerCount)

        saveContext()
        resetForm()
    }

    private func deleteTeam(at offsets: IndexSet) {
        for index in offsets {
            let team = teams[index]
            viewContext.delete(team)
        }
        saveContext()
    }

    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            print("❌ 儲存失敗: \(error.localizedDescription)")
        }
    }

    private func resetForm() {
        teamName = ""
        selectedRoles.removeAll()
        singerCount = 1
    }
}
