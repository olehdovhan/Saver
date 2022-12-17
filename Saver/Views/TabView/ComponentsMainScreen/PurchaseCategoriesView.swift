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
    
    let columns = [ GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible())]
    
    var body: some View{
        ScrollView {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(purchaseCategories, id: \.self) { item in
                    Button {
                        print(item.name)
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

                            default:
                                Image(systemName: item.iconName)
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .myShadow(radiusShadow: 5)
                            }
                       
                            
                            Text(item.name)
                                .foregroundColor(.black)
                                .font(.custom("Lato-Regular", size: 12, relativeTo: .body))
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
                    addPurchaseCategoryShow = true
                } label: {
                    VStack {
                        Image("iconPlus")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .myShadow(radiusShadow: 5)
                    }
                }
            }
        }
    }
}
