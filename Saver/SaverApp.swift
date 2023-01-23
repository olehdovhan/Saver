//
//  SaverApp.swift
//  Saver
//
//  Created by O l e h on 20.08.2022.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct SaverApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            NavigationView{
                TabBarView()
            }
//            if UserDefaultsManager.shared.userModel == nil {
//                AuthView()
//            } else {
//                TabBarView()
//            }
        }
    }
}
  
