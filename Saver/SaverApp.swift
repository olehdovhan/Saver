//
//  SaverApp.swift
//  Saver
//
//  Created by O l e h on 20.08.2022.
//

import SwiftUI
import Combine

@main
struct SaverApp: App {
    
    let persistenceController = PersistenceController.shared

    @Environment(\.scenePhase) var scenePhase
    
    var body: some Scene {
        WindowGroup {
            AuthView()
        }
    }
}
