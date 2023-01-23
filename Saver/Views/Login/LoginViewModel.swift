//
//  LoginViewModel.swift
//  Saver
//
//  Created by Pryshliak Dmytro on 14.01.2023.
//

import Firebase
import Foundation

class LoginViewModel: ObservableObject {
    @Published var progress = false
    
    @Published var incorrectEmail = true
    @Published var incorrectPassword = true
    
    @Published var errorMessage = false
    
    @Published var loginIsEditing = false
    @Published var passwordIsEditing = false

    @Published var willMoveToApp = false
    
    
    func login(login: String, password: String) {
        
        incorrectEmail = login.textFieldValidatorEmail()
        incorrectPassword = password.count > 0
        
        if login.textFieldValidatorEmail() && password.count > 0 {
            self.progress = true
            self.errorMessage = false
            Auth.auth().signIn(withEmail: login, password: password) { [weak self]  (user, error) in
                if error != nil {
                    print(error?.localizedDescription)
                    self?.errorMessage = true
                    self?.progress = false
                }
                if user != nil {
                    self?.willMoveToApp = true
                    self?.progress = false
                }
            }
            print(login)
            print(password)
            print("stop")
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
