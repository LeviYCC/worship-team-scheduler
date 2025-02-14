//
//  MemberManagementView.swift
//  Scheduler
//
//  Created by Levi Y.C. Chow on 2024/11/27.
//
import SwiftUI

struct MemberManagementView: View {
    @Binding var members: [BandMember]
    @State private var newMemberName = ""
    @State private var selectedInstruments: Set<String> = []
    
    let instruments = ["WL(吉他)", "WL(鋼琴)", "吉他", "鋼琴", "電吉他", "貝斯", "鼓", "小提琴", "歌手", "PPT", "音控"]
    
    var body: some View {
        VStack {
            List {
                ForEach(members) { member in
                    VStack(alignment: .leading) {
                        Text(member.name).font(.headline)
                        Text("樂器: \(member.instruments.joined(separator: ", "))")
                    }
                }
                .onDelete(perform: deleteMember)
            }
            
            Divider()
            
            VStack(spacing: 10) {
                TextField("姓名", text: $newMemberName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading) {
                        ForEach(instruments, id: \.self) { instrument in
                            Toggle(instrument, isOn: Binding(
                                get: { selectedInstruments.contains(instrument) },
                                set: { isSelected in
                                    if isSelected {
                                        selectedInstruments.insert(instrument)
                                    } else {
                                        selectedInstruments.remove(instrument)
                                    }
                                }
                            ))
                        }
                    }
                }
                .frame(height: 200)
                
                Button("新增成員") {
                    addMember()
                }
                .disabled(newMemberName.isEmpty || selectedInstruments.isEmpty)
            }
            .padding()
        }
    }
    
    private func addMember() {
        let newMember = BandMember(
            id: UUID(),
            name: newMemberName,
            instruments: Array(selectedInstruments),
            availability: [:]
        )
        members.append(newMember)
        newMemberName = ""
        selectedInstruments = []
    }
    
    private func deleteMember(at offsets: IndexSet) {
        members.remove(atOffsets: offsets)
    }
}
