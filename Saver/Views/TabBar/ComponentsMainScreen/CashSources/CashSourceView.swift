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
    var index: Int
    @Binding var incomeViewShow: Bool
    @Binding var cashSource: String
      var cashSourcesCount: Int
    @Binding var expenseViewShow: Bool
    @Binding var purchaseType: String

    
    
    var body: some View {
        ZStack{
            
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
//                        .background(Capsule().fill(.white))
                    
                    switch cashSourceItem.iconName {
                    case "iconBankCard", "iconWallet":
                        Image(cashSourceItem.iconName)
                            .resizable()
                            .frame(width: 50, height: 50)
                            .aspectRatio(contentMode: .fill)
                            .myShadow(radiusShadow: 5)
                    default:
                        ZStack{
                            Color.myGreen
                                .frame(width: 50, height: 50)
                            
                            Image(systemName: cashSourceItem.iconName)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30, height: 30)
                                .foregroundColor(.white)
                            
                        }
                        .cornerRadius(15)
                        .myShadow(radiusShadow: 5)
                        
                    }
                    Text(String(cashSourceItem.amount))
                                            .foregroundColor(.black)
                                            .font(.custom("Lato-Regular", size: 12, relativeTo: .body))
                                            .frame(width: 75)
                                            .frame(height: 10)
                                            .lineLimit(1)
//                                            .background(Capsule().fill(.white))
                    
                    
                }
                .zIndex(Double(cashSourcesCount - index))
            }
            .frame(width: 75)
            
        }
        
        .background(Circle().fill(RadialGradient(colors: [.white, .clear],
                                                 center: .center,
                                                 startRadius: 20,
                                                 endRadius: 30)).scaleEffect(2))
        .delaysTouches(for: 0.5) {  }
        .draggable(zIndex: $firstZ,
                   isAlertShow: $expenseViewShow,
                   purchaseType: $purchaseType,
                   cashType: cashSourceItem.name,
                   cashSource: $cashSource,
                   draggingItem: $draggingItem)
        
    }
}

//struct CashSourceView_Previews: PreviewProvider {
//    static var previews: some View {
//        CashSourceView()
//    }
//}
