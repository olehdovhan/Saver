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
    
    func registerUser() {
        print(email)
        print(password)
//        willMoveToTabBar = true
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] (user, error) in
            if error == nil {
                if user != nil {
                    self?.willMoveToTabBar = true
                }
            } else {
                print(error?.localizedDescription)
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
