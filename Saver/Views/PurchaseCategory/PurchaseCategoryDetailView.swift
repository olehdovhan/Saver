//
//  PurchaseCategoryDetailView.swift
//  Saver
//
//  Created by Oleh Dovhan on 17.12.2022.
//

import SwiftUI

struct PurchaseCategoryDetailView: View {
    
    @Binding var closeSelf: Bool
    @Binding var purchaseCategories: [PurchaseCategory]
    var category: PurchaseCategory
    var body: some View {
        
        ZStack {
            Color.myGrayLight.opacity(0.3)
                .ignoresSafeArea()
            
            Color.white
                .frame(width: Screen.width/1.2,
                       height: Screen.height/1.5)
                .cornerRadius(25)
                .myShadow(radiusShadow: 5)
            
        VStack(spacing: 20) {
            
            HStack(alignment: .top, spacing: 10){
                
                VStack(){
                    Text(category.name)
                        .lineLimit(1)
                        .textCase(.uppercase)
                        .foregroundColor(.myGreen)
                        .font(.custom("Lato-ExtraBold", size: 22))
                        .frame(width: Screen.width/2.2)
                    
                    ZStack{
                        
                        
                        ZStack{
                            Color.white
                                .frame(width: 50, height: 50)
                            
                            Image(systemName: "\(category.iconName)")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30, height: 30)
                                .foregroundColor(.gray)
                        }
                        .cornerRadius(15)
                        .myShadow(radiusShadow: 5)
                        
                        Image(category.iconName)
                            .resizable()
                            .frame(width: 50, height: 50)
                    }
                    
                }
                Spacer()
                
                HStack(alignment: .center, spacing: 10){
                    Button(role: .destructive) {
                        deletePurchaseCategory()
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
                .padding(.trailing, 20)
                
            }
            .padding(.top, 20)
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
            
            
            VStack(spacing: 10){
                Text("Budget month plan:")
                    .foregroundColor(.myGrayDark)
                    .font(.custom("Lato-Bold", size: 16))
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
                    .textCase(.uppercase)
                
                switch category.planSpentPerMonth {
                  case nil:
                    Text("You have not added spend plan for month yet")
                        .foregroundColor(.myGrayDark)
                        .font(.custom("Lato-Regular", size: 16))
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .padding(.horizontal, 20)
                default:
                    Text(String(category.planSpentPerMonth!))
                        .foregroundColor(.myGrayDark)
                        .font(.custom("Lato-Regular", size: 16))
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                  }
            }
            .frame(width: Screen.width/1.5, height: Screen.height/5.5)
            .background(
                RoundedRectangle(cornerRadius: 15).fill(.white)
                    .myShadow(radiusShadow: 5)
            )
            
            
            VStack(spacing: 10){
                Text("Spending this Month:")
                    .foregroundColor(.myGrayDark)
                    .font(.custom("Lato-Bold", size: 16))
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
                    .textCase(.uppercase)
                
                // TODO: make btn on tap open view with expenses for this category
                
                Text("0.0$")
                    .foregroundColor(.myGrayDark)
                    .font(.custom("Lato-Regular", size: 16))
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                
                // TODO: fill from UD fact expenses
            }
            .frame(width: Screen.width/1.5, height: Screen.height/5.5)
            .background(
                RoundedRectangle(cornerRadius: 15).fill(.white)
                    .myShadow(radiusShadow: 5)
            )
            
      
            
            Spacer()
        }
        .frame(width: Screen.width/1.2,
               height: Screen.height/1.5)
      }
   }
    
    func deletePurchaseCategory() {
        if var user = UserDefaultsManager.shared.userModel {
            var purchCats = user.purchaseCategories
            for (index,source) in purchCats.enumerated() {
                if source.name == category.name {
                    purchCats.remove(at: index)
                }
            }
            user.purchaseCategories = purchCats
            UserDefaultsManager.shared.userModel = user
            if let cashes = UserDefaultsManager.shared.userModel?.purchaseCategories {
                purchaseCategories = cashes
            }
            closeSelf = false
        }
    }
}


