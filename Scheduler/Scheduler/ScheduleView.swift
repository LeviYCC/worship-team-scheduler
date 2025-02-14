//
//  ScheduleView.swift
//  Scheduler
//
//  Created by Levi Y.C. Chow on 2024/11/27.
//
import SwiftUI

struct ScheduleView: View {
    let members: [BandMember]
    @Binding var events: [ScheduleEvent]
    @Binding var configurations: [Configuration]
    
    @State private var selectedDate = Date()
    @State private var newEventTitle = ""
    @State private var newEventMemberId: UUID?
    @State private var newEventInstrument = ""
    @State private var selectedConfiguration: Configuration?
    
    var body: some View {
        VStack {
            DatePicker("選擇日期", selection: $selectedDate, displayedComponents: .date)
                .padding()
            
            List {
                ForEach(events.filter { Calendar.current.isDate($0.start, inSameDayAs: selectedDate) }) { event in
                    VStack(alignment: .leading) {
                        Text(event.title).font(.headline)
                        Text("時間: \(formatDate(event.start)) - \(formatDate(event.end))")
                        Text("成員: \(members.first(where: { $0.id == event.memberId })?.name ?? "未知")")
                        Text("樂器: \(event.instrument)")
                    }
                }
                .onDelete(perform: deleteEvent)
            }
            
            Divider()
            
            VStack(spacing: 10) {
                TextField("活動標題", text: $newEventTitle)
                
                Picker("成員", selection: $newEventMemberId) {
                    Text("選擇成員").tag(nil as UUID?)
                    ForEach(members) { member in
                        Text(member.name).tag(member.id as UUID?)
                    }
                }
                
                TextField("樂器", text: $newEventInstrument)
                
                Button("新增活動") {
                    addEvent()
                }
                .disabled(newEventTitle.isEmpty || newEventMemberId == nil || newEventInstrument.isEmpty)
            }
            .padding()
            
            Divider()
            
            VStack(spacing: 10) {
                Picker("配置", selection: $selectedConfiguration) {
                    Text("選擇配置").tag(nil as Configuration?)
                    ForEach(configurations) { config in
                        Text(config.name).tag(config as Configuration?)
                    }
                }
                
                Button("應用配置") {
                    applyConfiguration()
                }
                .disabled(selectedConfiguration == nil)
            }
            .padding()
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    private func addEvent() {
        guard let memberId = newEventMemberId else { return }
        let newEvent = ScheduleEvent(id: UUID(), title: newEventTitle, start: selectedDate, end: selectedDate.addingTimeInterval(3600), memberId: memberId, instrument: newEventInstrument)
        events.append(newEvent)
        newEventTitle = ""
        newEventMemberId = nil
        newEventInstrument = ""
    }
    
    private func deleteEvent(at offsets: IndexSet) {
        let eventsOnSelectedDate = events.filter { Calendar.current.isDate($0.start, inSameDayAs: selectedDate) }
        let eventsToDelete = offsets.map { eventsOnSelectedDate[$0] }
        events.removeAll(where: { event in
            eventsToDelete.contains(where: { $0.id == event.id })
        })
    }
    
    private func applyConfiguration() {
        guard let config = selectedConfiguration else { return }
        for role in config.roles {
            let newEvent = ScheduleEvent(id: UUID(), title: role, start: selectedDate, end: selectedDate.addingTimeInterval(3600), memberId: members.first?.id ?? UUID(), instrument: role)
            events.append(newEvent)
        }
        selectedConfiguration = nil
    }
}

struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView(members: [], events: .constant([]), configurations: .constant([]))
    }
}
