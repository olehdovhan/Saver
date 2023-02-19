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
    
    func addAndCalculateTransferAmount(from cashSourceProvider: String, to cashSourceReceiver: String) {
        
#warning("Must be created logic of transferring money between cashSources")
        
    }
    
}

