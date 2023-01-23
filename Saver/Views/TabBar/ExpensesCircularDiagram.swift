//
//  IncomeAndExpenses.swift
//  Saver
//
//  Created by Пришляк Дмитро on 20.08.2022.
//

import SwiftUI

struct ExpensesCircularDiagram: View {
    
    @Binding var selectedTab: Int
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text("Expenses")
                        .foregroundColor(.black)
                        .font(FontType.notoSRegular.font(size: 16))
                    Spacer()
                }
                .padding(.leading, 28)
                
                HStack {
                    Spacer()
                    Image("iconPercent")
                        .resizable()
                        .frame(width: 30, height: 30)
                    Image("iconDollar")
                        .resizable()
                        .frame(width: 30, height: 30)
                }
                .padding(.trailing, 27)
                
                PieChart(selectedTab: $selectedTab)
                
                Spacer()
            }
        }
    }
}
