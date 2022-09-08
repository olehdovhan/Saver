//
//  CashSource.swift
//  Saver
//
//  Created by O l e h on 06.09.2022.
//

import Foundation

enum CashSource: String, CaseIterable {
    case wallet = "Wallet"
    case bankCard = "Bank Card"
}

enum ExpenseCategory: String, CaseIterable {
    case products = "Products"
    case transport = "Transport"
    case clothing = "Clothing"
    case restaurant = "Restaraunt"
}
