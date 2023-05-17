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
    
    // Create an instance of MusicViewModel
    let musicViewModel = MusicViewModel()
    
    var body: some Scene {
        WindowGroup {
           // RootView()
              //  .environment(\.managedObjectContext, persistenceController.container.viewContext)
          //  MusicPlayerHomeView()
           // .environmentObject(musicViewModel)
            RootView()
                            .environmentObject(musicViewModel)
        }
    }
}
