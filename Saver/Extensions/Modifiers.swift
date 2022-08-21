//
//  Modifiers and Extensions.swift
//  Saver
//
//  Created by Пришляк Дмитро on 21.08.2022.
//


import SwiftUI

struct ShadowCustom : ViewModifier{
    var radiusShadow: Int
    func body(content: Content) -> some View {
        content
            .shadow(color: .black.opacity(0.15), radius: CGFloat(radiusShadow), x: 0, y: 0)
    }
}


extension View {
    
    func myShadow(radiusShadow: Int) -> some View{
        modifier(ShadowCustom(radiusShadow: radiusShadow))
    }
    
    
    
}

