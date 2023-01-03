//
//  ExpenseViewModel.swift
//  Saver
//
//  Created by Oleh Dovhan on 02.01.2023.
//

import SwiftUI


class ExpenseViewModel: ObservableObject {
    
    @Published var expense = 0.0
    @Published var comment = ""
    @Published var isDone = false
    @Published var expenseDate = Date.now
    
    var enteredExpense: Bool {
        switch expense {
        case let x where x > 0.0:  return false
        default:                   return true
        }
    }
    
    func addAndCalculateExpens(from cashSource: String, to spentCategory: String) {
        let expenseModel = ExpenseModel(amount: expense,
                                   comment: comment,
                                 expenseDate: Date(),
                                 cashSource: cashSource,
                                 spentCategory: spentCategory)
        if var user = UserDefaultsManager.shared.userModel {
            
            // change spendings
            if user.currentMonthSpendings == nil {
                var spendings = [ExpenseModel]()
                spendings.append(expenseModel)
                user.currentMonthSpendings = spendings
            } else  {
                user.currentMonthSpendings?.append(expenseModel)
            }
            
            var cashSourceSubstractIndex: Int?
            for (index, source) in user.cashSources.enumerated() {
                if source.name == cashSource {
                    cashSourceSubstractIndex = index
                }
            }
            if let index = cashSourceSubstractIndex {
                user.cashSources[index].substractAmount(expense)
            }
            
            
            UserDefaultsManager.shared.userModel = user
        }
    }
}
