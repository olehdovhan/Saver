//
//  ExpenseViewModel.swift
//  Saver
//
//  Created by Oleh Dovhan on 02.01.2023.
//

import SwiftUI


class ExpenseViewModel: ObservableObject {
    
    @Published var expense = ""
    @Published var comment = ""
    @Published var isDone = false
    @Published var expenseDate = Date.now
    
    var enteredExpense: Bool {
        switch expense {
        case let x where Double(x.commaToDot())! > 0.0:
            return false
        default:
            return true
        }
    }
    
    func addAndCalculateExpense(from cashSource: String, to spentCategory: String) {
        let expenseModel = ExpenseModel(amount: Double(expense.commaToDot())!,
                                   comment: comment,
                                 expenseDate: Date(),
                                 cashSource: cashSource,
                                 spentCategory: spentCategory)
        if var user = FirebaseUserManager.shared.userModel {
            
            // change spendings
            if user.currentMonthSpendings == nil {
                var spendings = [ExpenseModel]()
                spendings.append(expenseModel)
                user.currentMonthSpendings = spendings
                
            } else  {
                user.currentMonthSpendings?.append(expenseModel)
            }
            
            var cashSourceSubtractIndex: Int?
            for (index, source) in user.cashSources.enumerated() {
                if source.name == cashSource {
                    cashSourceSubtractIndex = index
                }
            }
            if let index = cashSourceSubtractIndex {
                user.cashSources[index].subtractAmount(Double(expense.commaToDot())!)
            }
            
            FirebaseUserManager.shared.userModel = user
            
        }
    }
}
