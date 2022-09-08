//
//  Mainscrin2.swift
//  Saver
//
//  Created by Пришляк Дмитро on 20.08.2022.
//

import SwiftUI


struct MainScreen: View {
    
    @State var isAlertShow = false
    @State var cashSource: CashSource = .wallet
    @State var expenseType: ExpenseCategory = .products
    
    var body: some View {
        ZStack{
            Color.white //.ignoresSafeArea(edges: .top)
            VStack(alignment: .center, spacing: 0){
                BalanceView().zIndex(4)
                CardsPlace(isAlertShow: $isAlertShow, purchaseType: $expenseType, cashSource: $cashSource).zIndex(3)
                StatisticsPlace().zIndex(0)
                
                LinearGradient(colors: [.myGreen, .myBlue],
                               startPoint: .leading,
                               endPoint: .trailing)
                    .frame(width: UIScreen.main.bounds.width, height: 3, alignment: .top)
                
                CoastsPlace()
                Spacer(minLength: 200)
            }
         
            if isAlertShow{
                ExpenseView(closeSelf: $isAlertShow,
                            cashSource: cashSource,
                            expenseCategory: expenseType)
                .zIndex(10)
            }
        }
        .ignoresSafeArea(.all)
    }
}

//struct Mainscrin2_Previews: PreviewProvider {
//    static var previews: some View {
//        Mainscrin2()
//    }
//
//}
