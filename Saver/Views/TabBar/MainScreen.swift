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
    @State var purchaseDetailViewShow = false
    @State var cashSource: String = ""
    @State var expenseType: String = "" {
        willSet {
            print(newValue)
        }
    }
    @FocusState var editing: Bool
    @State var cashSources: [CashSource] = []
    @State var purchaseCategories: [PurchaseCategory] = []
    @State var dragging = false
    @State var selectedCategory: PurchaseCategory?
    
    var body: some View {
        ZStack {
            GeometryReader { reader in
                               Color.myGreen
                                   .frame(height: reader.safeAreaInsets.top, alignment: .top)
                                   .ignoresSafeArea()
                           }
            
            VStack{
                Color.myGreen.frame(height: 30)
                Color.white
            }
            .zIndex(-3)
            
//            Color.red
//                .padding(.top, 250)
//                .frame(width: UIScreen.main.bounds.width)
//                .zIndex(0)
            
            VStack(alignment: .center, spacing: 0) {
                
                BalanceView().zIndex(4)
                Spacer() .frame(height: 15)
                
                
                CardsPlace(addCashSourceViewShow: $addCashSourceViewShow,
                           incomeViewShow: $incomeViewShow,
                           expenseViewShow: $expenseViewShow,
                           purchaseType: $expenseType,
                           cashSource: $cashSource,
                           cashSources: $cashSources,
                           dragging: $dragging).zIndex(dragging ? 3 : -2)
                .onChange(of: addCashSourceViewShow) { newValue in
                    if let sources = UserDefaultsManager.shared.userModel?.cashSources { cashSources = sources }
                }
                .frame(height: 90)
//                .background(.red.opacity(0.3))
                
                Spacer() .frame(height: 15)
                    
                StatisticsPlace().zIndex(3)
                
                
                
                LinearGradient(colors: [.myGreen, .myBlue],
                               startPoint: .leading,
                               endPoint: .trailing)
                    .frame(width: UIScreen.main.bounds.width, height: 3, alignment: .top)
                    .zIndex(2)
                
                PurchaseCategoriesView(purchaseCategories: $purchaseCategories,
                                       addPurchaseCategoryShow: $addPurchaseCategoryViewShow,
                                       purchaseDetailViewShow: $purchaseDetailViewShow,
                                       selectedCategory: $selectedCategory)
                .zIndex(2)
                .onChange(of: addPurchaseCategoryViewShow) { newValue in
                    if let purchCategories = UserDefaultsManager.shared.userModel?.purchaseCategories { purchaseCategories = purchCategories }
                }

                Spacer()
            }
            .blur(radius: expenseViewShow ? 5 : 0 )
            .blur(radius: incomeViewShow ? 5 : 0 )
            .blur(radius: addCashSourceViewShow ? 5 : 0 )
            .blur(radius: addPurchaseCategoryViewShow ? 5 : 0 )
            .blur(radius: purchaseDetailViewShow ? 5 : 0 )
         
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
            
            if purchaseDetailViewShow, selectedCategory != nil {
                PurchaseCategoryDetailView(closeSelf: $purchaseDetailViewShow,
                                           purchaseCategories: $purchaseCategories,
                                           category: selectedCategory!)
            }
        }
        .onAppear() {
            cashSource = UserDefaultsManager.shared.userModel?.cashSources[0].name ?? ""
//            print("cashSources: \(String(describing: UserDefaultsManager.shared.userModel?.cashSources))")
            if let sources = UserDefaultsManager.shared.userModel?.cashSources {
                cashSources = sources
            }
            if let categories = UserDefaultsManager.shared.userModel?.purchaseCategories {
                purchaseCategories = categories
            }
        }
//        .ignoresSafeArea(.all)
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
