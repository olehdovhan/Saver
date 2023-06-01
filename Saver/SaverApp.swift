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
    
    @State private var userState = UserState.unAuthorized
    @State private var progress = false 
    
    var body: some Scene {
        WindowGroup {
            NavigationView{
                ZStack{
                    switch userState {
                    case .signedIn:
                        TabBarView()
                    case .showOnboarding:
                        OnboardingView(userState: $userState)
                    case .registration:
                        RegistrationView()
                    case .unAuthorized:
                        LoginView()
                    }
                }
                .navigationBarHidden(true)
                .overlay(overlayView: CustomProgressView(), show: $progress)                
                .onAppear() {

                    Auth.auth().addStateDidChangeListener { (auth, user) in
                        if user != nil {
                                userState = .signedIn
                                progress = false
                        } else {
                            if FirebaseUserManager.shared.finishedOnboarding {
                                userState = .unAuthorized
                                progress = false
                            } else {
                                userState = .showOnboarding
                                progress = false
                            }
                        }
                    }
                }
            }
        }
    }
}

enum UserState {
    case signedIn, showOnboarding, registration, unAuthorized
}

