//
//  AppleAuthorizationButton.swift
//  Saver
//
//  Created by Oleh Dovhan on 14.01.2023.
//

import AuthenticationServices
import UIKit

class AppleAuthorizationVC: UIViewController {

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
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.email, .fullName]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }

}

extension AppleAuthorizationVC: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("failed")
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let credentials as ASAuthorizationAppleIDCredential:
           if let firstName = credentials.fullName?.givenName,
            let secondName = credentials.fullName?.familyName,
              let email = credentials.email {
               // TODO: - create USER in UD and then in REALM
               if UserDefaultsManager.shared.userModel == nil {
                   UserDefaultsManager.shared.userModel =
                   UserModel(avatarImgName: "person.circle",
                             name: firstName + " " + secondName,
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
                   
                   if let closure = closure { closure() }
               }
           }
        default: break
        }
    }
}

extension AppleAuthorizationVC: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
}
