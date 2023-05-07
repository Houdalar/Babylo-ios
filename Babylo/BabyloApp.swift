//
//  BabyloApp.swift
//  Babylo
//
//  Created by houda lariani on 15/3/2023.
//

import SwiftUI

@main
struct BabyloApp: App {
    let persistenceController = PersistenceController.shared

    init() {
            NotificationManager.shared.requestAuthorization()
        }

    var body: some Scene {
        WindowGroup {
             RootView()
            
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
            

        }
    }
}
