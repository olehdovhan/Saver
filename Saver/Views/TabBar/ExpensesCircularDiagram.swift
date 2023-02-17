//
//  IncomeAndExpenses.swift
//  Saver
//
//  Created by Пришляк Дмитро on 20.08.2022.
//

import SwiftUI

struct ExpensesCircularDiagram: View {
    
    @Binding var selectedTab: Int
    @State var isPercent: Bool = true
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Expenses".uppercased())
                    .foregroundColor(.myGreen)
                    .font(.custom("Lato-Bold", size: wRatio(25)))
                Spacer()
                
                Button{
                    isPercent = true
                } label: {
                    Image("iconPercent")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .colorMultiply(isPercent ? .myGreen : .white)
                        .shadow(radius: 5)
                }
                
                Button{
                    isPercent = false
                } label: {
                    Image("iconDollar")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .colorMultiply(isPercent ? .white : .myGreen)
                        .shadow(radius: 5)
                }
            }
            .padding(.horizontal, wRatio(25))
            .padding(.top, 10)
            
            
            PieChart(selectedTab: $selectedTab, isPercent: $isPercent)
                
            
            Spacer()
        }
    }
}

