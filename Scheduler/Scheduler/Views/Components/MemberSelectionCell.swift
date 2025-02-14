//
//  MemberSelectionCell.swift
//  Scheduler
//
//  Created by Levi Y.C. Chow on 2024/11/29.
//
import SwiftUI

struct MemberSelectionCell: View {
    let assignment: RoleAssignment
    let members: [BandMember]
    @Binding var selectedMemberId: UUID?
    
    var body: some View {
        if assignment.role == .singer {
            VStack {
                ForEach(assignment.memberIds, id: \.self) { memberId in
                    Menu {
                        ForEach(members) { member in
                            Button(member.name) {
                                selectedMemberId = member.id
                            }
                        }
                    } label: {
                        Text(members.first(where: { $0.id == memberId })?.name ?? "選擇成員")
                            .foregroundColor(.blue)
                    }
                }
            }
        } else {
            Menu {
                ForEach(members) { member in
                    Button(member.name) {
                        selectedMemberId = member.id
                    }
                }
            } label: {
                Text(members.first(where: { $0.id == selectedMemberId })?.name ?? "選擇成員")
                    .foregroundColor(.blue)
            }
        }
    }
}
