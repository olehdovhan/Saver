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
            ContentView()
        }.onChange(of: scenePhase) { newScenePhase in
            switch newScenePhase {
            case .background: print("App State: Background")
            case .inactive:
                if UserDefaultsManager.shared.userModel == nil {
                    UserDefaultsManager.shared.userModel =  UserModel(avatarSystemName: "person.circle",
                                                                     name: "user",
                                                                      registrationDate: Date(),
                                                                      cashSources: [CashSource(name: "Bank card",
                                                                                               amount: 0.0,
                                                                                               iconName: "iconBankCard"),
                                                                                      CashSource(name: "Wallet",
                                                                                                 amount: 0.0,
                                                                                                 iconName: "iconWallet")],
                                                                      expenseCategories: [ExpenseCategory(name: "Products",
                                                                                                          iconName: "iconProducts"),
                                                                                           ExpenseCategory(name: "Transport",
                                                                                                           iconName: "iconTransport"),
                                                                                          ExpenseCategory(name: "Clothing",
                                                                                                          iconName: "iconClothing"),
                                                                                          ExpenseCategory(name: "Restaurant",
                                                                                                          iconName: "iconRestoran")])
                    print("writed down")
                } 
            case .active:       print("App State: Active")
                                print(UserDefaultsManager.shared.userModel)
            @unknown default:   print("App State: Unknown")
            }
        }
    }
}
