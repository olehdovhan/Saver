//
//  Mainscrin2.swift
//  Saver
//
//  Created by Пришляк Дмитро on 20.08.2022.
//

import SwiftUI
import Firebase

struct MainScreen: View {
    @StateObject var viewModel = MainScreenViewModel()
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
    @State var isNotSwipeGesture: Bool = false
    @State private var draggingIndex: Int?
    @State var leadingOffsetScroll: CGFloat = 0
    let itemWidth: CGFloat = UIScreen.main.bounds.width * 0.2325
    let itemPadding: CGFloat = 6
    
    
    @State var userRef: DatabaseReference!
    @State var tasks = [TaskFirModel]()
    @State var urlImage: URL?
    
    @State var progress = true
    
    @State var userName: String = "User Name"
    @State var totalIncome: Double = .zero
    @State var totalExpense: Double = .zero
    
    var isBlur: Bool{
        limitPurchaseCategoryViewShow || limitCashSourcesViewShow || expenseViewShow || incomeViewShow || addCashSourceViewShow || addPurchaseCategoryViewShow || purchaseDetailViewShow || isTransferViewShow
    }
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var showImageCropper = false
    @State var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State var selectedImage: UIImage? {
        didSet {
            showImageCropper.toggle()
            //TODO: - send to storage  
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
                                sourceType: $sourceType,
                                selectedImage: $selectedImage,
                                isImagePickerDisplay: $isImagePickerDisplay,
                                urlImage: $urlImage,
                                userName: $userName,
                                totalIncome: $totalIncome,
                                totalExpense: $totalExpense)
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
                            currentScrollOffset: $currentScrollOffset,
                            isNotSwipeGesture: $isNotSwipeGesture
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
                                                   purchaseType: $expenseType,
                                                   draggingIndex: $draggingIndex,
                                                   isNotSwipeGesture: $isNotSwipeGesture
                                    )
                                    .getLocationCashSources(source: source,
                                                            offset: currentScrollOffset)
                                }
                                .frame(width: self.itemWidth, height: 70)
                            }
                        }
                    }
                    
                    .zIndex(draggingItem ? 30 : 1)
                    .onChange(of: addCashSourceViewShow) { newValue in
                        if let sources = FirebaseUserManager.shared.userModel?.cashSources { cashSources = sources } else {
                            viewModel.errorMessage = "error sources"
                            viewModel.showErrorMessage = true
                        }
                    }
                    .frame(height: 100)
                    
                    Spacer() .frame(height: 15)
                    
                    LinearGradient(colors: [.myGreen, .myBlue],
                                   startPoint: .leading,
                                   endPoint: .trailing)
                    .frame(width: UIScreen.main.bounds.width, height: 3, alignment: .top)
//                    .zIndex(1)
                    
                    PurchaseCategoriesView(purchaseCategories: $purchaseCategories,
                                           addPurchaseCategoryShow: $addPurchaseCategoryViewShow,
                                           purchaseDetailViewShow: $purchaseDetailViewShow,
                                           selectedCategory: $selectedCategory,
                                           limitPurchaseCategoryViewShow: $limitPurchaseCategoryViewShow)
