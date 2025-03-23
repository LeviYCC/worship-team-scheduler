//
//  MemberPickerView.swift
//  SCHEDULER
//
//  Created by Levi Y.C. Chow on 2025/2/18.
//
import SwiftUI
import CoreData

struct MemberPickerView: View {
    let role: String
    let members: FetchedResults<Member>
    var selectedMember: (Member) -> Void

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            List(members) { member in
                Button(action: {
                    selectedMember(member)
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack {
                        Text(member.name ?? "未知")
                        Spacer()
                        Text(member.role ?? "").foregroundColor(.gray)
                    }
                }
            }
            .navigationTitle("選擇 \(role) 的成員")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}
