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
    
    private let columns = [ GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible())]
    
    var body: some View{
        
        ZStack {
            ScrollView {
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
                                    
                                default:
                                    ZStack{
                                        Color.white
                                            .frame(width: 50, height: 50)
                                        
                                        Image(systemName: item.iconName)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 30, height: 30)
                                            .foregroundColor(.gray)
                                    }
                                    .cornerRadius(15)
                                    .myShadow(radiusShadow: 5)
                                }
                                
                                
                                Text(item.name)
                                    .foregroundColor(.black)
                                    .font(FontType.latoRegular.font(size: 12))
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
                        addPurchaseCategoryShow = true
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
//                Spacer()
//                    .frame(height: 70)
            }
            .padding(.bottom, 70)
        }
    }
}
