//
//  ScheduleListView.swift
//  Scheduler
//
//  Created by Levi Y.C. Chow on 2024/11/27.
//
import SwiftUI

struct ScheduleListView: View {
    @Binding var events: [ScheduleEvent]
    let members: [BandMember]
    
    @State private var selectedEvents: Set<UUID> = []
    @State private var showingExportOptions = false
    
    var body: some View {
        List {
            ForEach(events) { event in
                HStack {
                    VStack(alignment: .leading) {
                        Text(formatDate(event.date))
                        Text(event.serviceType.rawValue)
                            .font(.caption)
                    }
                    Spacer()
                    Button(action: {
                        if selectedEvents.contains(event.id) {
                            selectedEvents.remove(event.id)
                        } else {
                            selectedEvents.insert(event.id)
                        }
                    }) {
                        Image(systemName: selectedEvents.contains(event.id) ? "checkmark.circle.fill" : "circle")
                    }
                }
            }
        }
        .navigationTitle("班表列表")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("導出") {
                    showingExportOptions = true
                }
                .disabled(selectedEvents.isEmpty)
            }
        }
        .sheet(isPresented: $showingExportOptions) {
            ExportOptionsView(
                selectedEvents: events.filter { selectedEvents.contains($0.id) },
                members: members
            )
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: date)
    }
}
