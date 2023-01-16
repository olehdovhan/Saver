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
            let firstName = credentials.fullName?.givenName
            let secondName = credentials.fullName?.familyName
            let email = credentials.email
            // TODO: - create USER in UD and then in REALM
            print(email)
            print(firstName)
            print(secondName)
            print("")
            if let closure = closure { closure() }
        default: break
        }
    }
    
}

extension AppleAuthorizationVC: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
}
