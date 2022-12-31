//
//  IncomeAndExpenses.swift
//  Saver
//
//  Created by Пришляк Дмитро on 20.08.2022.
//

import SwiftUI

struct ExpensesCircularDiagram: View {
    
    var body: some View {
        ZStack{
            VStack{
                HStack{
                    Text("Expenses")
                        .foregroundColor(.black)
                        .font(.custom("NotoSans-Regular", size: 16, relativeTo: .body))
                    Spacer()
                }
                .padding(.leading, 28)
                
                HStack{
                    Spacer()
                    Image("iconPercent")
                        .resizable()
                        .frame(width: 30, height: 30)
                    Image("iconDollar")
                        .resizable()
                        .frame(width: 30, height: 30)
                }
                .padding(.trailing, 27)
                
                PieChart()
//                    .onChange(of: selectedTab) { newValue in
//                        print("diagram")
//                      //  updated.toggle()
//                    }
                
                Spacer()
            }
        
        }
        
    }
}
