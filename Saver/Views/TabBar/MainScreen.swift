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
    @State var isTransferViewShow = false
    @State var incomeViewShow = false
    @State var addCashSourceViewShow = false
    @State var addPurchaseCategoryViewShow = false
    @State var purchaseDetailViewShow = false
    @State var limitCashSourcesViewShow = false
    @State var limitPurchaseCategoryViewShow = false
    @State var currentScrollOffset: CGFloat = 0
    @State var cashSource: String = ""
    @State var cashSourceReceiver: String = ""
    @State var expenseType: String = ""
    @FocusState var editing: Bool
    @State var cashSources: [CashSource] = []
    @State var purchaseCategories: [PurchaseCategory] = []
    @State var selectedCategory: PurchaseCategory?
    
    @State var amountCurrentMonthSpendingSelectedCategory: String = "0.0"
    @State var currentMonthSpendings = [ExpenseModel]()
    
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
    
    @State var progress = true
    
    var isBlur: Bool{
        limitPurchaseCategoryViewShow || limitCashSourcesViewShow || expenseViewShow || incomeViewShow || addCashSourceViewShow || addPurchaseCategoryViewShow || purchaseDetailViewShow || isTransferViewShow
    }
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var showImageCropper = false
    @State var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State var selectedImage: UIImage? {
        didSet {
            showImageCropper.toggle()
        }
    }
    @State var isImagePickerDisplay: Bool = false
    
    var body: some View {
        ZStack {
            ZStack{
                GeometryReader { reader in
                    Color.myGreen
                        .frame(height: reader.safeAreaInsets.top, alignment: .top)
                        .ignoresSafeArea(.all, edges: .top)
                    
                }
                
                VStack(alignment: .center, spacing: 0) {
                    
                    BalanceView(showQuitAlert: $showQuitAlert,
                                sourceType: $sourceType, selectedImage: $selectedImage,
                                isImagePickerDisplay: $isImagePickerDisplay)
                        .zIndex(2)
                        .padding(.bottom, 15)
                    
                    GeometryReader { geometry in
                        AdaptivePagingScrollView(
                            addCashSourceViewShow: $addCashSourceViewShow,
                            incomeViewShow: $incomeViewShow,
                            expenseViewShow: $expenseViewShow,
                            purchaseType: $expenseType,
                            cashSource: $cashSource,
                            cashSourceReceiver: $cashSourceReceiver,
                            cashSources: $cashSources,
                            currentPageIndex: self.$activePageIndex,
                            draggingScroll: self.$draggingScroll,
                            itemsAmount:    cashSources.count - 1,
                            itemWidth: self.itemWidth,
                            itemPadding: self.itemPadding,
                            pageWidth: geometry.size.width,
                            limitCashSourcesViewShow: $limitCashSourcesViewShow,
                            currentScrollOffset: $currentScrollOffset
                        ) {
                            
                            ForEach(Array(cashSources.enumerated()), id: \.offset) { index, source in
                                GeometryReader{ screen in
                                    CashSourceView(draggingItem: $draggingItem,
                                                   cashSourceItem: source,
                                                   index: index,
                                                   incomeViewShow: $incomeViewShow,
                                                   cashSource: $cashSource,
                                                   cashSourceReceiver: $cashSourceReceiver,
                                                   cashSourcesCount: cashSources.count,
                                                   expenseViewShow: $expenseViewShow,
                                                   isTransferViewShow: $isTransferViewShow,
                                                   purchaseType: $expenseType
                                    )
                                    .getLocationCashSources(source: source,
                                                            offset: currentScrollOffset)
                                }
                                .frame(width: self.itemWidth, height: 70)
                            }
                        }
                    }
                                    .zIndex(draggingItem ? 10 : -2)
                    .zIndex(3)
                    .onChange(of: addCashSourceViewShow) { newValue in
                        if let sources = FirebaseUserManager.shared.userModel?.cashSources { cashSources = sources }
                    }
                    .frame(height: 100)
                    
                    Spacer() .frame(height: 15)
                    
                    LinearGradient(colors: [.myGreen, .myBlue],
                                   startPoint: .leading,
                                   endPoint: .trailing)
                    .frame(width: UIScreen.main.bounds.width, height: 3, alignment: .top)
                    .zIndex(1)
                    
                    PurchaseCategoriesView(purchaseCategories: $purchaseCategories,
                                           addPurchaseCategoryShow: $addPurchaseCategoryViewShow,
                                           purchaseDetailViewShow: $purchaseDetailViewShow,
                                           selectedCategory: $selectedCategory,
                                           limitPurchaseCategoryViewShow: $limitPurchaseCategoryViewShow)
                    .zIndex(1)
                    .onChange(of: addPurchaseCategoryViewShow) { newValue in
                        if let purchCategories = FirebaseUserManager.shared.userModel?.purchaseCategories { purchaseCategories = purchCategories }
                    }
                    
                    Spacer()
                }
                .blur(radius: isBlur ? 5 : 0)
                .sheet(isPresented: $isImagePickerDisplay) {
                    //                print("shet")
                    ImagePickerView(selectedImage: $selectedImage, onlyImage: true, sourceType: sourceType) { url in }
                }
                
                if expenseViewShow,
                   let cashes = FirebaseUserManager.shared.userModel?.cashSources,
                   let cashSources = cashes.map { $0.name} {
                       ExpenseView(closeSelf: $expenseViewShow,
                                   cashSource: cashSource,
                                   purchaseCategoryName: $expenseType,
                                   editing: $editing,
                                   cashSources: cashSources)
                   }
                
                if incomeViewShow {
                    IncomeView(closeSelf: $incomeViewShow,
                               cashSourceNameSelect: $cashSource,
                               editing: $editing,
                               cashSources: $cashSources)
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
                                               category: selectedCategory!,
                                               monthlyAmount: amountCurrentMonthSpendingSelectedCategory)
                }
                
                if isTransferViewShow,
                   let cashes = FirebaseUserManager.shared.userModel?.cashSources,
                   let cashSources = cashes.map { $0.name}{
                    CashSourceTransferView(closeSelf: $isTransferViewShow,
                                           cashSourceProvider: cashSource,
                                           cashSourceReceiver: cashSourceReceiver,
                                           editing: $editing,
                                           cashSources: cashSources)
                }
                
                if limitCashSourcesViewShow{
                    LimitCashSourcesView(closeSelf: $limitCashSourcesViewShow)
                }
                
                if limitPurchaseCategoryViewShow{
                    LimitPurchaseCategoryView(closeSelf: $limitPurchaseCategoryViewShow)
                }
                    
            }
            
            //crop
            if showImageCropper {
                ImageCropper(image: $selectedImage, visible: $showImageCropper, isCircle: true) { image in
//                    viewModel.updateProfile(image: image)
                    print("crop")
                }
                .zIndex(10)
            }
        }
        .onChange(of: selectedCategory) { _ in
                    let ammount = currentMonthSpendings
                        .filter { $0.spentCategory == selectedCategory?.name }
                        .map { $0.amount }
                        .reduce(0) { $0 + $1 }
                    amountCurrentMonthSpendingSelectedCategory = String(ammount)
        }
        .overlay(overlayView: CustomProgressView(), show: $progress)
        .onChange(of: selectedImage) { _ in
            showImageCropper.toggle()
        }
        .onChange(of: showImageCropper) { isShowTabBar = !$0}
        .onChange(of: progress) { isShowTabBar = !$0 }
        .onChange(of: limitPurchaseCategoryViewShow) { isShowTabBar = !$0 }
        .onChange(of: limitCashSourcesViewShow) { isShowTabBar = !$0 }
        .onChange(of: addCashSourceViewShow) { isShowTabBar = !$0 }
        .onChange(of: addPurchaseCategoryViewShow) { isShowTabBar = !$0 }
        .onChange(of: purchaseDetailViewShow) { isShowTabBar = !$0 }
        .onChange(of: incomeViewShow) { isShowTabBar = !$0 }
        .onChange(of: isTransferViewShow) { newValue in
            if isTransferViewShow{
                print("AAA: isTransferViewShow: with \(cashSource) to \(cashSourceReceiver)")
            }
            isShowTabBar = !isTransferViewShow
        }
        .onChange(of: expenseViewShow) { isShowTabBar = !$0
            if let sources = FirebaseUserManager.shared.userModel?.cashSources {
                cashSources = sources
                if sources.count != 0 {
                    cashSource = sources[0].name ?? ""
                }
            }
        }
        
        .onAppear() {
            FirebaseUserManager.shared.observeUser {
                currentMonthSpendings = FirebaseUserManager.shared.userModel?.currentMonthSpendings ?? []
                
                if let sources = FirebaseUserManager.shared.userModel?.cashSources {
                    cashSources = sources
                    if sources.count != 0 {
                        cashSource = sources[0].name
                        progress = false
                    }
                }
                if let categories = FirebaseUserManager.shared.userModel?.purchaseCategories {
                    purchaseCategories = categories
                    progress = false
                }
            }
        }
        
        .alert("Do you want to sign out?", isPresented: $showQuitAlert) {
            Button("No", role: .cancel) {
                progress = true
                FirebaseUserManager.shared.observeUser {
                    if let sources = FirebaseUserManager.shared.userModel?.cashSources {
                        cashSources = sources
                        if sources.count != 0 {
                            cashSource = sources[0].name
                            progress = false
                        }
                    }
                    if let categories = FirebaseUserManager.shared.userModel?.purchaseCategories {
                        purchaseCategories = categories
                        progress = false
                    }
                    
                }
//                let dataUserModel =
//                UserModel(avatarImgName: "person.circle",
//                          name: "Oleh Dovhan",
//                          email: user.email ,
//                          registrationDate: Int(Date().millisecondsSince1970),
//                          cashSources: [CashSource(name: "Bank card",
//                                                   amount: 0.0,
//                                                   iconName: "iconBankCard"),
//                                        CashSource(name: "Wallet",
//                                                   amount: 0.0,
//                                                   iconName: "iconWallet")],
//                          purchaseCategories: [PurchaseCategory(name: "Products",iconName: "iconProducts"),
//                                               PurchaseCategory(name: "Transport", iconName: "iconTransport"),
//                                               PurchaseCategory(name: "Clothing", iconName: "iconClothing"),
//                                               PurchaseCategory(name: "Restaurant",iconName: "iconRestaurant"),
//                                               PurchaseCategory(name: "Household", iconName: "iconHousehold"),
//                                               PurchaseCategory(name: "Entertainment", iconName: "iconEntertainment"),
//                                               PurchaseCategory(name: "Health", iconName: "iconHealth")])
//                Database.database().reference(withPath: "users").child(user.uid).setValue(["userDataModel": dataUserModel.createDic()])
            }
            
            Button("Yes", role: .destructive) {
                viewModel.signOut()
            }
        }
        .onDisappear() {
            FirebaseUserManager.shared.userRef.removeAllObservers()
        }
//        .toolbar {
//            ToolbarItemGroup(placement: .keyboard) {
//                Spacer()
//                Button("Done") {
//                    editing = false
//                }
//            }
//        }
    }
}
