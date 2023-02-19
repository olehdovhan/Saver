//
//  CardsPlace.swift
//  Saver
//
//  Created by Пришляк Дмитро on 21.08.2022.
//

import SwiftUI

//struct CardsPlace: View {
//
//    @State var firstZ: Double = 3
//    @Binding var addCashSourceViewShow: Bool
//    @Binding var incomeViewShow: Bool
//    @Binding var expenseViewShow: Bool
//    @Binding var isCashSourceReceiverShow: Bool
//    @Binding var purchaseType: String
//    @Binding var cashSource: String
//    @Binding var cashSourceReceiver: String
//    @Binding var cashSources: [CashSource]
//    @Binding var draggingItem: Bool
//
//    var body: some View {
//        GeometryReader { geo in
//            VStack{
//                Spacer()
//                ZStack {
//                    HStack() {
//
//                        ScrollView(.horizontal, showsIndicators: false){
//                            HStack(spacing: 20){
//                                Spacer().frame(width: 5)
//
//
//                                ForEach(Array(cashSources.enumerated()), id: \.offset) { index, source in
//                                    ZStack{
//
//                                        Button {
//                                            incomeViewShow = true
//                                            cashSource = source.name
//
//                                        } label: {
//                                            VStack(spacing: 5) {
//                                                Text(source.name)
//                                                    .foregroundColor(.black)
//                                                    .font(.custom("Lato-Regular", size: 12, relativeTo: .body))
//                                                    .frame(width: 75)
//                                                    .frame(height: 30)
//                                                    .lineLimit(2)
//
//                                                switch source.iconName {
//                                                case "iconBankCard", "iconWallet":
//                                                    Image(source.iconName)
//                                                        .resizable()
//                                                        .frame(width: 50, height: 50)
//                                                        .aspectRatio(contentMode: .fill)
//                                                        .myShadow(radiusShadow: 5)
//                                                default:
//                                                    ZStack{
//                                                        Color.myGreen
//                                                            .frame(width: 50, height: 50)
//
//                                                        Image(systemName: source.iconName)
//                                                            .resizable()
//                                                            .aspectRatio(contentMode: .fit)
//                                                            .frame(width: 30, height: 30)
//                                                            .foregroundColor(.white)
//
//                                                    }
//                                                    .cornerRadius(15)
//                                                    .myShadow(radiusShadow: 5)
//
//                                                }
//
//
//                                                Text(String(source.amount))
//                                                    .foregroundColor(.black)
//                                                    .font(.custom("Lato-Regular", size: 12, relativeTo: .body))
//                                                    .frame(width: 75)
//                                                    .frame(height: 10)
//                                                    .lineLimit(1)
//                                            }
//                                            //                                      TODO: - Зроби zIndex динамічним і змінюй його в момент драгу
//                                            .delaysTouches(for: 0.5) {  }
//                                            .draggable(zIndex: $firstZ,
//                                                       isPurchaseDetected: $expenseViewShow,
//                                                       isCashSourceReceiverDetected: $isCashSourceReceiverShow,
//                                                       purchaseType: $purchaseType,
//                                                       cashType: source.name,
//                                                       cashSource: $cashSource,
//                                                       cashSourceReceiver: $cashSourceReceiver,
//                                                       draggingItem: $draggingItem)
//
//
//
//
//                                        }
//                                        .zIndex(Double(cashSources.count - index))
//                                    }
//
//                                    .frame(height: UIScreen.main.bounds.height * 1.5)
//
//                                }
//
//                                if cashSources.count < 6 {
//                                    Button {
//                                        addCashSourceViewShow = true
//                                    } label: {
//                                        VStack {
//                                            Spacer().frame(height: 35)
//                                            Image("iconPlus")
//                                                .resizable()
//                                                .frame(width: 50, height: 50)
//                                                .myShadow(radiusShadow: 5)
//                                            Spacer().frame(height: 15)
//                                        }
//                                    }
//                                    .zIndex(1)
//                                }
//
//                                Spacer()
//                                Spacer().frame(width: 5)
//                                    .onAppear(){
//                                        print("cashSource: \(cashSources.count)" )
//                                    }
//                            }
//
//                        }
//
//                    }
//                    .padding(EdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0))
//                }
//                .offset(y:  -UIScreen.main.bounds.height * 0.73)
//                Spacer()
//            }
//        }
//    }
//}



