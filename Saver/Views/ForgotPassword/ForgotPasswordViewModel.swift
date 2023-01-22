//
//  ForgotPasswordViewModel.swift
//  Saver
//
//  Created by Pryshliak Dmytro on 15.01.2023.
//

import Foundation

class ForgotPasswordViewModel: ObservableObject {
    
    @Published var incorrectEmail = true
    @Published var createAccountOnceTapped = false
    @Published var email = ""
    @Published var emailIsEditing =          false
    @Published var correctEmail: RegistrationTFState = .validated
    
    func resetEmail(email: String, completion: @escaping ()->()) {
        incorrectEmail = email.textFieldValidatorEmail()
    }
    
}

// MARK: - ValidateInputProtocol
extension ForgotPasswordViewModel: ValidateInputProtocol {
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
     
        let validated = correctEmail == .validated
        return validated
    }
    
}




