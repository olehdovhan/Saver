//
//  CoastsPlace.swift
//  Saver
//
//  Created by Пришляк Дмитро on 21.08.2022.
//

import SwiftUI

struct CoastsPlace: View{

    
    var body: some View{
      
        ZStack{
//            Color.blue.opacity(0.2)
            
            HStack(alignment: .top){
                
                Spacer(minLength: 30)
                
                Button {
                    print("Product")
                } label: {
                    VStack(spacing: 5){
                        
                        Image("iconProducts")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .myShadow(radiusShadow: 5)
                        
                        Text("Products")
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
                                PurchaseLocation.standard.locations["Products"] = location
                                
                                ["Products",
                                                                "Transport",
                                                                "Clothing",
                                                                "Restaraunt"]
                      }
                    }
                )

                
                
                Spacer()
                
                Button {
                    print("Transport")
                } label: {
                    VStack(spacing: 5){
                        
                        Image("iconTransport")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .myShadow(radiusShadow: 5)
                        
                        Text("Transport")
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
                                PurchaseLocation.standard.locations["Transport"] = location
                        }
                    }
                )
       
                Spacer()
                
                Button {
                    print("Clouthing")
                } label: {
                    VStack(spacing: 5){
                        
                        Image("iconClothing")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .myShadow(radiusShadow: 5)
                        
                        Text("Clothing")
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
                                PurchaseLocation.standard.locations["Clothing"] = location
                      }
                    }
                )

                Spacer()
                
                Button {
                    print("Restaurant")
                } label: {
                    VStack(spacing: 5){
                        
                        Image("iconRestaurant")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .myShadow(radiusShadow: 5)
                        
                        Text("Restaurant")
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
                                PurchaseLocation.standard.locations["Restaraunt"] = location
                      }
                    }
                )
                Spacer(minLength: 30)
            }
            .padding(EdgeInsets(top: 20, leading:0, bottom: 20, trailing: 0))
           
        }
        } 
    
}
