//
//  ForgotPasswordViewModel.swift
//  Saver
//
//  Created by Pryshliak Dmytro on 15.01.2023.
//

import Foundation
import Firebase

class ForgotPasswordViewModel: ObservableObject {
    
    @Published var incorrectEmail = true
    @Published var progress = false
    @Published var errorMessage = ""
    @Published var showErrorMessage = false
    
    @Published var createAccountOnceTapped = false
    @Published var email = ""
    @Published var emailIsEditing =          false
    @Published var correctEmail: RegistrationTFState = .validated
    
    func resetEmail(email: String, completion: @escaping ()->()) {
        incorrectEmail = email.textFieldValidatorEmail()
        guard incorrectEmail else { return }
        Auth.auth().sendPasswordReset(withEmail: email) { [weak self] error in
            if let error = error {
                self?.errorMessage = error.localizedDescription
                self?.showErrorMessage = true
            } else {
                self?.errorMessage = "A password reset email has been sent."
                self?.showErrorMessage = true
                completion()
            }
        }
        
//        if email.textFieldValidatorEmail() {
//            progress = true
//            let mutation = PasswordForgotRequestMutation(email: email.lowercased())
//            let _ = Network.shared.mutation(model: PasswordForgotRequestModel.self, mutation) {[weak self] model in
//                self?.progress = false
//                completion()
//            } failureHandler: { [weak self] error, message  in
//                self?.progress = false
//                self?.showErrorMessage = true
//                self?.errorMessage = message ?? error.localizedDescription
//            }
//        }
    }
}


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




