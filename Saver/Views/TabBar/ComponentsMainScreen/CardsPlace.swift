//
//  CardsPlace.swift
//  Saver
//
//  Created by Пришляк Дмитро on 21.08.2022.
//

import SwiftUI

struct CardsPlace: View {
    
    
    @State var firstZ: Double = 3
    @State var secondZ: Double = 2
    @State var thirdZ: Double = 1
    
    @Binding var addCashSourceViewShow: Bool
    @Binding var incomeViewShow: Bool
    @Binding var expenseViewShow: Bool
    @Binding var purchaseType: String
    @Binding var cashSource: String
    @Binding var cashSources: [CashSource]
    @Binding var dragging: Bool
    
    
    var body: some View {
        GeometryReader { geo in
            VStack{
                Spacer()
                ZStack {
                    HStack() {
                        
                        ScrollView(.horizontal, showsIndicators: false){
                            HStack(spacing: 30){
                                Spacer().frame(width: 15)
                                
                                
                                ForEach(Array(cashSources.enumerated()), id: \.offset) { index, source in
                                    ZStack{
                                        
                                        Button {
                                            incomeViewShow = true
                                            cashSource = source.name
                                            
                                        } label: {
                                            VStack(spacing: 5) {
                                                Text(source.name)
                                                    .foregroundColor(.black)
                                                    .font(.custom("Lato-Regular", size: 12, relativeTo: .body))
                                                    .frame(width: 75)
                                                    .frame(height: 30)
                                                    .lineLimit(2)
                                                
                                                switch source.iconName {
                                                case "iconBankCard", "iconWallet":          Image(source.iconName)
                                                        .resizable()
                                                        .frame(width: 50, height: 50)
                                                        .myShadow(radiusShadow: 5)
                                                default:          Image(systemName: source.iconName)
                                                        .resizable()
                                                        .frame(width: 50, height: 50)
                                                        .myShadow(radiusShadow: 5)
                                                }
                                                
                                                
                                                Text(String(source.amount))
                                                    .foregroundColor(.black)
                                                    .font(.custom("Lato-Regular", size: 12, relativeTo: .body))
                                                    .frame(width: 75)
                                                    .frame(height: 30)
                                                    .lineLimit(2)
                                            }
                                            //                                      TODO: - Зроби zIndex динамічним і змінюй його в момент драгу
                                            .delaysTouches(for: 1) { }
                                            .draggable(zIndex: $firstZ,
                                                       isAlertShow: $expenseViewShow,
                                                       purchaseType: $purchaseType,
                                                       cashType: source.name,
                                                       cashSource: $cashSource,
                                                       dragging: $dragging)
                                            
                                            
                                            
                                            
                                        }
                                        .zIndex(Double(cashSources.count - index))
                                    }
                                    .frame(height: UIScreen.main.bounds.height)
                                }
                                
                                
                                
                                
                                
                                
                                
                                Button {
                                    addCashSourceViewShow = true
                                } label: {
                                    VStack {
                                        Image("iconPlus")
                                            .resizable()
                                            .frame(width: 50, height: 50)
                                            .myShadow(radiusShadow: 5)
                                    }
                                }
                                .zIndex(1)
                                Spacer()
                                Spacer().frame(width: 30)
                                    .onAppear(){
                                        print(UIScreen.main.bounds.height * 0.44)
                                    }
                            }
                        }
                        
                     
                    }
                    .padding(EdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0))
                }
//                .offset(y: UIScreen.main.bounds.height/4)
                .offset(y:  -UIScreen.main.bounds.height * 0.44)
                Spacer()
            }
        }
    }
}



