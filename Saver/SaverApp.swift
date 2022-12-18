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
                    UserDefaultsManager.shared.userModel =
                    UserModel(avatarSystemName: "person.circle",
                              name: "user",
                              registrationDate: Date(),
                              cashSources: [CashSource(name: "Bank card",
                                                      amount: 0.0,
                                                      iconName: "iconBankCard"),
                                             CashSource(name: "Wallet",
                                                        amount: 0.0,
                                                        iconName: "iconWallet")],
                              purchaseCategories: [PurchaseCategory(name: "Products",iconName: "iconProducts"),
                                                  PurchaseCategory(name: "Transport", iconName: "iconTransport"),
                                                  PurchaseCategory(name: "Clothing", iconName: "iconClothing"),
                                                  PurchaseCategory(name: "Restaurant",iconName: "iconRestaurant"),
                                                  PurchaseCategory(name: "Household", iconName: "iconHousehold"),
                                                  PurchaseCategory(name: "Entertainment", iconName: "iconEntertainment"),
                                                  PurchaseCategory(name: "Health", iconName: "iconHealth")],
                              debts: [DebtModel(whose: .took,
                                                totalAmount: 1000,
                                                startDate: Date(),
                                                totalMonthesForReturn: 2,
                                                returnedAmount: 0),
                                      DebtModel(whose: .gave,
                                                totalAmount: 300,
                                                startDate: Date(),
                                                totalMonthesForReturn: 3,
                                                returnedAmount: 100)] ,
                              saver: 0,
                              goals: [Goal(name: "Audi TT",
                                           totalPrice: 7000,
                                           collectedPrice: 0,
                                           collectingSumPerMonth: 1000),
                                      Goal(name: "Iphone 11",
                                           totalPrice: 500,
                                           collectedPrice: 0,
                                           collectingSumPerMonth: 250),
                                      Goal(name: "Graywell bike",
                                           totalPrice: 1000,
                                           collectedPrice: 0,
                                           collectingSumPerMonth: 500)])
                     }
            case .active:       print("App State: Active")
                                print(UserDefaultsManager.shared.userModel)
            @unknown default:   print("App State: Unknown")
            }
        }
    }
}
