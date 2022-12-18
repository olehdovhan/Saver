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
    @State var addPurchaseCategoryViewShow = false
    @State var cashSource: String = ""
    @State var expenseType: String = "" {
        willSet {
            print(newValue)
        }
    }
    @FocusState var editing: Bool
    @State var cashSources: [CashSource] = []
    @State var purchaseCategories: [PurchaseCategory] = []
    var body: some View {
        ZStack {
            Color.white
            VStack(alignment: .center, spacing: 0) {
                BalanceView().zIndex(4)
                    CardsPlace(addCashSourceViewShow: $addCashSourceViewShow,
                               incomeViewShow: $incomeViewShow,
                               expenseViewShow: $expenseViewShow,
                               purchaseType: $expenseType,
                               cashSource: $cashSource,
                               cashSources: $cashSources).zIndex(3)
                    .onChange(of: addCashSourceViewShow) { newValue in
                        if let sources = UserDefaultsManager.shared.userModel?.cashSources { cashSources = sources }
                    }
                StatisticsPlace().zIndex(0)
                
                LinearGradient(colors: [.myGreen, .myBlue],
                               startPoint: .leading,
                               endPoint: .trailing)
                    .frame(width: UIScreen.main.bounds.width, height: 3, alignment: .top)
                
                PurchaseCategoriesView(purchaseCategories: $purchaseCategories,
                                       addPurchaseCategoryShow: $addPurchaseCategoryViewShow)
                .onChange(of: addPurchaseCategoryViewShow) { newValue in
                    if let purchCategories = UserDefaultsManager.shared.userModel?.purchaseCategories { purchaseCategories = purchCategories }
                }

                Spacer(minLength: 200)
            }
         
            if expenseViewShow,
               let cashes = UserDefaultsManager.shared.userModel?.cashSources,
             let cashSources = cashes.map { $0.name} {
                ExpenseView(closeSelf: $expenseViewShow,
                            cashSource: cashSource,
                            purchaseCategoryName: $expenseType,
                            editing: $editing,
                            cashSources: cashSources)
                            .zIndex(10)
            }
            
            if incomeViewShow {
                IncomeView(closeSelf: $incomeViewShow,
                           cashSource: cashSource,
                           editing: $editing,
                           cashSources: $cashSources)
                           .zIndex(10)
            }
             
            if addCashSourceViewShow {
                AddCashSourceView(closeSelf: $addCashSourceViewShow,
                                  editing: $editing)
            }
            if addPurchaseCategoryViewShow {
                AddPurchaseCategoryView(closeSelf: $addPurchaseCategoryViewShow,
                                        editing: $editing)
            }
        }
        .onAppear() {
            cashSource = UserDefaultsManager.shared.userModel?.cashSources[0].name ?? ""
            if let sources = UserDefaultsManager.shared.userModel?.cashSources {
                cashSources = sources
            }
            if let categories = UserDefaultsManager.shared.userModel?.purchaseCategories {
                purchaseCategories = categories
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