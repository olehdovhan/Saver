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
//            Color.orange.opacity(0.2)
            //Statistics
            HStack(alignment: .top){
                
                Spacer(minLength: 30)
                
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
                            .font(.custom("Lato-Regular", size: 12, relativeTo: .body))
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
                            .font(.custom("Lato-Regular", size: 12, relativeTo: .body))
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
                            .font(.custom("Lato-Regular", size: 12, relativeTo: .body))
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
                            .font(.custom("Lato-Regular", size: 12, relativeTo: .body))
                    }
                }
               
                
                
                Spacer(minLength: 30)
            }
            .padding(EdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0))
           
        }
    }
}
