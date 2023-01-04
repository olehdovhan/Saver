//
//  DetailDebtView.swift
//  Saver
//
//  Created by Oleh Dovhan on 18.12.2022.
//

import SwiftUI

struct DetailDebtView: View {
    @Binding var closeSelf: Bool
    @Binding var debts: [DebtModel]
    var debt: DebtModel
    
    var body: some View {
        
        ZStack {
            Color(hex: "C4C4C4").opacity(0.3)
                .ignoresSafeArea()
            
            Color.white
                .frame(width: UIScreen.main.bounds.width/1.2,
                       height: UIScreen.main.bounds.height/1.5)
                .cornerRadius(25)
                .shadow(radius: 25)
            
            VStack {
                
                HStack(alignment: .center, spacing: 10){
                    
                    Text(debt.name)
                        .lineLimit(2)
                        .textCase(.uppercase)
                        .foregroundColor(.myGreen)
                        .font(.custom("Lato-ExtraBold", size: 22))
                        .frame(width: UIScreen.main.bounds.width/2)
                        .padding(.top, 20)
                    
                    Spacer()
                    
                    Button(role: .destructive) {
                        deleteDebt()
                    } label: {
                        ZStack{
                            Circle().fill(.red).frame(width: 35)
                            Image(systemName: "trash")
                                .resizable()
                                .frame(width: 15, height: 20)
                                .foregroundColor(.white)
                        }
                    }
                    
                    
                    Button {
                        closeSelf = false
                    } label: {
                        Image("btnClose")
                            .resizable()
                            .frame(width: 45, height: 45)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                
                
                VStack(spacing: 20){
                    
                    if debt.whose == .took{
                        
                        Text("You shold make payment  \(debt.monthlyDebtPayment)$ per month to close this debt in \(debt.totalMonthesForReturn)")
                            .padding(20)
                            .foregroundColor(.myGrayDark)
                            .font(.custom("Lato-Regular", size: 20))
                            .frame(width: UIScreen.main.bounds.width/1.5, height: UIScreen.main.bounds.height/4.5)
                            .background(
                                RoundedRectangle(cornerRadius: 15).fill(.white)
                                    .myShadow(radiusShadow: 5)
                            )
                        
                    } else if debt.whose == .gave{
                        
                        Text("You have to get paid \(debt.monthlyDebtPayment)$ per month to close this debt in \(debt.totalMonthesForReturn)")
                            .padding(20)
                            .foregroundColor(.myGrayDark)
                            .font(.custom("Lato-Regular", size: 20))
                            .frame(width: UIScreen.main.bounds.width/1.5, height: UIScreen.main.bounds.height/4.5)
                            .background(
                                RoundedRectangle(cornerRadius: 15).fill(.white)
                                    .myShadow(radiusShadow: 5)
                            )
                    }
//                    
//                    Text("Recently you make \(debt.) payments and you collected \(debt.)$.")
//                        .padding(20)
//                        .foregroundColor(.myGrayDark)
//                        .font(.custom("Lato-Regular", size: 20))
//                        .frame(width: UIScreen.main.bounds.width/1.5, height: UIScreen.main.bounds.height/4.5)
//                        .background(
//                            RoundedRectangle(cornerRadius: 15).fill(.white)
//                                .myShadow(radiusShadow: 5)
//                        )
                    
                }
                .padding(.horizontal, 20)
                
                .frame(height: UIScreen.main.bounds.height/2)
                
                
                
                
                
                
                
                
                Spacer()
            }
            .frame(width: UIScreen.main.bounds.width/1.2,
                   height: UIScreen.main.bounds.height/1.5)
        }
    }
        
        
        func deleteDebt() {
            if var user = UserDefaultsManager.shared.userModel {
                var previousDebts = user.debts
                for (index,source) in previousDebts.enumerated() {
                    if source.name == debt.name {
                        previousDebts.remove(at: index)
                    }
                }
                user.debts = previousDebts
                UserDefaultsManager.shared.userModel = user
                if let dbts = UserDefaultsManager.shared.userModel?.debts { debts = dbts }
                closeSelf = false
            }
        }
}


