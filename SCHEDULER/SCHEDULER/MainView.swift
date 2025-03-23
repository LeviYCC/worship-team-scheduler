//
//  MainView.swift
//  SCHEDULER
//
//  Created by Levi Y.C. Chow on 2025/2/18.
//
import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: MemberManagementView()) {
                    Text("成員管理")
                }
                NavigationLink(destination: TeamSetupView()) {
                    Text("團隊配置設定")
                }
                NavigationLink(destination: ScheduleManagementView()) {
                    Text("排班管理")
                }
            }
            .navigationTitle("SCHEDULER")
        }
    }
}
