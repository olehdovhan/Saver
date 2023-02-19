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
                return
            }
            guard let user = signResult?.user,
                  let idToken = user.idToken else { return }
            
            let accessToken = user.accessToken
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)
            Auth.auth().signIn(with: credential) { [weak self] authResult, error in
                
                if let firstSignIn = authResult?.additionalUserInfo?.isNewUser,
                   firstSignIn {
                    print("WWWWWwork")
                }
                
                if let currentUser = Auth.auth().currentUser {
                    let firUser = UserFirModel(user: currentUser)
                    let userRef = Database.database().reference(withPath: "users")
                    userRef.child(firUser.uid).observe(.value) { snapshot in
                        if !snapshot.exists() {
                            guard let img = UIImage(named: "avatar") else { return }
                            FirebaseUserManager.shared.uploadImage(img: img) { urlStringToImage in
                                guard let urlString = urlStringToImage else { return }
                                
                                let dataUserModel = UserModel(avatarUrlString: urlString,
                                                              name: "Noname user",
                                                              email: firUser.email,
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
                                userRef.child(firUser.uid).setValue(["userDataModel": dataUserModel.createDic()])
                            }
                            print("hasn`t child")
                        }
                    }
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
                        if let firstSignIn = user?.additionalUserInfo?.isNewUser,
                           firstSignIn {
                            print("WWWWWwork")
                        }
                        self?.progress = false
                    }
                }
            }
        }
    }
