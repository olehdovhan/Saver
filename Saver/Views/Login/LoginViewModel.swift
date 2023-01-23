//
//  LoginViewModel.swift
//  Saver
//
//  Created by Pryshliak Dmytro on 14.01.2023.
//

import Foundation

class LoginViewModel: ObservableObject {
    @Published var progress = false
    
    @Published var incorrectEmail = true
    @Published var incorrectPassword = true
    
    @Published var errorMessage = false
    
    @Published var loginIsEditing = false
    @Published var passwordIsEditing = false
    
    func login(
        login: String,
        password: String
    ) {
        incorrectEmail = login.textFieldValidatorEmail()
        incorrectPassword = password.count > 0
        
        if login.textFieldValidatorEmail() && password.count > 0 {
            progress = true
            errorMessage = false
//            RestAuth().login(login: login.lowercased(), password: password) { [weak self] model in
//                self?.progress = false
//                KeychainService.standard.newAuthToken = model
//                BaseManager.sharedInstance.getMe()
//                NotificationCenter.default.post(name: Notifications.updateLaunchScreenNotification, object: self)
//            } failure: { [weak self] error, message in
//                self?.progress = false
//                self?.errorMessage = true
//            }
            
            
            
            
        }
    }
}
