//
//  AppleAuthorizationButton.swift
//  Saver
//
//  Created by Oleh Dovhan on 14.01.2023.
//

import AuthenticationServices
import UIKit
import CryptoKit
import Firebase
import FirebaseCore

class AppleAuthorizationVC: UIViewController {
    
    fileprivate var currentNonce: String?

    private let signInButton = ASAuthorizationAppleIDButton()
    var closure: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(signInButton)
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        signInButton.frame = view.layer.frame
        signInButton.center = view.center
    }
    
    @objc func didTapSignIn() {
        
        let nonce = randomNonceString()
        currentNonce = nonce
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.email, .fullName]
        request.nonce = sha256(nonce)
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
    private func randomNonceString(length: Int = 32) -> String {
      precondition(length > 0)
      let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
      var result = ""
      var remainingLength = length

      while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
          var random: UInt8 = 0
          let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
          if errorCode != errSecSuccess {
            fatalError(
              "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
          }
          return random
        }

        randoms.forEach { random in
          if remainingLength == 0 {
            return
          }

          if random < charset.count {
            result.append(charset[Int(random)])
            remainingLength -= 1
          }
        }
      }

      return result
    }
    
    private func sha256(_ input: String) -> String {
      let inputData = Data(input.utf8)
      let hashedData = SHA256.hash(data: inputData)
      let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
      }.joined()

      return hashString
    }
    
    private func addUserModelInRealtimeDatabase(appleIDCredential: ASAuthorizationAppleIDCredential, firUser: UserFirModel) {
        if let email = appleIDCredential.email {
            if let firstName = appleIDCredential.fullName?.givenName,
               let secondName = appleIDCredential.fullName?.familyName {
                let dataUserModel = UserModel(avatarImgName: "person.circle",
                                              name: firstName + " " + secondName ,
                                              email: email,
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

                Database.database().reference(withPath: "users").child(firUser.uid).setValue(["userDataModel": dataUserModel.createDic()])
            } else {
                let dataUserModel = UserModel(avatarImgName: "person.circle",
                                              name: "noName User",
                                              email: email,
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

                Database.database().reference(withPath: "users").child(firUser.uid).setValue(["userDataModel": dataUserModel.createDic()])
            }
        } else {
      let dataUserModel = UserModel(avatarImgName: "person.circle",
                                    name: "NoName user" ,
                                    email: "email is absent",
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

      Database.database().reference(withPath: "users").child(firUser.uid).setValue(["userDataModel": dataUserModel.createDic()])
        }
    }
}

extension AppleAuthorizationVC: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("failed")
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
          guard let nonce = currentNonce else {
            fatalError("Invalid state: A login callback was received, but no login request was sent.")
          }
          guard let appleIDToken = appleIDCredential.identityToken else {
            print("Unable to fetch identity token")
            return
          }
          guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
            return
          }
          // Initialize a Firebase credential.
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                    idToken: idTokenString,
                                                    rawNonce: nonce)
          // Sign in with Firebase.
          Auth.auth().signIn(with: credential) { (authResult, error) in
              if let error = error {
                  print(error.localizedDescription)
              }
              guard let currentUser = Auth.auth().currentUser else { return }
              let firUser = UserFirModel(user: currentUser)
              let userRef = Database.database().reference(withPath: "users")
              userRef.child(firUser.uid).observe(.value) { [weak self] snapshot in
                  if !snapshot.exists() {
                      self?.addUserModelInRealtimeDatabase(appleIDCredential: appleIDCredential, firUser: firUser)
                  }
              }
          }
        }
    }
}

extension AppleAuthorizationVC: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
}
