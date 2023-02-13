//
//  CoastsPlace.swift
//  Saver
//
//  Created by Пришляк Дмитро on 21.08.2022.
//

import SwiftUI

struct PurchaseCategoriesView: View{
    
    @Binding var purchaseCategories: [PurchaseCategory]
    @Binding var addPurchaseCategoryShow: Bool
    
    @Binding var purchaseDetailViewShow :Bool
    @Binding var selectedCategory: PurchaseCategory?
    @Binding var limitPurchaseCategoryViewShow: Bool
    
    let columns = [ GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible())]
    
    var body: some View{
        
            VStack {
                
                Spacer()
                    .frame(height: 15)
                LazyVGrid(columns: columns, alignment: .center, spacing: 15) {
                    
                    
                    ForEach(purchaseCategories, id: \.self) { item in
                        Button {
                            print(item.name)
                            selectedCategory = item
                            purchaseDetailViewShow = true
                        } label: {
                            VStack(spacing: 5) {
                                
                                
                                
                                switch item.iconName {
                                case "iconClothing",
                                    "iconEntertainment",
                                    "iconHealth",
                                    "iconHousehold",
                                    "iconProducts",
                                    "iconRestaurant",
                                    "iconTransport":
                                    Image(item.iconName)
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                        .myShadow(radiusShadow: 5)
                                    
                                    //
                                    
                                    
                                    
                                default:
                                    ZStack{
                                        Color.white
                                            .frame(width: 50, height: 50)
                                        
                                        Image(systemName: item.iconName)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 30, height: 30)
                                            .foregroundColor(.gray.opacity(0.75))
                                    }
                                    .cornerRadius(15)
                                    .myShadow(radiusShadow: 5)
                                }
                                
                                
                                Text(item.name)
                                    .foregroundColor(.black)
                                    .font(.custom("Lato-Regular", size: 12, relativeTo: .body))
                                    .lineLimit(1)
                                    .frame(width: 80, height: 15)
                            }
                        }
                        .overlay(
                            GeometryReader { geo in
                                Color.clear
                                    .onAppear {
                                        var location = CGPoint(x: geo.frame(in: .global).midX,
                                                               y: geo.frame(in: .global).midY)
                                        PurchaseLocation.standard.locations[item.name] = location
                                    }
                            }
                        )
                    }
                    Button {
                        
//                        addPurchaseCategoryShow = true
                        
                        if purchaseCategories.count < 11 {
                            addPurchaseCategoryShow = true
                        } else {
                            limitPurchaseCategoryViewShow = true
                        }
                    } label: {
                        VStack(spacing: 0) {
                            Image("iconPlus")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .myShadow(radiusShadow: 5)
                            Spacer()
                                .frame(width: 50, height: 20)
                        }
                    }
                }
            }
            
            .padding(.bottom, wRatio(90))
        
    }
}
