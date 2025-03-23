//
//  SCHEDULERApp.swift
//  SCHEDULER
//
//  Created by Levi Y.C. Chow on 2025/2/16.
//

import SwiftUI

@main
struct SCHEDULERApp: App {
    let persistenceController = CoreDataManager.shared

    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, persistenceController.context)
        }
    }
}
