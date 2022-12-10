//
//  Mainscrin2.swift
//  Saver
//
//  Created by Пришляк Дмитро on 20.08.2022.
//

import SwiftUI


struct MainScreen: View {
    
    @State var expenseViewShow = false
    @State var incomeViewShow = false
    @State var cashSource: CashSource = .wallet
    @State var expenseType: ExpenseCategory = .products
    @FocusState var editing: Bool
    
    var body: some View {
        ZStack{
            Color.white //.ignoresSafeArea(edges: .top)
            VStack(alignment: .center, spacing: 0){
                BalanceView().zIndex(4)
                CardsPlace(incomeViewShow: $incomeViewShow, expenseViewShow: $expenseViewShow, purchaseType: $expenseType, cashSource: $cashSource).zIndex(3)
                StatisticsPlace().zIndex(0)
                
                LinearGradient(colors: [.myGreen, .myBlue],
                               startPoint: .leading,
                               endPoint: .trailing)
                    .frame(width: UIScreen.main.bounds.width, height: 3, alignment: .top)
                
                CoastsPlace()
                Spacer(minLength: 200)
            }
         
            if expenseViewShow{
                ExpenseView(closeSelf: $expenseViewShow,
                            cashSource: cashSource,
                            expenseCategory: expenseType, editing: $editing)
                .zIndex(10)
            }
            
            if incomeViewShow {
                IncomeView(closeSelf: $incomeViewShow,
                           cashSource: cashSource,
                           editing: $editing)
                .zIndex(10)
            }
        }
        .ignoresSafeArea(.all)
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                   editing = false
                }
            }
        }

    }
}

//struct Mainscrin2_Previews: PreviewProvider {
//    static var previews: some View {
//        Mainscrin2()
//    }
//
//}
