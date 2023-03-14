//
//  PurchaseCategoryDetailView.swift
//  Saver
//
//  Created by Oleh Dovhan on 17.12.2022.
//

import SwiftUI
import Firebase

struct PurchaseCategoryDetailView: View {
    @State private var height: CGFloat = 0
    
    @Binding var user: UserModel?
    @Binding var closeSelf: Bool
    var category: PurchaseCategory
    @State var monthlyCategoryExpenses: [ExpenseModel] = []
    @State var offsets = [CGSize] (repeating: CGSize.zero, count: 3)
    @State var currentOffsetY: CGFloat = 0
    
    var latterMonthly3ExpensesCategory: [ExpenseModel]{
        monthlyCategoryExpenses.suffix(3)
    }
    
    var monthlyAmount: String{
        String(monthlyCategoryExpenses.map { $0.amount }.reduce(0) { $0 + $1 })
    }
    
    
    var body: some View {
        
        ZStack {
            SublayerView()
            
            WhiteCanvasView(width: wRatio(320), height: wRatio(320) + height)
            
        VStack(spacing: 0) {
            
            HStack{
                ImageCategoryView
                
                Text(category.name)
                    .textHeaderStyle()
                
                Spacer()
                
                DeleteSelfButtonView {
                    deletePurchaseCategory()
                }
                
                CloseSelfButtonView($closeSelf)
            }
            .fixedSize(horizontal: false, vertical: true)
            .padding(.trailing, wRatio(10))
            .padding(.leading, wRatio(30))
            
            Spacer().frame(height: wRatio(35))
            
            VStack(spacing: 10){
                Text("Budget month plan:")
                    .foregroundColor(.myGrayDark)
                    .font(.custom("Lato-Bold", size: 14))
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
                    .textCase(.uppercase)
                
                switch category.planSpentPerMonth {
                  case nil:
                    Text("You have not added spend plan for month yet")
                        .foregroundColor(.myGrayDark)
                        .font(.custom("Lato-Regular", size: 14))
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                default:
                    Text(String(category.planSpentPerMonth!))
                        .foregroundColor(.myGrayDark)
                        .font(.custom("Lato-Regular", size: 14))
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                  }
            }
            .frame(width: wRatio(250), height: wRatio(80))
            .background(
                RoundedRectangle(cornerRadius: 15).fill(.white)
                    .myShadow(radiusShadow: 5)
            )
            
            Spacer().frame(height: wRatio(20))
            
            VStack(spacing: 10){
                Text("Spending this Month:")
                    .foregroundColor(.myGrayDark)
                    .font(.custom("Lato-Bold", size: 14))
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
                    .textCase(.uppercase)
                
                // TODO: make btn on tap open view with expenses for this category
                
                Text(monthlyAmount + "$")
                    .foregroundColor(.myGrayDark)
                    .font(.custom("Lato-Regular", size: 14))
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                
            }
            .frame(width: wRatio(250), height: wRatio(80))
            .background(
                RoundedRectangle(cornerRadius: 15).fill(.white)
                    .myShadow(radiusShadow: 5)
            )
            
            
            if !latterMonthly3ExpensesCategory.isEmpty{
                latter3ExpensesView
            }
            

            Spacer()
        }
        .padding(.top, wRatio(10))
        .frame(width: wRatio(320),
               height: wRatio(320 ) + height)
            
      }
 
        
        .onAppear(){
            updateExpenses()
        }
        .onChange(of: user) { _ in
            updateExpenses()
        }

   }
    
