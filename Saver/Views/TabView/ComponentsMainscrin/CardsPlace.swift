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
    
    @Binding var incomeViewShow: Bool
    @Binding var expenseViewShow: Bool
    @Binding var purchaseType: ExpenseCategory
    @Binding var cashSource: CashSource
    
    var body: some View{
        GeometryReader{ geo in
        ZStack{

            HStack(spacing: 16){
                
                Button {
                    incomeViewShow = true
                    cashSource = .bankCard
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
                     .draggable(zIndex: $firstZ, isAlertShow: $expenseViewShow, purchaseType: $purchaseType, cashType: .bankCard, cashSource: $cashSource)
                   // .draggable(zIndex: $firstZ, isAlertShow: $isAlertShow, purchaseType: $purchaseType)
                }
                .zIndex(firstZ)
              
                
              Button {
                  incomeViewShow = true
                  cashSource = .wallet
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
                    .draggable(zIndex: $secondZ, isAlertShow: $expenseViewShow, purchaseType: $purchaseType, cashType: .wallet, cashSource: $cashSource)
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
                   // .draggable(zIndex: $thirdZ, isAlertShow: $isAlertShow, purchaseType: $purchaseType)
                }
                .zIndex(thirdZ)
               
                Spacer()
            }
            .padding(EdgeInsets(top: 20, leading: 30, bottom: 20, trailing: 30))
        }
        }
    }
}



