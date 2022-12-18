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
            Color(hex: 0xC4C4C4, alpha: 0.7)
                .ignoresSafeArea()
            
            Color.white
                .frame(width: 300,
                       height: 500,
                       alignment: .top)
                .cornerRadius(25)
                .shadow(radius: 25)
            
        VStack {
            HStack {
                Image(category.iconName)
                    .resizable()
                    .frame(width: 90, height: 90)
                Button {
                    closeSelf = false
                } label: {
                    Image("btnClose")
                        .resizable()
                        .frame(width: 45, height: 45)
                }
            }
            HStack {
                Text(category.name)
                  
             }
           
            
            HStack {
                Text("Budget month plan")
              switch category.planSpentPerMonth {
                case nil: Text("You have not added spend plan for month yet")
              default: Text(String(category.planSpentPerMonth!))
                }
            }
            
            HStack {
                Text("Spending this Month")
                // TODO: make btn on tap open view with expenses for this category
                
                Text("0.0$")
                // TODO: fill from UD fact expenses
            }
            Button("delete", role: .destructive) { deletePurchaseCategory() }
        }
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


