//
//  RegistrationViewModel.swift
//  Saver
//
//  Created by Pryshliak Dmytro on 14.01.2023.
//

import Firebase
import SwiftUI

class RegistrationViewModel: ObservableObject {
    
    @Published var createAccountOnceTapped = false
    @Published var correctEmail: RegistrationTFState = .validated
    @Published var correctPassword: RegistrationTFState = .validated
    @Published var validatedPrivacy: RegistrationTFState = .validated
    
    @Published var email = ""
    @Published var password = ""
    @Published var repeatPassword = ""
    
    @Published var privacyTermsAccepted =    false
    @Published var emailIsEditing =          false
    @Published var passwordIsEditing =       false
    @Published var repeatPasswordIsEditing = false
    @Published var willMoveToLogin =         false
    @Published var willMoveToTabBar =        false
    var ref: DatabaseReference!
    
    func registerUser() {
        print(email)
        print(password)
//      willMoveToTabBar = true
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] (user, error) in
            
            guard error == nil, let newUser = user?.user else {
                print(error?.localizedDescription ?? "")
                return
            }
            
            let currentUser = UserFirModel(user: newUser)
            let userRef = self?.ref.child(currentUser.uid)
            
            guard let img = UIImage(named: "avatar") else { return }
            FirebaseUserManager.shared.uploadImage(img: img) { urlStringToImage in
                guard let urlString = urlStringToImage else { return }
                
                 let dataUserModel = UserModel(avatarUrlString: urlString,
                                               name: "Noname user",
                                               email: self?.email ?? "",
                                               registrationDate: Int(Date().millisecondsSince1970),
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
                
                userRef?.setValue(["userDataModel": dataUserModel.createDic()])
            }
        }
    }
}

protocol ValidateInputProtocol {
    func passwordIsCorrect() -> RegistrationTFState
    func inputValidated() -> Bool
}

extension RegistrationViewModel: ValidateInputProtocol {
    
    func passwordIsCorrect() -> RegistrationTFState {
        return .validated
    }
    
    func inputValidated() -> Bool {
        
        switch email.count {
        case let x where x > 1:
            let emailValidatedBool = email.textFieldValidatorEmail()
            switch emailValidatedBool {
            case true:  correctEmail = .validated
            case false: correctEmail = .incorrectEmailFormat
            }
        default: correctEmail = .empty
        }
     
        switch password {
        case let x where x == repeatPassword && x.count >= 8: correctPassword = .validated
        case let x where x.count < 8:                         correctPassword = .lessThanSymbols(count: 8)
        case let x where x != repeatPassword:                 correctPassword = .passwordsDoNotMatch
        default: break
        }
        
        switch privacyTermsAccepted {
        case true:  validatedPrivacy = .validated
        case false: validatedPrivacy = .empty
        }
       
        let validated = correctEmail == .validated &&
        correctPassword == .validated && validatedPrivacy == .validated
        return validated
    }
}
