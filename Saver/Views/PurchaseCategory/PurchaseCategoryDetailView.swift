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
            SublayerView()
            
            WhiteCanvasView(width: wRatio(320), height: wRatio(320))
            
        VStack(spacing: 0) {
            
            HStack{
                ImageCategoryView
                
                Text(category.name)
                    .textHeaderStyle()
                
                Spacer()
                
                DeleteSelfButtonView {
                    deletePurchaseCategory()
                }
                
                CloseSelfButtonView($closeSelf)
            }
            .fixedSize(horizontal: false, vertical: true)
            .padding(.trailing, wRatio(10))
            .padding(.leading, wRatio(30))
            
            Spacer()
            
            VStack(spacing: 10){
                Text("Budget month plan:")
                    .foregroundColor(.myGrayDark)
                    .font(.custom("Lato-Bold", size: 14))
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
                    .textCase(.uppercase)
                
                switch category.planSpentPerMonth {
                  case nil:
                    Text("You have not added spend plan for month yet")
                        .foregroundColor(.myGrayDark)
                        .font(.custom("Lato-Regular", size: 14))
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                default:
                    Text(String(category.planSpentPerMonth!))
                        .foregroundColor(.myGrayDark)
                        .font(.custom("Lato-Regular", size: 14))
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                  }
            }
            
            .frame(width: wRatio(250), height: wRatio(80))
            .background(
                RoundedRectangle(cornerRadius: 15).fill(.white)
                    .myShadow(radiusShadow: 5)
            )
            
            Spacer()
            
            VStack(spacing: 10){
                Text("Spending this Month:")
                    .foregroundColor(.myGrayDark)
                    .font(.custom("Lato-Bold", size: 14))
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
                    .textCase(.uppercase)
                
                // TODO: make btn on tap open view with expenses for this category
                
                Text("0.0$")
                    .foregroundColor(.myGrayDark)
                    .font(.custom("Lato-Regular", size: 14))
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                
                // TODO: fill from UD fact expenses
            }
            .frame(width: wRatio(250), height: wRatio(80))
            .background(
                RoundedRectangle(cornerRadius: 15).fill(.white)
                    .myShadow(radiusShadow: 5)
            )
            
            Spacer()
        }
        .padding(.top, wRatio(10))
        .frame(width: wRatio(320),
               height: wRatio(320))
      }
   }
    
    var ImageCategoryView: some View{
        ZStack{
            Color.white
                .frame(width: 30, height: 30)
                .cornerRadius(10)
                .myShadow(radiusShadow: 5)
            
            Image(systemName: "\(category.iconName)")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 20, height: 20)
                .foregroundColor(.gray)
                .cornerRadius(10)
            
            Image(category.iconName)
                .resizable()
                .frame(width: 30, height: 30)
        }
    }
    
    func deletePurchaseCategory() {
        if var user = FirebaseUserManager.shared.userModel {
            var purchCats = user.purchaseCategories
            for (index,source) in purchCats.enumerated() {
                if source.name == category.name {
                    purchCats.remove(at: index)
                }
            }
            user.purchaseCategories = purchCats
            FirebaseUserManager.shared.userModel = user
            if let cashes = FirebaseUserManager.shared.userModel?.purchaseCategories {
                purchaseCategories = cashes
            }
            closeSelf = false
        }
    }
}


struct Previews_PurchaseCategoryDetailView: PreviewProvider {
    static var previews: some View {
        MainScreen(isShowTabBar: .constant(false), purchaseDetailViewShow: true, selectedCategory: PurchaseCategory.init(name: "Products", iconName: "iconProducts", planSpentPerMonth: 1000))
            .previewDevice(PreviewDevice(rawValue: "iPhone 7 Plus"))
            .previewDisplayName("iPhone 7 Plus")
        
        MainScreen(isShowTabBar: .constant(false), purchaseDetailViewShow: true, selectedCategory: PurchaseCategory.init(name: "Products", iconName: "iconProducts", planSpentPerMonth: 1000))
            .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro"))
            .previewDisplayName("iPhone 14 Pro")
    }
}
