//
//  ConfigurationView.swift
//  Scheduler
//
//  Created by Levi Y.C. Chow on 2024/11/27.
//
import SwiftUI

struct ConfigurationView: View {
    @Binding var configurations: [Configuration]
    @State private var newConfigName = ""
    @State private var selectedRoles: Set<Role> = []
    @State private var singerCount: Int = 1
    
    var body: some View {
        VStack {
            List {
                ForEach(configurations) { config in
                    VStack(alignment: .leading) {
                        Text(config.name).font(.headline)
                        Text("角色: \(config.roles.map { $0.rawValue }.joined(separator: ", "))")
                        if config.roles.contains(.singer) {
                            Text("歌手數量: \(config.singerCount)")
                        }
                    }
                }
                .onDelete(perform: deleteConfiguration)
            }
            
            Divider()
            
            VStack(spacing: 10) {
                TextField("配置名稱", text: $newConfigName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading) {
                        ForEach(Role.allCases, id: \.self) { role in
                            Toggle(role.rawValue, isOn: Binding(
                                get: { selectedRoles.contains(role) },
                                set: { isSelected in
                                    if isSelected {
                                        selectedRoles.insert(role)
                                    } else {
                                        selectedRoles.remove(role)
                                    }
                                }
                            ))
                        }
                    }
                }
                .frame(height: 200)
                
                if selectedRoles.contains(.singer) {
                    Stepper("歌手數量: \(singerCount)", value: $singerCount, in: 1...5)
                }
                
                Button("新增配置") {
                    addConfiguration()
                }
                .disabled(newConfigName.isEmpty || selectedRoles.isEmpty)
            }
            .padding()
        }
    }
    
    private func addConfiguration() {
        let newConfig = Configuration(
            id: UUID(),
            name: newConfigName,
            roles: Array(selectedRoles),
            singerCount: selectedRoles.contains(.singer) ? singerCount : 1
        )
        configurations.append(newConfig)
        newConfigName = ""
        selectedRoles = []
        singerCount = 1
    }
    
    private func deleteConfiguration(at offsets: IndexSet) {
        configurations.remove(atOffsets: offsets)
    }
}
