//
//  Mainscrin2.swift
//  Saver
//
//  Created by Пришляк Дмитро on 20.08.2022.
//

import SwiftUI

struct MainScreen: View {
    
    @State private var expenseViewShow = false
    @State private var incomeViewShow = false
    @State private var addCashSourceViewShow = false
    @State private var addPurchaseCategoryViewShow = false
    @State private var purchaseDetailViewShow = false
    @State private var limitCashSourcesViewShow = false
    @State private var cashSource: String = ""
    @State private var expenseType: String = ""
    @FocusState private var editing: Bool
    @State private var cashSources: [CashSource] = []
    @State private var purchaseCategories: [PurchaseCategory] = []
    @State var selectedCategory: PurchaseCategory?
    @State private var cashSourcesData = CashSourcesData()
    @State private var scrollEffectValue: Double = 13
    @State private var activePageIndex: Int = 0
    @State private var draggingScroll = true
    @State private var draggingItem = false
    @State private var leadingOffsetScroll: CGFloat = 0
    private let itemWidth: CGFloat = Screen.width * 0.2325
    private let itemPadding: CGFloat = 6
    
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
//                .frame(width: Screen.width)
//                .zIndex(0)
            
            VStack(alignment: .center, spacing: 0) {
                
                BalanceView().zIndex(4)
                Spacer() .frame(height: 15)
                    .onAppear(){
                        print(Screen.width)
                    }
                
                    //Новий скрол
                GeometryReader { geometry in
                    AdaptivePagingScrollView(addCashSourceViewShow: $addCashSourceViewShow,
                                             incomeViewShow: $incomeViewShow,
                                             expenseViewShow: $expenseViewShow,
                                             purchaseType: $expenseType,
                                             cashSource: $cashSource,
                                             cashSources: $cashSources,
                                             currentPageIndex: self.$activePageIndex,
                                             draggingScroll: self.$draggingScroll,
                                             itemsAmount:    cashSources.count - 1,
                                             itemWidth: self.itemWidth,
                                             itemPadding: self.itemPadding,
                                             pageWidth: geometry.size.width,
                                             limitCashSourcesViewShow: $limitCashSourcesViewShow) {
                        ForEach(Array(cashSources.enumerated()), id: \.offset) { index, source in
                            GeometryReader{ screen in
                                CashSourceView(draggingItem: $draggingItem,
                                               cashSourceItem: source,
                                               index: index,
                                               incomeViewShow: $incomeViewShow,
                                               cashSource: $cashSource,
                                               cashSourcesCount: cashSources.count,
                                               expenseViewShow: $expenseViewShow,
                                               purchaseType: $expenseType
                                )
                            }
                            .frame(width: self.itemWidth, height: 70)
                        }
                    }
                                             
//                                             .background(Color.black.opacity(0.1))
                    
                    //Референсний новий скрол
//                    AdaptivePagingScrollView(currentPageIndex: self.$activePageIndex,
//                                             dragging: self.$dragging,
//                                             itemsAmount: self.onboardData.cards.count - 1,
//                                             itemWidth: self.itemWidth,
//                                             itemPadding: self.itemPadding,
//                                             pageWidth: geometry.size.width) {
//                        ForEach(onboardData.cards) { card in
//                            GeometryReader { screen in
//                                OnbardingCardView(dragging: $dragging, card: card)
//                            }
//                            .frame(width: self.itemWidth, height: 100)
//
//                        }
//                    }
//                                             .frame(height: 150)
//                                             .background(Color.red)
                }
                .zIndex(draggingItem ? 10 : -2)
                .onChange(of: addCashSourceViewShow) { newValue in
                    if let sources = UserDefaultsManager.shared.userModel?.cashSources { cashSources = sources }
                                }
                .frame(height: 100)
                .overlay(
                    HStack{
                        Ellipse()
                            .fill(
                                .ellipticalGradient(colors: [.white, .clear])
                            )
                            .frame(width: itemPadding * 3)
                            .frame(height: 140)
                            .offset(x: -itemPadding)

                        Spacer().zIndex(-10)
                        
                        Ellipse()
                            .fill(
                                .ellipticalGradient(colors: [.white, .clear])
                            )
                            .frame(width: itemPadding * 3)
                            .frame(height: 140)
                            .offset(x: itemPadding)
                            }
                )
                
                
                
//                Старий скрол
//                CardsPlace(addCashSourceViewShow: $addCashSourceViewShow,
//                           incomeViewShow: $incomeViewShow,
//                           expenseViewShow: $expenseViewShow,
//                           purchaseType: $expenseType,
//                           cashSource: $cashSource,
//                           cashSources: $cashSources,
//                           draggingItem: $draggingItem).zIndex(draggingItem ? 3 : -2)
//                .onChange(of: addCashSourceViewShow) { newValue in
//                    if let sources = UserDefaultsManager.shared.userModel?.cashSources { cashSources = sources }
//                }
//                .frame(height: 90)
//                .background(.red.opacity(0.3))
                
                Spacer() .frame(height: 15)
                    
                StatisticsPlace().zIndex(3)
//                    .background(.red)
                
                
                
                LinearGradient(colors: [.myGreen, .myBlue],
                               startPoint: .leading,
                               endPoint: .trailing)
                    .frame(width: Screen.width, height: 3, alignment: .top)
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
            
            if limitCashSourcesViewShow{
                LimitCashSourcesView(closeSelf: $limitCashSourcesViewShow)
            }
        }
        .onChange(of: expenseViewShow, perform: { newValue in
            if let sources = UserDefaultsManager.shared.userModel?.cashSources {
                cashSources = sources
                if sources.count != 0 {
                    cashSource = sources[0].name ?? ""
                }
            }
        })
        .onAppear() {
            if let sources = UserDefaultsManager.shared.userModel?.cashSources {
                cashSources = sources
                if sources.count != 0 {
                    cashSource = sources[0].name ?? ""
                }
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