//                    .zIndex(1)
                    .onChange(of: addPurchaseCategoryViewShow) { newValue in
                        if let purchCategories = FirebaseUserManager.shared.userModel?.purchaseCategories { purchaseCategories = purchCategories } else {
                            viewModel.errorMessage = "error purchCategories"
                            viewModel.showErrorMessage = true
                        }
                    }
                    
                    Spacer()
                }
                .blur(radius: isBlur ? 5 : 0)
                .sheet(isPresented: $isImagePickerDisplay) {
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
                
                if limitCashSourcesViewShow {
                    LimitCashSourcesView(closeSelf: $limitCashSourcesViewShow)
                }
                
                if limitPurchaseCategoryViewShow {
                    LimitPurchaseCategoryView(closeSelf: $limitPurchaseCategoryViewShow)
                }
            }
            
            //crop
            if showImageCropper {
                ImageCropper(image: $selectedImage, visible: $showImageCropper, isCircle: true) { image in
                    if let currentUser = Auth.auth().currentUser {
                        FirebaseUserManager.shared.uploadImage(img: image,
                                                               uID: currentUser.uid) { imgUrlString in
                            // 1. userModel
                            if let imgUrlString = imgUrlString, var user = FirebaseUserManager.shared.userModel {
                                user.avatarUrlString = imgUrlString
                                FirebaseUserManager.shared.userModel = user
                            }                             // 2.
                            if let urlString = FirebaseUserManager.shared.userModel?.avatarUrlString, let url = URL(string: urlString) {
                                urlImage = url
                            }
                        }
                    } else {
                        viewModel.errorMessage = "error currentUser"
                        viewModel.showErrorMessage = true
                    }
                   
                }
                .zIndex(10)
            }
        }
        .onChange(of: selectedCategory) { _ in
                    let amount = currentMonthSpendings
                        .filter { $0.spentCategory == selectedCategory?.name }
                        .map { $0.amount }
                        .reduce(0) { $0 + $1 }
                    amountCurrentMonthSpendingSelectedCategory = String(amount)
        }
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
        .onChange(of: draggingItem, perform: { newValue in
            print("AAA drag: \(draggingItem)")
        })
        .onChange(of: expenseViewShow) { isShowTabBar = !$0
            if let sources = FirebaseUserManager.shared.userModel?.cashSources {
                cashSources = sources
                if sources.count != 0 {
                    cashSource = sources[0].name
                } else {
                    viewModel.errorMessage = "error sources.count"
                    viewModel.showErrorMessage = true
                }
            } else {
                viewModel.errorMessage = "error sources"
                viewModel.showErrorMessage = true
            }
        }
        .overlay(overlayView: CustomProgressView(), show: $progress)
        .overlay(overlayView: SnackBarView(show: $viewModel.showErrorMessage,
                                           model: SnackBarModel(type: .warning,
                                                                text: viewModel.errorMessage,
                                                                alignment: .leading,
                                                                bottomPadding: 20)),
                 show: $viewModel.showErrorMessage,
                 ignoreSaveArea: false)
        .onChange(of: draggingItem, perform: { newValue in
            print(" dragingItem: \(draggingItem)")
        })
        .onAppear() {

        FirebaseUserManager.shared.observeUser {
            userName = FirebaseUserManager.shared.userModel?.name ?? "First Name"
            currentMonthSpendings =  FirebaseUserManager.shared.userModel?.currentMonthSpendings ?? []
            totalExpense = currentMonthSpendings.reduce(0, {$0 + $1.amount})
            
            if let currentMonthIncoms = FirebaseUserManager.shared.userModel?.currentMonthIncoms{
                print(currentMonthIncoms)
                totalIncome = currentMonthIncoms.reduce(0, {$0 + $1.amount})
            }
            
            if let sources = FirebaseUserManager.shared.userModel?.cashSources {

                    cashSources = sources
                    if sources.count != 0 {
                        cashSource = sources[0].name
                        progress = false
                    }
            } else {
                viewModel.errorMessage = "error sources"
                viewModel.showErrorMessage = true
            }
                if let categories = FirebaseUserManager.shared.userModel?.purchaseCategories {
                    purchaseCategories = categories
                    progress = false
                } else {
                    viewModel.errorMessage = "error categories"
                    viewModel.showErrorMessage = true
                }
            
            if let urlString = FirebaseUserManager.shared.userModel?.avatarUrlString, let url = URL(string: urlString) {
                urlImage = url
            } else {
                viewModel.errorMessage = "error urlString"
                viewModel.showErrorMessage = true
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
                        } else {
                            viewModel.errorMessage = "error sources.count"
                            viewModel.showErrorMessage = true
                        }
                    } else {
                        viewModel.errorMessage = "error source"
                        viewModel.showErrorMessage = true
                    }
                    if let categories = FirebaseUserManager.shared.userModel?.purchaseCategories {
                        purchaseCategories = categories
                        progress = false
                    } else {
                        viewModel.errorMessage = "error categories"
                        viewModel.showErrorMessage = true
                    }
                }
            }
            
            Button("Yes", role: .destructive) {
                viewModel.signOut()
            }
        }
        .onDisappear() {
            FirebaseUserManager.shared.userRef.removeAllObservers()
        }
    }
}
