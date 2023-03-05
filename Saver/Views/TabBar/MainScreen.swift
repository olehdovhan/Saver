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
    @State var cashSourceReceiver: String = ""
    @State var expenseType: String = ""
    @FocusState var editing: Bool
    @State var selectedCategory: PurchaseCategory?
    
    @State var amountCurrentMonthSpendingSelectedCategory: String = "0.0"
    
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
                                urlImage: $viewModel.urlImage,
                                userName: $viewModel.userName,
                                totalIncome: $viewModel.cashBalance,
                                totalExpense: $viewModel.totalExpense)
                        .zIndex(2)
                        .padding(.bottom, 15)
                    
                    GeometryReader { geometry in
                        AdaptivePagingScrollView(
                            addCashSourceViewShow: $addCashSourceViewShow,
                            incomeViewShow: $incomeViewShow,
                            expenseViewShow: $expenseViewShow,
                            purchaseType: $expenseType,
                            cashSource: $viewModel.cashSource,
                            cashSourceReceiver: $cashSourceReceiver,
                            cashSources: $viewModel.cashSources,
                            currentPageIndex: self.$activePageIndex,
                            draggingScroll: self.$draggingScroll,
                            itemsAmount:    viewModel.cashSources.count - 1,
                            itemWidth: self.itemWidth,
                            itemPadding: self.itemPadding,
                            pageWidth: geometry.size.width,
                            limitCashSourcesViewShow: $limitCashSourcesViewShow,
                            currentScrollOffset: $currentScrollOffset,
                            isNotSwipeGesture: $isNotSwipeGesture
                        ) {
                            ForEach(Array(viewModel.cashSources.enumerated()), id: \.offset) { index, source in
                                GeometryReader{ screen in
                                    CashSourceView(draggingItem: $draggingItem,
                                                   cashSourceItem: source,
                                                   index: index,
                                                   incomeViewShow: $incomeViewShow,
                                                   cashSource: $viewModel.cashSource,
                                                   cashSourceReceiver: $cashSourceReceiver,
                                                   cashSourcesCount: viewModel.cashSources.count,
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
//                    .onChange(of: addCashSourceViewShow) { newValue in
//                        viewModel.getCashSources2()
//                    }
                    .frame(height: 100)
                    
                    Spacer() .frame(height: 15)
                    
                    LinearGradient(colors: [.myGreen, .myBlue],
                                   startPoint: .leading,
                                   endPoint: .trailing)
                    .frame(width: UIScreen.main.bounds.width, height: 3, alignment: .top)
                    
                    PurchaseCategoriesView(purchaseCategories: $viewModel.purchaseCategories,
                                           addPurchaseCategoryShow: $addPurchaseCategoryViewShow,
                                           purchaseDetailViewShow: $purchaseDetailViewShow,
                                           selectedCategory: $selectedCategory,
                                           limitPurchaseCategoryViewShow: $limitPurchaseCategoryViewShow)
//                    .onChange(of: addPurchaseCategoryViewShow) { newValue in
//                        //передавати значення в user
//                        viewModel.getCashSources2()
//                    }
                    
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
                                   cashSource: viewModel.cashSource,
                                   purchaseCategoryName: $expenseType,
                                   editing: $editing,
                                   cashSources: cashSources)
                   }
                
                if incomeViewShow {
                    IncomeView(closeSelf: $incomeViewShow,
                               cashSourceNameSelect: $viewModel.cashSource,
                               editing: $editing,
                               cashSources: $viewModel.cashSources)
                }
                
                if addCashSourceViewShow {
                    AddCashSourceView(user: $viewModel.user,
                                      closeSelf: $addCashSourceViewShow,
                                      editing: $editing)
                }
                if addPurchaseCategoryViewShow {
                    AddPurchaseCategoryView(user: $viewModel.user,
                        closeSelf: $addPurchaseCategoryViewShow,
                                            editing: $editing)
                }
                
                if purchaseDetailViewShow, selectedCategory != nil {
                    PurchaseCategoryDetailView(closeSelf: $purchaseDetailViewShow,
                                               purchaseCategories: $viewModel.purchaseCategories,
                                               category: selectedCategory!,
                                               monthlyAmount: amountCurrentMonthSpendingSelectedCategory)
                }
                
                if isTransferViewShow,
                   let cashes = FirebaseUserManager.shared.userModel?.cashSources,
                   let cashSources = cashes.map { $0.name}{
                    CashSourceTransferView(closeSelf: $isTransferViewShow,
                                           cashSourceProvider: viewModel.cashSource,
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
                                viewModel.urlImage = url
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
            let amount = viewModel.currentMonthSpendings
                        .filter { $0.spentCategory == selectedCategory?.name }
                        .map { $0.amount }
                        .reduce(0) { $0 + $1 }
                    amountCurrentMonthSpendingSelectedCategory = String(amount)
        }
        .onChange(of: selectedImage) { _ in
            showImageCropper.toggle()
        }
        .onChange(of: showImageCropper) { isShowTabBar = !$0}
        .onChange(of: viewModel.progress) { isShowTabBar = !$0 }
        .onChange(of: limitPurchaseCategoryViewShow) { isShowTabBar = !$0 }
        .onChange(of: limitCashSourcesViewShow) { isShowTabBar = !$0 }
        .onChange(of: addCashSourceViewShow) { isShowTabBar = !$0 }
        .onChange(of: addPurchaseCategoryViewShow) { isShowTabBar = !$0 }
        .onChange(of: purchaseDetailViewShow) { isShowTabBar = !$0 }
        .onChange(of: incomeViewShow) { isShowTabBar = !$0 }
        .onChange(of: isTransferViewShow) { isShowTabBar = !$0 }

        .onChange(of: expenseViewShow) { isShowTabBar = !$0
            
            if let sources = FirebaseUserManager.shared.userModel?.cashSources {
                viewModel.cashSources = sources
                if sources.count != 0 {
                    viewModel.cashSource = sources[0].name
                } else {
                    viewModel.errorMessage = "error sources.count"
                    viewModel.showErrorMessage = true
                }
            } else {
                viewModel.errorMessage = "error sources"
                viewModel.showErrorMessage = true
            }
        }
        .overlay(overlayView: CustomProgressView(), show: $viewModel.progress)
        .overlay(overlayView: SnackBarView(show: $viewModel.showErrorMessage,
                                           model: SnackBarModel(type: .warning,
                                                                text: viewModel.errorMessage,
                                                                alignment: .leading,
                                                                bottomPadding: 20)),
                 show: $viewModel.showErrorMessage,
                 ignoreSaveArea: false)
     
        
        .alert("Do you want to sign out?", isPresented: $showQuitAlert) {
            Button("No", role: .cancel) {
                viewModel.progress = true
                FirebaseUserManager.shared.observeUser {
                    if let sources = FirebaseUserManager.shared.userModel?.cashSources {
                        viewModel.cashSources = sources
                        if sources.count != 0 {
                            viewModel.cashSource = sources[0].name
                            viewModel.progress = false
                        } else {
                            viewModel.errorMessage = "error sources.count"
                            viewModel.showErrorMessage = true
                        }
                    } else {
                        viewModel.errorMessage = "error source"
                        viewModel.showErrorMessage = true
                    }
                    if let categories = FirebaseUserManager.shared.userModel?.purchaseCategories {
                        viewModel.purchaseCategories = categories
                        viewModel.progress = false
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
