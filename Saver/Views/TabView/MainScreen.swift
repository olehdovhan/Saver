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
    @State var addCashSourceViewShow = false
    @State var cashSource: String = ""
    @State var expenseType: ExpenseCategory = .products
    @FocusState var editing: Bool
    
    var body: some View {
        ZStack{
            Color.white //.ignoresSafeArea(edges: .top)
            VStack(alignment: .center, spacing: 0){
                BalanceView().zIndex(4)
                if let cashSources = UserDefaultsManager.shared.userModel?.cashSources {
                    CardsPlace(addCashSourceViewShow: $addCashSourceViewShow,
                               incomeViewShow: $incomeViewShow,
                               expenseViewShow: $expenseViewShow,
                               purchaseType: $expenseType,
                               cashSource: $cashSource,
                               cashSources: cashSources).zIndex(3)
                }
                StatisticsPlace().zIndex(0)
                
                LinearGradient(colors: [.myGreen, .myBlue],
                               startPoint: .leading,
                               endPoint: .trailing)
                    .frame(width: UIScreen.main.bounds.width, height: 3, alignment: .top)
                
                CoastsPlace()
                Spacer(minLength: 200)
            }
         
            if expenseViewShow,
               let cashes = UserDefaultsManager.shared.userModel?.cashSources,
             let cashSources = cashes.map { $0.name}
            {
                ExpenseView(closeSelf: $expenseViewShow,
                            cashSource: cashSource,
                            expenseCategory: expenseType,
                            editing: $editing,
                            cashSources: cashSources)
                .zIndex(10)
            }
            
            if incomeViewShow {
                IncomeView(closeSelf: $incomeViewShow,
                           cashSource: cashSource,
                           editing: $editing)
                .zIndex(10)
            }
             
            if addCashSourceViewShow {
                AddCashSourceView(closeSelf: $addCashSourceViewShow,
                                  editing: $editing)
            }
        }
        .onAppear() {
            cashSource = UserDefaultsManager.shared.userModel?.cashSources[0].name ?? ""
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