    var latter3ExpensesView: some View{
        VStack(spacing: 10){
            Spacer().frame(height: 20)
            
            HStack(spacing: 5){
                
                    Text("Time")
                        .fontWeight(.semibold)
                        .frame(maxWidth: wRatio(80))
         
                    Text(Locale.current.currencyCode ?? "USD")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
//
                    Text("Category" )
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
//
            }
            .font(.callout)
            .foregroundColor(.gray)
            .frame(width: wRatio(250))

            ForEach(Array(latterMonthly3ExpensesCategory.enumerated()), id: \.offset) { index, expense in
                ZStack{
                    Rectangle().fill(.red)
                        .overlay{
                            HStack{
                                Spacer()
                                Label {
                                    Text("Delete")
                                        .foregroundColor(Color.white)
                                } icon: {
                                    Image(systemName: "trash")
                                        .foregroundColor(Color.white)
                                }
                                .padding(.trailing, 10)
                            }
                        }
                        .frame(width: wRatio(280), height: wRatio(40))
                    
                    
                VStack(){
                    
                    
                    Divider().foregroundColor(.myBlue)
                    HStack(spacing: 5) {
                        
                       
                            Text(expense.expenseDate.formatDateAndTime())
                                .frame(maxWidth: wRatio(80))
                       
                            Text(expense.amount.formatted())
                                .frame(maxWidth: .infinity)
                      
                        
                            Text(expense.cashSource)
                            .frame(maxWidth: .infinity)
                    }
                    .font(.custom("Lato-Regular", size: wRatio(14)))
                    
                    HStack(spacing: 0){
                        
                        Text("Note: \(expense.comment)")
                            .italic()
                            .foregroundColor(.gray)
                            .font(.system(size: 12))
                            .opacity(expense.comment.isEmpty ? 0 : 1)
                        
                        Spacer()
                    }
                    
                }
                .blur(radius: abs(offsets[index].width) * 0.015)
                .lineLimit(1)
                .frame(width: wRatio(250))
                .background(
                    Rectangle()
                        .fill(self.offsets[index].width < -100 ? Color(hex: "ffc0cb") : .white )
                        .frame(width: wRatio(280), height: wRatio(40))
                        
                )
                .offset(x: offsets[index].width)
                .gesture(DragGesture() .onChanged { gesture in
                    if gesture.translation.width < 0 {
                        if gesture.translation.width >= -120 {
                            withAnimation(Animation.easeIn(duration: 0.3)) {
                                self.offsets[index] = gesture.translation
                                if offsets[index].width > 50 {
                                    self.offsets[index] = .zero
                                    
                                }
                            }
                            
                        }
                    }
                }.onEnded { _ in
                    if self.offsets[index].width < -100 {
                        
                        offsets[index].width = .zero
                        (index >= 1) ? offsets[index - 1].width = .zero : ()
//                        (index <= offsets.count - 1) ? offsets[index + 1].width = .zero : ()
                        
                        if var user = FirebaseUserManager.shared.userModel {
                            
                            //return cash
                            let cashSourceReturn = latterMonthly3ExpensesCategory[index].cashSource
                            let amountReturn = latterMonthly3ExpensesCategory[index].amount
                            
                            var cashSourceIncreaseIndex: Int?
                            for (index, source) in user.cashSources.enumerated() {
                                if source.name == cashSourceReturn {
                                    cashSourceIncreaseIndex = index
                                }
                            }
                            
                            if let index = cashSourceIncreaseIndex {
                                user.cashSources[index].increaseAmount(amountReturn)
                            }
                            
                            //delete spend
                            var currentMonthSpendings = user.currentMonthSpendings
                            
                            if let indexDel = currentMonthSpendings?
                                .firstIndex(where: {$0 == latterMonthly3ExpensesCategory[index]}){
                                currentMonthSpendings?.remove(at: indexDel)
                            }
                            
                            user.currentMonthSpendings = currentMonthSpendings
                            
                            FirebaseUserManager.shared.userModel = user

                        }
                        
                    } else {
                        withAnimation(Animation.easeIn(duration: 0.3)) {
                            offsets[index].width = .zero
                        }
                    }
                })
            }
                
                
            }
            
            
        }
        .background(GeometryReader { proxy in
            Color.clear
                .onChange(of: proxy.size.height, perform: { newValue in
                    withAnimation(Animation.easeIn(duration: 0.5)) {
                        self.height = proxy.size.height
                    }

                })
                .onAppear {
                self.height = proxy.size.height
            }
                .onDisappear{
                    withAnimation(Animation.easeIn(duration: 0.5)) {
                        self.height = 0
                    }
                    }

        }
        )
        
        
    }

    var ImageCategoryView: some View{
        ZStack{
            switch category.iconName {
            case "iconClothing",
                "iconEntertainment",
                "iconHealth",
                "iconHousehold",
                "iconProducts",
                "iconRestaurant",
                "iconTransport":
                Image(category.iconName)
                    .resizable()
                    .frame(width: 30, height: 30)
                
            default:
                ZStack{
                    Color.white
                        .frame(width: 30, height: 30)
                        .cornerRadius(10)
                        .myShadow(radiusShadow: 5)
                    
                    Image(category.iconName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                        .foregroundColor(.gray)
                        .cornerRadius(10)
                    
                }
                
            }

        }
    }
    
    func updateExpenses() -> Void{
        guard let currentMonthSpendings = user?.currentMonthSpendings else {return}
        monthlyCategoryExpenses = currentMonthSpendings.filter{$0.spentCategory == category.name}
    }
    
    func deletePurchaseCategory() {
        if var user = FirebaseUserManager.shared.userModel {
            var purchCats = user.purchaseCategories
            for (index,source) in purchCats.enumerated() {
                if source.name == category.name {
                    purchCats.remove(at: index)
                }
            }
            
            user.purchaseCategories = purchCats
            FirebaseUserManager.shared.userModel = user
            
            closeSelf = false
        }
    }
}


//struct Previews_PurchaseCategoryDetailView: PreviewProvider {
//    static var previews: some View {
//        PurchaseCategoryDetailView(closeSelf: .constant(false),
//                                   purchaseCategories: .constant([]),
//                                   category: PurchaseCategory.init(name: "Products", iconName: "iconProducts", planSpentPerMonth: 1000), monthlyAmount: "2000")
//
////        MainScreen(isShowTabBar: .constant(false), purchaseDetailViewShow: true, selectedCategory: PurchaseCategory.init(name: "Products", iconName: "iconProducts", planSpentPerMonth: 1000))
//            .previewDevice(PreviewDevice(rawValue: "iPhone 7 Plus"))
//            .previewDisplayName("iPhone 7 Plus")
//
////        MainScreen(isShowTabBar: .constant(false), purchaseDetailViewShow: true, selectedCategory: PurchaseCategory.init(name: "Products", iconName: "iconProducts", planSpentPerMonth: 1000))
////            .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro"))
////            .previewDisplayName("iPhone 14 Pro")
//    }
//}
