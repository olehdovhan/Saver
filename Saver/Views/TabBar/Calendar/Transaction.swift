//
//  Transaction.swift
//  Saver
//
//  Created by Pryshliak Dmytro on 20.12.2022.
//

import Foundation

import SwiftUI

enum CashSourceOld: String {
    case wallet = "Wallet"
    case bankCard = "Bank Card"
}

enum PurchaseCategoryOld: String {
    case products
    case transport
    case clouthing
    case restaurant
}


enum Currency{
    case USD
    case EUR
    case UAH
}

enum TransactionType{
    case income
    case expense
}


struct TransactionModel: Identifiable{
    var id = UUID().uuidString
    var date: Date
    var transactionType: TransactionType
    var volume: Float
    var currency: Currency
    var cashSource: CashSourceOld
    var expenseCategory: PurchaseCategoryOld?
    var comment: String
}


let calendar = Calendar.current
let date = Date()

//Цей масив, який визначає дні витратрат і надходжень у вигляді точок нам календарю
var transactions: [TransactionModel] = [
    TransactionModel(date:  calendar.date(from: DateComponents(calendar: calendar, year: 2022, month: 12, day: 11, hour: 11, minute: 11))!,
                transactionType: .expense,
                volume: 1500,
                currency: .USD ,
                cashSource: .bankCard,
                expenseCategory: .clouthing,
                comment: "nehay"),
    
    TransactionModel(date: calendar.date(from: DateComponents(calendar: calendar, year: 2022, month: 12, day: 12, hour: 12, minute: 11))!,
                transactionType: .expense,
                volume: 300,
                currency: .USD ,
                cashSource: .bankCard,
                expenseCategory: .products,
                comment: "nehay"),
    
    TransactionModel(date: calendar.date(from: DateComponents(calendar: calendar, year: 2022, month: 12, day: 13, hour: 13, minute: 11))!,
                transactionType: .income,
                volume: 2000,
                currency: .USD ,
                cashSource: .bankCard,
                expenseCategory: nil,
                comment: "nehay"),
    
    TransactionModel(date: calendar.date(from: DateComponents(calendar: calendar, year: 2022, month: 12, day: 14, hour: 14, minute: 11))!,
                transactionType: .expense,
                volume: 700,
                currency: .USD ,
                cashSource: .bankCard,
                expenseCategory: .restaurant,
                comment: "nehay"),
    
    TransactionModel(date: calendar.date(from: DateComponents(calendar: calendar, year: 2022, month: 12, day: 14, hour: 13, minute: 11))!,
                transactionType: .income,
                volume: 2000,
                currency: .USD ,
                cashSource: .bankCard,
                expenseCategory: nil,
                comment: "nehay")
    ]


