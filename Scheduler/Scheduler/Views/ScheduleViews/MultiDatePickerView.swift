//
//  MultiDatePickerView.swift
//  Scheduler
//
//  Created by Levi Y.C. Chow on 2024/11/29.
//
import SwiftUI

struct MultiDatePickerView: View {
    @Binding var selectedDates: Set<Date>
    @Environment(\.dismiss) var dismiss
    @State private var currentDate = Date()
    
    var body: some View {
        NavigationView {
            List {
                DatePicker("選擇日期", selection: $currentDate, displayedComponents: .date)
                    .datePickerStyle(.graphical)
                    .onChange(of: currentDate) { _, newDate in
                        if selectedDates.contains(newDate) {
                            selectedDates.remove(newDate)
                        } else {
                            selectedDates.insert(newDate)
                        }
                    }
            }
            .navigationTitle("選擇多個日期")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("完成") {
                        dismiss()
                    }
                }
            }
        }
    }
}
