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
    
    func draggable() -> some View {
        modifier(DragGestureCustom())
    }
}



struct DragGestureCustom: ViewModifier{
    
    
    @State var isDragging = false
    @State var currentOffsetX: CGFloat = 0
    @State var currentOffsetY: CGFloat = 0
    
    var drag: some Gesture{
        DragGesture()
            .onChanged({ value in
                withAnimation {
                    currentOffsetX = value.translation.width
                    currentOffsetY = value.translation.height
                    isDragging.toggle()
                }
            })
            .onEnded { _ in
                withAnimation(.spring()) {
                    isDragging.toggle()
                    currentOffsetX = 0
                    currentOffsetY = 0
                }
            }
    }
    
    func body(content: Content) -> some View {
              content
            .offset(x: currentOffsetX)
            .offset(y: currentOffsetY)
            .gesture(drag)
    }
}
