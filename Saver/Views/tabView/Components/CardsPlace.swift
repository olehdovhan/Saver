//
//  CardsPlace.swift
//  Saver
//
//  Created by Пришляк Дмитро on 21.08.2022.
//

import SwiftUI

struct CardsPlace: View{
    
    @State var firstZ: Double = 3
    @State var secondZ: Double = 2
    @State var thirdZ: Double = 1
    
    var body: some View{
        GeometryReader{ geo in
        ZStack{
//            Color.purple.opacity(0.2)
            //Cards
            HStack(spacing: 16){
                
                Button {
                    print("Bank card")
                    print(PurchaseLocation.standard.locations)
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
                    .draggable(zIndex: $firstZ)
                }
                .zIndex(firstZ)
              
                
                
                
                
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
                    .draggable(zIndex: $secondZ)
                }
                .zIndex(secondZ)
                
                Button {
                    print("new card")
                } label: {
                    VStack{
                        Image("iconPlus")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .myShadow(radiusShadow: 5)
                    }
                    .draggable(zIndex: $thirdZ)
                }
                .zIndex(thirdZ)
               
                Spacer()
            }
            .padding(EdgeInsets(top: 20, leading: 30, bottom: 20, trailing: 30))
        }
        }
    }
}
