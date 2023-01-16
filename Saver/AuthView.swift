//
//  AuthView.swift
//  Saver
//
//  Created by Oleh Dovhan on 14.01.2023.
//

import AuthenticationServices
import SwiftUI

struct AuthView: View {
    
    @State private var willMoveToNextScreen = false
    
    var body: some View {
        VStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            AuthButton {
                willMoveToNextScreen = true
            }
         
                .frame(width: 250, height: 50)
        }
                .navigate(to: TabBarView(), when: $willMoveToNextScreen)
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
    }
}


