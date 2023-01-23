//
//  AuthTextfieldModifier.swift
//  Saver
//
//  Created by Pryshliak Dmytro on 14.01.2023.
//

import Foundation

import SwiftUI

struct AuthTextFieldModifier: ViewModifier {
    
    var isEditing: Bool
    var vState: RegistrationTFState
    var color: Color { vState == .validated ? .clear : .red }
    
    func body(content: Content) -> some View {
            content
            .font(FontType.latoRegular.font(size: 20))
            .multilineTextAlignment(.center)
            .padding(13)
            .frame(height: 40)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.myGrayDark,
                                    lineWidth: 0.5))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(isEditing ? .myGreen : color,
                                    lineWidth: 2)) )
            .padding(.horizontal, 2)

    }
}

// MARK: - AuthTextField
extension View {
    func authTextField(
        isEditing: Bool,
        vState: RegistrationTFState
    ) -> some View {
        modifier(AuthTextFieldModifier(
            isEditing: isEditing,
            vState: vState))
        
    }
}
