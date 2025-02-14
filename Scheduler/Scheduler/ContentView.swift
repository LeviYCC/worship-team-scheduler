//
//  ContentView.swift
//  Scheduler
//
//  Created by Levi Y.C. Chow on 2024/11/27.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var dataManager = DataManager()
    @State private var selectedView: ViewType?
    
    enum ViewType {
        case singleSchedule
        case multipleSchedule
        case memberManagement
        case configurationManagement
        case scheduleList
    }
    
    var body: some View {
        NavigationView {
            if selectedView == nil {
                VStack(spacing: 20) {
                    Text("樂隊排程系統")
                        .font(.largeTitle)
                        .padding()
                    
                    Button("生成單次班表") {
                        selectedView = .singleSchedule
                    }
                    .buttonStyle(.bordered)
                    
                    Button("生成多次班表") {
                        selectedView = .multipleSchedule
                    }
                    .buttonStyle(.bordered)
                    
                    Button("成員管理") {
                        selectedView = .memberManagement
                    }
                    .buttonStyle(.bordered)
                    
                    Button("配置管理") {
                        selectedView = .configurationManagement
                    }
                    .buttonStyle(.bordered)
                    
                    Button("查看班表") {
                        selectedView = .scheduleList
                    }
                    .buttonStyle(.bordered)
                }
            } else {
                switch selectedView {
                case .singleSchedule:
                    ScheduleGeneratorView(
                        members: dataManager.members,
                        configurations: dataManager.configurations,
                        isMultiple: false,
                        onComplete: { newEvents in
                            dataManager.events.append(contentsOf: newEvents)
                            dataManager.saveData()
                            selectedView = nil
                        }
                    )
                case .multipleSchedule:
                    ScheduleGeneratorView(
                        members: dataManager.members,
                        configurations: dataManager.configurations,
                        isMultiple: true,
                        onComplete: { newEvents in
                            dataManager.events.append(contentsOf: newEvents)
                            dataManager.saveData()
                            selectedView = nil
                        }
                    )
                case .memberManagement:
                    MemberManagementView(members: $dataManager.members)
                        .onChange(of: dataManager.members) { _ in
                            dataManager.saveData()
                        }
                case .configurationManagement:
                    ConfigurationView(configurations: $dataManager.configurations)
                        .onChange(of: dataManager.configurations) { _ in
                            dataManager.saveData()
                        }
                case .scheduleList:
                    ScheduleListView(events: $dataManager.events, members: dataManager.members)
                        .onChange(of: dataManager.events) { _ in
                            dataManager.saveData()
                        }
                case .none:
                    EmptyView()
                }
            }
        }
    }
}
