//
//  CardsPlace.swift
//  Saver
//
//  Created by Пришляк Дмитро on 21.08.2022.
//

import SwiftUI

struct CardsPlace: View{
    
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
    
    
    var body: some View{
        
        ZStack{
//            Color.purple.opacity(0.2)
            //Cards
            HStack(spacing: 16){
                
                Button {
                    print("Bank card")
                } label: {
                    VStack(spacing: 5){
                        Text("Bank card")
                            .foregroundColor(.black)
                            .font(.custom("Lato-Regular", size: 12, relativeTo: .body))
                        
                        Image("iconBankCard")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .myShadow(radiusShadow: 5)
                        
                        Text("+30.000")
                            .foregroundColor(.black)
                            .font(.custom("Lato-Regular", size: 12, relativeTo: .body))
                    }
                    .offset(x: currentOffsetX)
                    .offset(y: currentOffsetY)
                    .gesture(drag)
                }
                
            
                
                Button {
                    print("Wallet")
                } label: {
                    VStack(spacing: 5){
                        Text("Wallet")
                            .foregroundColor(.black)
                            .font(.custom("Lato-Regular", size: 12, relativeTo: .body))
                        
                        Image("iconWallet")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .myShadow(radiusShadow: 5)
                        
                        Text("+15.000")
                            .foregroundColor(.black)
                            .font(.custom("Lato-Regular", size: 12, relativeTo: .body))
                    }
                }
      
                
                Button {
                    print("new card")
                } label: {
                    VStack{
                        
                        Image("iconPlus")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .myShadow(radiusShadow: 5)
                        
                        
                    }
                }
               
                
                Spacer()
            }
            .padding(EdgeInsets(top: 20, leading: 30, bottom: 20, trailing: 30))
           
        }
    }
}
