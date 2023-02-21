//
//  AuthButton.swift
//  Saver
//
//  Created by Oleh Dovhan on 14.01.2023.
//

import SwiftUI


struct AuthWithAppleButton: UIViewControllerRepresentable {

    var closure: () -> ()
    
    func makeUIViewController(context: Context) -> AppleAuthorizationVC {
        let vc = AppleAuthorizationVC()
        vc.closure = closure
        return vc 
    }
    
    func updateUIViewController(_ uiViewController: AppleAuthorizationVC, context: Context) {
        
    }
}
