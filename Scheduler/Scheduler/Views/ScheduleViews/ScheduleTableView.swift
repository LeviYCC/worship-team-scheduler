//
//  ScheduleTableView.swift
//  Scheduler
//
//  Created by Levi Y.C. Chow on 2024/11/29.
//
import SwiftUI

struct ScheduleTableView: View {
    @Binding var events: [ScheduleEvent]
    let members: [BandMember]
    
    var body: some View {
        ScrollView([.horizontal, .vertical]) {
            VStack(alignment: .leading, spacing: 0) {
                // Header Row
                HStack(spacing: 0) {
                    Text("日期")
                        .frame(width: 150, height: 40)
                        .border(Color.gray, width: 1)
                    
                    ForEach(Role.allCases, id: \.self) { role in
                        Text(role.rawValue)
                            .frame(width: 120, height: 40)
                            .border(Color.gray, width: 1)
                    }
                }
                
                // Data Rows
                ForEach(events) { event in
                    HStack(spacing: 0) {
                        VStack(alignment: .leading) {
                            Text(formatDate(event.date))
                            Text(event.serviceType.rawValue)
                                .font(.caption)
                        }
                        .frame(width: 150, height: 60)
                        .border(Color.gray, width: 1)
                        
                        ForEach(event.assignments) { assignment in
                            MemberSelectionCell(
                                assignment: assignment,
                                members: members.filter { member in
                                    member.instruments.contains(assignment.role.rawValue)
                                }
                            )
                            .frame(width: 120, height: 60)
                            .border(Color.gray, width: 1)
                        }
                    }
                }
            }
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd"
        return formatter.string(from: date)
    }
}
