//
//  TeamSetupView.swift
//  SCHEDULER
//
//  Created by Levi Y.C. Chow on 2025/2/16.
//

import SwiftUI
import CoreData

struct TeamSetupView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: Team.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Team.name, ascending: true)]
    ) var teams: FetchedResults<teamName>

    @State private var teamName: String = ""
    @State private var selectedRoles: Set<String> = []
    @State private var singerCount: Int = 1

    // 角色選擇清單
    @State private var roles: [String] = [
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
                                // 🔹 歌手數量選擇
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
                                        if isSelected {
                                            // ✅ WL 處理邏輯
                                            if role == "WL" {
                                                selectedRoles.insert("WL")
                                                selectedRoles.remove("Piano.WL")
                                                selectedRoles.remove("Guitar.WL")
                                            } else if role == "Piano.WL" {
                                                selectedRoles.insert("Piano.WL")
                                                selectedRoles.remove("WL")
                                                selectedRoles.remove("Piano")
                                            } else if role == "Guitar.WL" {
                                                selectedRoles.insert("Guitar.WL")
                                                selectedRoles.remove("WL")
                                                selectedRoles.remove("Guitar")
                                            } else {
                                                selectedRoles.insert(role)
                                            }
                                        } else {
                                            selectedRoles.remove(role)
                                        }
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
                        ForEach(teams) { team in
                            VStack(alignment: .leading) {
                                Text(team.name ?? "未命名").font(.headline)
                                Text("角色: \(team.roles ?? "無")").font(.subheadline)
                                Text("歌手數量: \(team.singerCount)").font(.footnote)
                            }
                        }
                        .onDelete(perform: deleteTeam)
                    }
                }
            }
        }
        .frame(width: 450, height: 600)
    }

    // ✅ 儲存團隊配置
    private func saveTeam() {
        let newTeam = teamName(context: viewContext) // ✅ 修正初始化方式
        newTeam.id = UUID()
        newTeam.name = teamName
        newTeam.roles = selectedRoles.joined(separator: ",")
        newTeam.singerCount = Int16(singerCount)

        saveContext()
        teamName = ""
        selectedRoles.removeAll()
        singerCount = 1
    }

    // ✅ 刪除團隊
    private func deleteTeam(at offsets: IndexSet) {
        for index in offsets {
            let team = teams[index]
            viewContext.delete(team)
        }
        saveContext()
    }

    // ✅ 儲存變更
    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            print("❌ 儲存失敗: \(error.localizedDescription)")
        }
    }
}
