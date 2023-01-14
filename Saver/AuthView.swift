//
//  AuthView.swift
//  Saver
//
//  Created by Oleh Dovhan on 14.01.2023.
//

import AuthenticationServices
import SwiftUI

struct AuthView: View {
    
    @State private var willMoveToNextScreen = false
    
    var body: some View {
        VStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            SignInWithAppleButton(.signIn) { request in
                request.requestedScopes = [.fullName, .email]
            } onCompletion: { result in
                switch result {
                case .success(let authResults):
                    switch authResults.credential {
                    case let credentials as ASAuthorizationAppleIDCredential:
                        print(credentials)
                        print(credentials.fullName?.givenName)
                        print(credentials.email)
                        if let firstName = credentials.fullName?.givenName,
                              let secondName = credentials.fullName?.familyName,
                              let email = credentials.email,
                              UserDefaultsManager.shared.userModel == nil  {
                        UserDefaultsManager.shared.userModel =
                        UserModel(avatarSystemName: "person.circle",
                                  name: "\(firstName) \(secondName)",
                                  email: email,
                                  //TODO: -
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
                                                       PurchaseCategory(name: "Health", iconName: "iconHealth")])
                        }
                        
                        willMoveToNextScreen = true
                        
                    default: break
                    }
                case let error as Error:
                    print("Authorisation failed: \(error.localizedDescription)")
                case .failure(_): print("fail")
                }
            }
            .frame(width: 300, height: 50)
            // black button
            .signInWithAppleButtonStyle(.black)
            //            // white button
            //            .signInWithAppleButtonStyle(.white)
            //            // white with border
            //            .signInWithAppleButtonStyle(.whiteOutline)
        }
        .navigate(to: TabBarView(), when: $willMoveToNextScreen)
        
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
    }
}


