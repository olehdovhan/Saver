//
//  CashSourceTransferViewModel.swift
//  Saver
//
//  Created by Oleh on 19.02.2023.
//

import SwiftUI

class CashSourceTransferViewModel: ObservableObject {
    
    @Published var transferAmount = 0.0
    @Published var comment = ""
    @Published var isDone = false
    @Published var expenseDate = Date.now
    
    var isEnteredTransferAmount: Bool {
        switch transferAmount {
        case let x where x > 0.0:  return false
        default:                   return true
        }
    }
    
    func transferBetweenCashSources(from cashSourceProvider: String,
                                    to cashSourceReceiver: String) -> Void {
        
        if var user = FirebaseUserManager.shared.userModel {
            
            var cashSourceSubtractIndex: Int?
            var cashSourceIncreaseIndex: Int?
            
            for (index, source) in user.cashSources.enumerated() {
                if source.name == cashSourceProvider {
                    cashSourceSubtractIndex = index
                }
            }
            
            for (index, source) in user.cashSources.enumerated() {
                if source.name == cashSourceReceiver {
                    cashSourceIncreaseIndex = index
                }
            }
            
            if let indexSubtract = cashSourceSubtractIndex,
               let indexIncrease = cashSourceIncreaseIndex{
                user.cashSources[indexSubtract].subtractAmount(transferAmount)
                user.cashSources[indexIncrease].increaseAmount(transferAmount)
            }
            
            FirebaseUserManager.shared.userModel = user
        }
        
        
    }
    
}

