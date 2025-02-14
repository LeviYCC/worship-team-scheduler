//
//  ExportOptionsView.swift
//  Scheduler
//
//  Created by Levi Y.C. Chow on 2024/11/29.
//
import SwiftUI

struct ExportOptionsView: View {
    let events: [ScheduleEvent]
    let members: [BandMember]
    @Environment(\.dismiss) var dismiss
    @State private var selectedFormat: ExportFormat = .csv
    
    enum ExportFormat: String, CaseIterable {
        case csv = "CSV"
        case image = "圖片"
    }
    
    var body: some View {
        NavigationView {
            Form {
                Picker("導出格式", selection: $selectedFormat) {
                    ForEach(ExportFormat.allCases, id: \.self) { format in
                        Text(format.rawValue).tag(format)
                    }
                }
                
                Button("導出") {
                    exportSchedule()
                }
            }
            .navigationTitle("導出選項")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func exportSchedule() {
        switch selectedFormat {
        case .csv:
            exportToCSV()
        case .image:
            exportToImage()
        }
    }
    
    private func exportToCSV() {
        var csvString = "日期,服務類型,WL,Drum/Percussion,Bass,Piano,AG,EG/Violin,SINGER,Rap,Sound,PPT\n"
        
        for event in events {
            let date = formatDate(event.date)
            let serviceType = event.serviceType.rawValue
            var roles: [String: String] = [:]
            
            for assignment in event.assignments {
                let memberNames = assignment.memberIds.compactMap { memberId in
                    members.first(where: { $0.id == memberId })?.name
                }.joined(separator: ", ")
                roles[assignment.role.rawValue] = memberNames
            }
            
            let rowString = "\(date),\(serviceType),\(roles["WL"] ?? ""),\(roles["Drum/Percussion"] ?? ""),\(roles["Bass"] ?? ""),\(roles["Piano"] ?? ""),\(roles["AG"] ?? ""),\(roles["EG/Violin"] ?? ""),\(roles["SINGER"] ?? ""),\(roles["Rap"] ?? ""),\(roles["Sound"] ?? ""),\(roles["PPT"] ?? "")\n"
            csvString += rowString
        }
        
        // 在這裡處理CSV導出
        print(csvString)
        dismiss()
    }
    
    private func exportToImage() {
        // 在這裡處理圖片導出
        print("導出為圖片")
        dismiss()
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: date)
    }
}
