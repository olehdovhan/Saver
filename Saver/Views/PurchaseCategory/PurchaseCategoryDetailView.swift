//
//  PurchaseCategoryDetailView.swift
//  Saver
//
//  Created by Oleh Dovhan on 17.12.2022.
//

import SwiftUI
import Firebase

struct PurchaseCategoryDetailView: View {
    
    @Binding var closeSelf: Bool
    @Binding var purchaseCategories: [PurchaseCategory]
    var category: PurchaseCategory
    var monthlyAmount: String
//    @State var currentMonthSpendings: Double = .zero
    @State var latterMonthlyExpensesCategory: [ExpenseModel] = []
    @State var offsets = [CGSize] (repeating: CGSize.zero, count: 1000)
    @State var currentOffsetY: CGFloat = 0
    var body: some View {
        
        ZStack {
            SublayerView()
            
            WhiteCanvasView(width: wRatio(320), height: wRatio(440))
            
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
            
            Spacer()
            
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
            
            Spacer()
            
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
            
            Spacer().frame(height: 15)
            
//            if
                let recentExpenses = latterMonthlyExpensesCategory
//                    ,
//               !recentExpenses.isEmpty{
                
                VStack(spacing: 10){
                    ForEach(Array(latterMonthlyExpensesCategory.enumerated()), id: \.offset) { index, expense in
                        ZStack{
                            RoundedRectangle(cornerRadius: 5).fill(.red)
                                .frame(width: wRatio(280), height: wRatio(40))
                                .myShadow(radiusShadow: 5)
                            
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
                            .frame(width: wRatio(280), height: wRatio(40))
                            
                            
                            
                        VStack(spacing: 0){
                            HStack(spacing: 0) {
                                
                                HStack{
                                    Spacer().frame(width: 5)
                                    Text(expense.expenseDate.formatDateAndTime())
                                        .multilineTextAlignment(.leading)
                                        .lineLimit(1)
                                        .font(.custom("Lato-Regular", size: 14))
                                    Spacer()
                                }
                                .frame(width: wRatio(90))
                                
                                Spacer().frame(width: 5)
                                
                                HStack{
                                    Text(expense.amount.formatted())
                                        .multilineTextAlignment(.leading)
                                        .lineLimit(1)
                                        .font(.custom("Lato-SemiBold", size: 14, relativeTo: .body))
                                    Spacer()
                                }
                                .frame(width: wRatio(90))
                                //
                                Spacer().frame(width: 5)
                                
                                HStack{
                                    Text(expense.cashSource)
                                        .multilineTextAlignment(.leading)
                                        .lineLimit(1)
                                        .font(.custom("Lato-SemiBold", size: 14, relativeTo: .body))
                                    
                                    Spacer(minLength: 5)
                                }
                                .frame(width: wRatio(90))
                                //
                            }
                            
                            HStack(spacing: 0){
                                Spacer()
                                Text("Comment: \(expense.comment)")
                                    .foregroundColor(.myGrayDark)
                                    .multilineTextAlignment(.trailing)
                                    .lineLimit(1)
                                    .font(.custom("Lato-Regular", size: 14))
                                    .foregroundColor(Color(hex: "A9A9A9"))
                                    .opacity(!expense.comment.isEmpty ? 1 : 0)
                            }
                            .frame(width: wRatio(250))
                            
                            
                            
                        }
                        .frame(width: wRatio(280), height: wRatio(40))
                        .background(
                            RoundedRectangle(cornerRadius: 5)
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
                                (index <= offsets.count - 1) ? offsets[index + 1].width = .zero : ()
                                
                                if var user = FirebaseUserManager.shared.userModel {
                                    
                                    //return cash
                                    let cashSourceReturn = latterMonthlyExpensesCategory[index].cashSource
                                    let amountReturn = latterMonthlyExpensesCategory[index].amount
                                    
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
                                        .firstIndex(where: {$0 == latterMonthlyExpensesCategory[index]}){
                                        currentMonthSpendings?.remove(at: indexDel)
                                        latterMonthlyExpensesCategory.remove(at: index)
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
                
                
//            }
            
            Spacer()
        }
        .padding(.top, wRatio(10))
        .frame(width: wRatio(320),
               height: wRatio(440))
      }
        .onAppear(){
#warning("return ammount to Incomes")
            if let currentMonthSpendings = FirebaseUserManager.shared.userModel?.currentMonthSpendings{
                let monthCategorySpendings = currentMonthSpendings.filter{$0.spentCategory == category.name}
                if !monthCategorySpendings.isEmpty{
                    latterMonthlyExpensesCategory = Array(monthCategorySpendings.suffix(3))
                    print(latterMonthlyExpensesCategory as Any)
                }
                
                
            }
        }
        
    
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
//
//
//
        }
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
            if let cashes = FirebaseUserManager.shared.userModel?.purchaseCategories {
                purchaseCategories = cashes
            }
            closeSelf = false
        }
    }
}


struct Previews_PurchaseCategoryDetailView: PreviewProvider {
    static var previews: some View {
        PurchaseCategoryDetailView(closeSelf: .constant(false),
                                   purchaseCategories: .constant([]),
                                   category: PurchaseCategory.init(name: "Products", iconName: "iconProducts", planSpentPerMonth: 1000), monthlyAmount: "2000")
        
//        MainScreen(isShowTabBar: .constant(false), purchaseDetailViewShow: true, selectedCategory: PurchaseCategory.init(name: "Products", iconName: "iconProducts", planSpentPerMonth: 1000))
            .previewDevice(PreviewDevice(rawValue: "iPhone 7 Plus"))
            .previewDisplayName("iPhone 7 Plus")
        
//        MainScreen(isShowTabBar: .constant(false), purchaseDetailViewShow: true, selectedCategory: PurchaseCategory.init(name: "Products", iconName: "iconProducts", planSpentPerMonth: 1000))
//            .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro"))
//            .previewDisplayName("iPhone 14 Pro")
    }
}
