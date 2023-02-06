//
//  LoginViewModel.swift
//  Saver
//
//  Created by Pryshliak Dmytro on 14.01.2023.
//

import Firebase
import Foundation
import FirebaseCore
import GoogleSignIn

class LoginViewModel: ObservableObject {
    @Published var progress = false
    
    @Published var incorrectEmail = true
    @Published var incorrectPassword = true
    
    @Published var errorMessage = false
    
    @Published var loginIsEditing = false
    @Published var passwordIsEditing = false

    @Published var willMoveToApp = false
    
    func signInGoogle() {
        self.progress = true
        self.errorMessage = false
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        // Start the sign in flow!
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        guard let rootViewController = windowScene.windows.first?.rootViewController else { return }
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { [unowned self] (signResult, error) in

          if let error = error {
            // ...
            return
          }
            guard let user = signResult?.user,
                  let idToken = user.idToken else { return }
            
            let accessToken = user.accessToken
                   
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)
            Auth.auth().signIn(with: credential) { [weak self] authResult, error in
                if error != nil {
                    print(error?.localizedDescription)
                    self?.errorMessage = true
                    self?.progress = false
                }
                if authResult != nil {
                    self?.willMoveToApp = true
                    self?.progress = false
                }
            }
        }
    }
    
    
    
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
        }
    }
}
