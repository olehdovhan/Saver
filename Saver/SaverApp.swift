//
//  SaverApp.swift
//  Saver
//
//  Created by O l e h on 20.08.2022.
//

import SwiftUI

@main
struct SaverApp: App {
    let persistenceController = PersistenceController.shared

    @Environment(\.scenePhase) var scenePhase
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }.onChange(of: scenePhase) { newScenePhase in
            switch newScenePhase {
            case .background: print("App State: Background")
            case .inactive:
                if UserDefaultsManager.shared.userModel == nil {
                    UserDefaultsManager.shared.userModel = UserModel(avatarSystemName: "person.circle",
                                                                     name: "user",
                                                                     registrationDate: Date())
                    print("writed down")
                } 
            case .active:       print("App State: Active")
                print(UserDefaultsManager.shared.userModel)
            @unknown default:   print("App State: Unknown")
            }
        }
    }
}
