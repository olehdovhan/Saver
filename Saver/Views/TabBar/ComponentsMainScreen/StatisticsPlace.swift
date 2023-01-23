//
//  StatisticsPlace.swift
//  Saver
//
//  Created by Пришляк Дмитро on 21.08.2022.
//

import SwiftUI

struct StatisticsPlace: View{
    var body: some View{
        
        ZStack{
            HStack(alignment: .top, spacing: 0){
                
                Rectangle().frame(width: Screen.width * 0.05115, height: 10).foregroundColor(.white)
                
                Button {
                    print("Monthly budget")
                } label: {
                    VStack(spacing: 5){
                        
                        Image("iconMonthlyBudget")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .myShadow(radiusShadow: 5)
                        
                        Text("Monthly budget")
                            .frame(width: 50)
                            .foregroundColor(.black)
                            .font(FontType.latoRegular.font(size: 12))
                    }
                }
                Spacer()
                
                Button {
                    
                    print("Goals")
                    
                } label: {
                    VStack(spacing: 5){
                        
                        Image("iconGoals")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .myShadow(radiusShadow: 5)
                        
                        Text("Goals")
                            .foregroundColor(.black)
                            .font(FontType.latoRegular.font(size: 12))
                    }
                }
                
                Spacer()
                
                Button {
                    print("Saving")
                } label: {
                    VStack(spacing: 5){
                        
                        Image("iconSaving")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .myShadow(radiusShadow: 5)
                        
                        Text("Saving")
                            .foregroundColor(.black)
                            .font(FontType.latoRegular.font(size: 12))
                    }
                }
               
                Spacer()
                
                Button {
                    print("Debt")
                } label: {
                    VStack(spacing: 5){
                        
                        Image("iconDebt")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .myShadow(radiusShadow: 5)
                        
                        Text("Debt")
                            .foregroundColor(.black)
                            .font(FontType.latoRegular.font(size: 12))
                    }
                }
               
                
                
                Rectangle().frame(width: Screen.width * 0.05115, height: 10).foregroundColor(.white)
            }
            .padding(EdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0))
           
        }
    }
}
