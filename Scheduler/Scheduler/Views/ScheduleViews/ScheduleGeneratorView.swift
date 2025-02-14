//
//  ScheduleGeneratorView.swift
//  Scheduler
//
//  Created by Levi Y.C. Chow on 2024/11/27.
//
import SwiftUI

struct ScheduleGeneratorView: View {
    @StateObject private var dataManager = DataManager.shared
    @State private var selectedDates: Set<Date> = []
    @State private var showingDatePicker = false
    @State private var selectedConfiguration: Configuration?
    
    var body: some View {
        NavigationView {
            Form {
                Section("日期選擇") {
                    Button(action: { showingDatePicker = true }) {
                        HStack {
                            Text("選擇日期")
                            Spacer()
                            Text("\(selectedDates.count) 個日期已選擇")
                                .foregroundColor(.gray)
                        }
                    }
                }
                
                Section("排班設定") {
                    if let configurations = dataManager.configurations {
                        Picker("選擇配置", selection: $selectedConfiguration) {
                            Text("請選擇").tag(nil as Configuration?)
                            ForEach(configurations) { config in
                                Text(config.name).tag(config as Configuration?)
                            }
                        }
                    }
                }
                
                Section {
                    Button("生成排班表") {
                        generateSchedule()
                    }
                    .disabled(selectedDates.isEmpty || selectedConfiguration == nil)
                }
            }
            .navigationTitle("生成排班表")
            .sheet(isPresented: $showingDatePicker) {
                MultiDatePickerView(selectedDates: $selectedDates)
            }
        }
    }
    
    private func generateSchedule() {
        guard let configuration = selectedConfiguration else { return }
        
        let sortedDates = selectedDates.sorted()
        var newEvents: [ScheduleEvent] = []
        
        for date in sortedDates {
            let event = ScheduleEvent(
                date: date,
                serviceType: .sunday,
                assignments: configuration.roles.map { role in
                    RoleAssignment(role: role, memberIds: [])
                }
            )
            newEvents.append(event)
        }
        
        dataManager.events.append(contentsOf: newEvents)
        selectedDates.removeAll()
        selectedConfiguration = nil
    }
}
