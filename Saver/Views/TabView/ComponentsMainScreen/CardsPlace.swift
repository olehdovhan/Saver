//
//  CardsPlace.swift
//  Saver
//
//  Created by Пришляк Дмитро on 21.08.2022.
//

import SwiftUI

struct CardsPlace: View{
    
    
    @State var firstZ: Double = 3
    @State var secondZ: Double = 2
    @State var thirdZ: Double = 1
    
    @Binding var addCashSourceViewShow: Bool
    @Binding var incomeViewShow: Bool
    @Binding var expenseViewShow: Bool
    @Binding var purchaseType: ExpenseCategory
    @Binding var cashSource: String
    @State var cashSources: [CashSource]
    var body: some View {
        GeometryReader { geo in
        ZStack {
            HStack(spacing: 16) {
                ForEach(Array(cashSources.enumerated()), id: \.offset) { index, source in
                    Button {
                        incomeViewShow = true
                        cashSource = source.name
                    } label: {
                        VStack(spacing: 5) {
                            Text(source.name)
                               .foregroundColor(.black)
                               .font(.custom("Lato-Regular", size: 12, relativeTo: .body))

                            Image(source.iconName)
                               .resizable()
                               .frame(width: 50, height: 50)
                               .myShadow(radiusShadow: 5)

                            Text(String(source.amount))
                               .foregroundColor(.black)
                               .font(.custom("Lato-Regular", size: 12, relativeTo: .body))
                       }
                        // TODO: - Зроби zIndex динамічним і змінюй його в момент драгу 
                        .draggable(zIndex: $firstZ, isAlertShow: $expenseViewShow, purchaseType: $purchaseType, cashType: source.name, cashSource: $cashSource)
                    }
                    .zIndex(Double(cashSources.count - index))
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
            }
            .padding(EdgeInsets(top: 20, leading: 30, bottom: 20, trailing: 30))
          }
        }
    }
}



