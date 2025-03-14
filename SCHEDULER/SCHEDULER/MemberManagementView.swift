//
//  ContentView.swift
//  SCHEDULER
//
//  Created by Levi Y.C. Chow on 2025/2/16.
//

import SwiftUI
import CoreData

struct MemberManagementView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: Member.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Member.name, ascending: true)]
    ) var members: FetchedResults<Member>

    @State private var name: String = ""
    @State private var newRole: String = ""
    @State private var newDay: String = ""
    
    @State private var roles: [String] = ["Gt.WL", "piano.WL", "Drum", "Singer", "EGT", "KB", "Guitar" ,"Bass", "Rapper","Piano","PPT" ,"Sound" ,"Livestream"]
    @State private var availableDays: [String] = ["Sun.Service", "Sat.Service", "Shine Prayer Meeting", "Qigu.Service" , "Shinhua.Service"]

    @State private var selectedRoles: Set<String> = []
    @State private var selectedDays: Set<String> = []

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("新增成員")) {
                        TextField("姓名", text: $name)
                        Text("選擇角色")
                        LazyVGrid(columns: Array(repeating: GridItem(), count: 2)) {
                            ForEach(roles, id: \.self) { role in
                                Toggle(role, isOn: Binding(
                                    get: { selectedRoles.contains(role) },
                                    set: { isSelected in
                                        if isSelected { selectedRoles.insert(role) }
                                        else { selectedRoles.remove(role) }
                                    }
                                ))
                            }
                        }

                        Text("選擇服事時間")
                        LazyVGrid(columns: Array(repeating: GridItem(), count: 2)) {
                            ForEach(availableDays, id: \.self) { day in
                                Toggle(day, isOn: Binding(
                                    get: { selectedDays.contains(day) },
                                    set: { isSelected in
                                        if isSelected { selectedDays.insert(day) }
                                        else { selectedDays.remove(day) }
                                    }
                                ))
                            }
                        }

                        Button("加入") {
                            addMember()
                            name = ""
                            selectedRoles.removeAll()
                            selectedDays.removeAll()
                        }
                    }

                    Section(header: Text("新增角色/服事時間")) {
                        HStack {
                            TextField("新增角色", text: $newRole)
                            Button("新增") {
                                if !newRole.isEmpty {
                                    roles.append(newRole)
                                    newRole = ""
                                }
                            }
                        }
                        HStack {
                            TextField("新增服事時間", text: $newDay)
                            Button("新增") {
                                if !newDay.isEmpty {
                                    availableDays.append(newDay)
                                    newDay = ""
                                }
                            }
                        }
                    }

                    Section(header: Text("成員清單（點擊可編輯）")) {
                        List {
                            ForEach(members) { member in
                                Button(action: { editMember(member) }) {
                                    VStack(alignment: .leading) {
                                        Text(member.name ?? "未知").font(.headline)
                                        Text("角色: \(member.role ?? "未設定")").font(.subheadline)
                                        Text("可服事時間: \(member.availableDays ?? "未設定")").font(.footnote)
                                    }
                                }
                            }
                            .onDelete(perform: deleteMember)
                        }
                    }
                }
            }
            .navigationTitle("成員管理")
        }
    }

    private func addMember() {
        let newMember = Member(context: viewContext)
        newMember.id = UUID()
        newMember.name = name
        newMember.role = selectedRoles.joined(separator: ",")
        newMember.availableDays = selectedDays.joined(separator: ",")
        saveContext()
    }

    private func editMember(_ member: Member) {
        name = member.name ?? ""
        selectedRoles = Set(member.role?.components(separatedBy: ",") ?? [])
        selectedDays = Set(member.availableDays?.components(separatedBy: ",") ?? [])
    }

    private func deleteMember(at offsets: IndexSet) {
        for index in offsets {
            let member = members[index]
            viewContext.delete(member)
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
}
