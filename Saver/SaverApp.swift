//
//  SaverApp.swift
//  Saver
//
//  Created by O l e h on 20.08.2022.
//

import SwiftUI
import FirebaseCore
import Firebase
import GoogleSignIn


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
    func application(_ application: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any])
      -> Bool {
      return GIDSignIn.sharedInstance.handle(url)
    }
}

@main
struct SaverApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @State var userState = UserState.registeredUnauthorized
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                switch userState {
                case .registeredAuthorized:
                    TabBarView()
                case .registeredUnauthorized:
                    LoginView()
                case .unRegistered:
                    RegistrationView()
                }
            }
            .onAppear() {
                Auth.auth().addStateDidChangeListener { (auth, user) in
                    if user != nil {
                        userState = .registeredAuthorized
                    } else {
                        userState = .registeredUnauthorized
                    }
                }
            }
        }
    }
}

enum UserState {
    case registeredAuthorized, registeredUnauthorized, unRegistered
}

  
