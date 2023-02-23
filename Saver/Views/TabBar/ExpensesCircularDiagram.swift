//
//  IncomeAndExpenses.swift
//  Saver
//
//  Created by Пришляк Дмитро on 20.08.2022.
//

import SwiftUI

struct Prewiew_ExpensesCircularDiagram: PreviewProvider {
    static var previews: some View {
        ExpensesCircularDiagram(selectedTab: .constant(1))
        
        
    }
}

struct ExpensesCircularDiagram: View {
    
    @Binding var selectedTab: Int
    @State var isPercent: Bool = true
    @State var isNoExpenses: Bool = true
    
    var body: some View {
        Group{
            if isNoExpenses {
                VStack(spacing: 0) {
                    HStack {
                        Text("Expenses".uppercased())
                            .foregroundColor(.myGreen)
                            .font(.custom("Lato-Bold", size: wRatio(25)))

                        Spacer()
                    }
                    .padding(.horizontal, wRatio(25))
                    .padding(.top, 10)

                    ZStack{
                        Image("diagramDefault")
                            .resizable()
                            .frame(width: wRatio(350), height: wRatio(350))
//                            .saturation(0)

                        Text("?")
                            .font(.custom("Lato-SemiBold", size: 50))
                            .foregroundColor(.myGreen)

                    }
                    .padding(.top, 30)
                    .padding(.bottom, 30)

                    LinearGradient(colors: [.myGreen, .myBlue],
                                   startPoint: .leading,
                                   endPoint: .trailing)
                    .frame(width: UIScreen.main.bounds.width, height: 3)

                    Text("To display the chart, do the expenses first")
                        .font(.custom("Lato-Regular", size: 16))
                        .padding(.top, 30)



                    Spacer()


                }
            } else {
                VStack(spacing: 0) {
                    HStack {
                        Text("Expenses".uppercased())
                            .foregroundColor(.myGreen)
                            .font(.custom("Lato-Bold", size: wRatio(25)))
                        Spacer()
                        
                        Button{
                            isPercent = true
                        } label: {
                            Image("iconPercent")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .colorMultiply(isPercent ? .myGreen : .white)
                            //                        .shadow(radius: 5)
                        }
                        
                        Button{
                            isPercent = false
                        } label: {
                            Image("iconDollar")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .colorMultiply(isPercent ? .white : .myGreen)
                            //                        .shadow(radius: 5)
                        }
                    }
                    .padding(.horizontal, wRatio(25))
                    .padding(.top, 10)
                    
                    
                    PieChart(selectedTab: $selectedTab, isPercent: $isPercent)
                    
                    
                    Spacer()
                }
            }
        }
        .onChange(of: selectedTab) { newValue in
            if FirebaseUserManager.shared.userModel?.currentMonthSpendings != nil &&
               FirebaseUserManager.shared.userModel?.currentMonthSpendings?.count != 0 {
                //є наповнення
                isNoExpenses = false
                print("isNoExpenses: \(isNoExpenses)")
            } else {
                //немає наповнення
                isNoExpenses = true
                print("isNoExpenses: \(isNoExpenses)")
            }
        }
        
        
    }
}

