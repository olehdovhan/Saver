//
//  CashSourceView.swift
//  Saver
//
//  Created by Pryshliak Dmytro on 30.12.2022.
//

import SwiftUI

struct CashSourceView: View {
    @State var firstZ: Double = 3
    @Binding var draggingItem : Bool
    var cashSourceItem: CashSource
    @State var index: Int?
    @Binding var incomeViewShow: Bool
    @Binding var cashSource: String
    @Binding var cashSourceReceiver: String
      var cashSourcesCount: Int
    @Binding var expenseViewShow: Bool
    @Binding var isTransferViewShow: Bool
    @Binding var purchaseType: String
    @Binding var draggingIndex: Int?
    @Binding var isNotSwipeGesture: Bool
    
    var body: some View {
       
            Button {
                incomeViewShow = true
                cashSource = cashSourceItem.name
                
            } label: {
                VStack(spacing: 5) {
                    Text(cashSourceItem.name)
                        .foregroundColor(.black)
                        .font(.custom("Lato-Regular", size: 12, relativeTo: .body))
                        .frame(width: 75)
                        .frame(height: 30)
                        .lineLimit(2)
                    
                    switch cashSourceItem.iconName {
                    case "iconBankCard", "iconWallet":
                        ZStack{
                            Image(cashSourceItem.iconName)
                                .resizable()
                                .frame(width: 50, height: 50)
                                .aspectRatio(contentMode: .fill)
                                .myShadow(radiusShadow: 5)
                                .zIndex(1)
                                .saturation(0)
                            
                            Image(cashSourceItem.iconName)
                                .resizable()
                                .frame(width: 50, height: 50)
                                .aspectRatio(contentMode: .fill)
//                                .delaysTouches(for: 0.1) {  }
                                .draggable(zIndex: $firstZ,
                                           isPurchaseDetected: $expenseViewShow,
                                           isCashSourceReceiverDetected: $isTransferViewShow,
                                           purchaseType: $purchaseType,
                                           cashType: cashSourceItem.name,
                                           cashSource: $cashSource,
                                           cashSourceReceiver: $cashSourceReceiver,
                                           draggingItem: $draggingItem,
                                           draggingIndex: $draggingIndex,
                                           currentIndexCashSource: $index,
                                           isNotSwipeGesture: $isNotSwipeGesture)
                                .zIndex(draggingIndex == index ? 15 : 10)
//                                .zIndex(30)
                                
                            
                        }
                        
                            
                    default:
                        ZStack{
                            ZStack{
                                Rectangle().foregroundColor(draggingItem ? .myGrayCapsule : .myGreen)
//                                Color.myGrayCapsule
                                    .frame(width: 50, height: 50)
                                    .animation(.easeIn(duration: 1))
                                
                                Image(cashSourceItem.iconName)
//                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 30, height: 30)
                                    
                                
                            }
                            .cornerRadius(15)
                            .myShadow(radiusShadow: 5)
                            
                            ZStack{
                                Color.myGreen
                                    .frame(width: 50, height: 50)
                                
                                Image(cashSourceItem.iconName)
//                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 30, height: 30)
//                                    .foregroundColor(.white)
                                
                            }
                            .cornerRadius(15)
//                            .zIndex(100)
                            .delaysTouches(for: 0.2) {  }
                            .draggable(zIndex: $firstZ,
                                       isPurchaseDetected: $expenseViewShow,
                                       isCashSourceReceiverDetected: $isTransferViewShow,
                                       purchaseType: $purchaseType,
                                       cashType: cashSourceItem.name,
                                       cashSource: $cashSource,
                                       cashSourceReceiver: $cashSourceReceiver,
                                       draggingItem: $draggingItem,
                                       draggingIndex: $draggingIndex,
                                       currentIndexCashSource: $index,
                                       isNotSwipeGesture: $isNotSwipeGesture)
                        }

                    }
                    Text(String(cashSourceItem.amount.formatted()))
                                            .foregroundColor(.black)
                                            .font(.custom("Lato-Regular", size: 12, relativeTo: .body))
                                            .frame(width: 75)
                                            .frame(height: 10)
                                            .lineLimit(1)
                                            .zIndex(-5)
                }
               
//                .zIndex(Double(cashSourcesCount - index?))
            }
            .frame(width: 75)
            
        
        
    }
}

//struct CashSourceView_Previews: PreviewProvider {
//    static var previews: some View {
//        CashSourceView()
//    }
//}
