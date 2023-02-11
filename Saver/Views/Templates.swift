//
//  Templates.swift
//  Saver
//
//  Created by Oleh on 10.02.2023.
//

import SwiftUI

struct SublayerView: View{
    var body: some View{
        Color(hex: "C4C4C4").opacity(0.7)
            .ignoresSafeArea()
//            .onTapGesture {
//                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
//            }
    }
}

struct WhiteCanvasView: View{
    var width: CGFloat
    var height: CGFloat
    
    let gradient = LinearGradient(colors: [.myGreen, .myBlue],
                                  startPoint: .topLeading,
                                  endPoint: .bottomTrailing)
    var body: some View{
        ZStack{
            Color.white
                .frame(width: width,
                       height: height)
            VStack{
                Rectangle().fill(gradient)
                    .frame(width: width, height: wRatio(60))
                Spacer()
            }
            .frame(width: width,
                   height: height)
        }
        .cornerRadius(25)
        .shadow(radius: 25)
    }
}

struct CloseSelfButtonView: View{
    @Binding var closeSelf: Bool
    init(_ closeSelf: Binding<Bool>) {
        self._closeSelf = closeSelf
    }
    var body: some View{
        Button {
            closeSelf = false
        } label: {
            Image("btnClose")
                .resizable()
                .frame(width: wRatio(40), height: wRatio(40))
//                .myShadow(radiusShadow: 2)
        }
    }
}

struct DeleteSelfButtonView: View{
    let action: () -> Void
    
    var body: some View{
        Button(role: .destructive) {
            action()
        } label: {
            ZStack{
                Circle()
                    .fill(.red)
                    .myShadow(radiusShadow: 5)
                    .frame(width: wRatio(27))
                
                
                Image(systemName: "trash")
                    .resizable()
                    .frame(width: wRatio(15), height: wRatio(20))
                    .foregroundColor(.white)
            }
            
        }
        
    }
}

struct DoneButtonView: View{
    var isValid: Bool
    let action: () -> Void
    
    var body: some View{
        Button {
            action()
        } label: {
            Image(isValid ? "btnDoneInactive" : "btnDone")
                .resizable()
                .frame(width: wRatio(50), height: wRatio(50))
                .myShadow(radiusShadow: 5)
        }
    }
    
}
