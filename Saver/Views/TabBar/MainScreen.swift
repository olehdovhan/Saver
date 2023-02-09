//
//  Mainscrin2.swift
//  Saver
//
//  Created by Пришляк Дмитро on 20.08.2022.
//

import SwiftUI
import Firebase

struct MainScreen: View {
    @Binding var isShowTabBar: Bool
    
    @State var showQuitAlert = false
    @State var expenseViewShow = false
    @State var incomeViewShow = false
    @State var addCashSourceViewShow = false
    @State var addPurchaseCategoryViewShow = false
    @State var purchaseDetailViewShow = false
    @State var limitCashSourcesViewShow = false
    @State var cashSource: String = ""
    @State var expenseType: String = ""
    @FocusState var editing: Bool
    @State var cashSources: [CashSource] = []
    @State var purchaseCategories: [PurchaseCategory] = []
    @State var selectedCategory: PurchaseCategory?
    
    @State var cashSourcesData = CashSourcesData()
    @State private var scrollEffectValue: Double = 13
    @State private var activePageIndex: Int = 0
    @State var draggingScroll = true
    @State var draggingItem = false
    @State var leadingOffsetScroll: CGFloat = 0
    let itemWidth: CGFloat = UIScreen.main.bounds.width * 0.2325
    let itemPadding: CGFloat = 6
    var viewModel = MainScreenViewModel()
    
    @State var user: UserFirModel!
    @State var userRef: DatabaseReference!
    @State var tasks = [TaskFirModel]()
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            GeometryReader { reader in
                Color.myGreen
                    .frame(height: reader.safeAreaInsets.top, alignment: .top)
                    .ignoresSafeArea()
            }
            VStack {
                Color.myGreen.frame(height: 30)
                Color.white
            }
            .zIndex(-3)
            
            VStack(alignment: .center, spacing: 0) {
                
                BalanceView(showQuitAlert: $showQuitAlert).zIndex(4)
                Spacer() .frame(height: 15)
                    .onAppear(){
                        print(UIScreen.main.bounds.width)
                    }
                
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
                }
                .zIndex(draggingItem ? 10 : -2)
                .onChange(of: addCashSourceViewShow) { newValue in
                    if let sources = FirebaseUserManager.shared.userModel?.cashSources { cashSources = sources }
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

                Spacer() .frame(height: 15)
                
//                StatisticsPlace().zIndex(3)
                //                    .background(.red)
                
                
                
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
                    if let purchCategories = FirebaseUserManager.shared.userModel?.purchaseCategories { purchaseCategories = purchCategories }
                }
                
                Spacer()
            }
            .blur(radius: expenseViewShow ? 5 : 0 )
            .blur(radius: incomeViewShow ? 5 : 0 )
            .blur(radius: addCashSourceViewShow ? 5 : 0 )
            .blur(radius: addPurchaseCategoryViewShow ? 5 : 0 )
            .blur(radius: purchaseDetailViewShow ? 5 : 0 )
            
            if expenseViewShow,
               let cashes = FirebaseUserManager.shared.userModel?.cashSources,
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
        .onChange(of: addCashSourceViewShow, perform: { newValue in
            isShowTabBar = !addCashSourceViewShow
        })
        .onChange(of: addPurchaseCategoryViewShow, perform: { newValue in
            isShowTabBar = !addPurchaseCategoryViewShow
        })
        .onChange(of: purchaseDetailViewShow, perform: { newValue in
            isShowTabBar = !purchaseDetailViewShow
        })
        .onChange(of: incomeViewShow, perform: { newValue in
            isShowTabBar = !incomeViewShow
        })
        .onChange(of: expenseViewShow, perform: { newValue in
            if let sources = FirebaseUserManager.shared.userModel?.cashSources {
                cashSources = sources
                if sources.count != 0 {
                    cashSource = sources[0].name ?? ""
                }
            }
        })
        .onAppear() {
            
            
            
            FirebaseUserManager.shared.observeUser {
                if let sources = FirebaseUserManager.shared.userModel?.cashSources {
                    cashSources = sources
                    if sources.count != 0 { cashSource = sources[0].name }
                }
                if let categories = FirebaseUserManager.shared.userModel?.purchaseCategories {
                    purchaseCategories = categories
                }
            }
        }
        .onDisappear() {
            FirebaseUserManager.shared.userRef.removeAllObservers()
        }
        .alert("Do you want to sign out?", isPresented: $showQuitAlert) {
            Button("No", role: .cancel) {
                let dataUserModel =
                UserModel(avatarImgName: "person.circle",
                          name: "Oleh Dovhan",
                          email: user.email ,
                          registrationDate: Int(Date().millisecondsSince1970),
                          cashSources: [CashSource(name: "Bank card",
                                                   amount: 0.0,
                                                   iconName: "iconBankCard"),
                                        CashSource(name: "Wallet",
                                                   amount: 0.0,
                                                   iconName: "iconWallet")],
                          purchaseCategories: [PurchaseCategory(name: "Products",iconName: "iconProducts"),
                                               PurchaseCategory(name: "Transport", iconName: "iconTransport"),
                                               PurchaseCategory(name: "Clothing", iconName: "iconClothing"),
                                               PurchaseCategory(name: "Restaurant",iconName: "iconRestaurant"),
                                               PurchaseCategory(name: "Household", iconName: "iconHousehold"),
                                               PurchaseCategory(name: "Entertainment", iconName: "iconEntertainment"),
                                               PurchaseCategory(name: "Health", iconName: "iconHealth")])
                Database.database().reference(withPath: "users").child(user.uid).setValue(["userDataModel": dataUserModel.createDic()])
            }
            
            Button("Yes", role: .destructive) {
                viewModel.signOut()
            }
        }
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
