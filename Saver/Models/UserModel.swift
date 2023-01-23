//
//  UserModel.swift
//  Saver
//
//  Created by Oleh Dovhan on 07.11.2022.
//

import SwiftUI

struct UserModel: Codable {
    // TODO: add cashFlow( general) - Income - expense ( monthly budget) + cashFlow(full) Income - (expense + goals + debts)
    var avatarImgName: String
    var name: String
    var email: String
    var registrationDate: Date
    
    // CashSources
    var cashSources: [CashSource]
    
    // ExpenseCategories
    var purchaseCategories: [PurchaseCategory]
    
    // Spendings
    var currentMonthSpendings: [ExpenseModel]?
    var previousMonthesSpendings: [ExpenseModel]?
//    var totalDebtsPaymentPerMonth: Int {
//        var sum = Int()
//        for debt in debts {
//            sum += debt.monthlyDebtPayment
//        }
//        return sum
//    }
    var debts: [DebtModel]?
    
    //Budget
    var planBudget: Budget?
    var thisMonthBudget: Budget?
    var previousMonthesBudgets: [Budget]?
    private var averageBudget: Int? {
        if previousMonthesBudgets?.count != 0 {
            var total = Int()
            guard previousMonthesBudgets != nil else { return nil}
            for budget in previousMonthesBudgets! {
                total += budget.totalMonth
            }
            return total / previousMonthesBudgets!.count
        } else if planBudget != nil {
            return planBudget!.totalMonth
            
        } else {
            return nil
        }
    }
    
    // GoalsBudget
    var planGoalsBudget: Budget?
    var thisMonthGoalsBudget: Budget?
    var previousMonthesGoalsBudgets: [Budget]?
        
    private var averageGoalsBudget: Int? {
        var total = Int()
        if previousMonthesGoalsBudgets?.count != 0 {
            for budget in previousMonthesBudgets! {
                total += budget.totalMonth
            }
            return total / previousMonthesGoalsBudgets!.count
        } else if planGoalsBudget != nil {
            return planGoalsBudget!.totalMonth
        } else {
            return nil
            
        }
    }
    
    // make it computed from
//    var freeDays: Double? {
//        // 30.44 average days count in month in regular and leap years
//        if averageBudget != nil,
//           averageGoalsBudget != nil {
//            let oneDayCost = Double(averageBudget! + averageGoalsBudget!) / 30.44 // add averageGoalsMoney
//            return saver / oneDayCost
//        } else { return nil }
//    }
    // savings
    
    // TODO: Add mandatory monthly payment in your saver, add your goal it deadline / While adding money to saver show percentage of month income or last income - with prompt which percent is good, enough or less
    var saver: Double?
    
//    var totalGoalsPaymentPerMonth: Int {
//        var sum = Int()
//        for goal in goals {
//            sum += goal.collectingSumPerMonth
//        }
//        return sum
//    }
    
    var goals: [Goal]?
    
    // write logic depends on this func will execute every month on the first day
    func renewThisMonthBudgetAndAverage() {}
}

struct Goal: Codable, Hashable {
    var name: String
    var totalPrice: Int
    var collectedPrice: Int
    var collectingSumPerMonth: Int
    
    
    var totalMonthesPerGoal: Int {
        return Int(Double(totalPrice) / Double(collectingSumPerMonth))
    }
    
    private var restMonthesPerGoal: Int {
        totalMonthesPerGoal - monthesSaveForGoal
    }
    //TODO: in app notifications every month: Did you save money for this goal? - depends on answer - add changes to collectedPrice
     var monthesSaveForGoal = 0
}

struct Budget: Codable {
    var totalMonth: Int {
        var totalMonth = Int()
        for i in categories { totalMonth += i.sum }
        return totalMonth
    }
    var categories: [PlanBudgetCategory]
}

struct PlanBudgetCategory: Codable {
    var name: String
    var sum: Int
}

struct ExpenseModel: Codable {
    var amount: Double
    var comment: String
    var expenseDate: Date
    var cashSource: String
    var spentCategory: String
}

struct DebtModel: Codable, Hashable {
    var whose: DebtEnum
    var name: String
    var totalAmount: Int
    var startDate: Date
    var totalMonthesForReturn: Int
    var returnedAmount: Int
    //TODO: in app notifications every month: Did you save money for this goal? - depends on answer - add changes to collectedPrice
    var monthlyDebtPayment: Int {Int ( Double(totalAmount) / Double(totalMonthesForReturn)) }
    
}

// описати PercentageDividerCounterToGoalInMonthes
enum DebtEnum: String, Codable, Equatable, CaseIterable, Identifiable {
    case gave, took

    var id: DebtEnum { self }
}

struct CashSource: Codable, Hashable, Identifiable, Equatable {
    var id = UUID()
    var name: String
    var amount: Double
    var iconName: String
    
    mutating func substractAmount(_ number: Double) {
        amount -= number
    }
}

struct PurchaseCategory: Codable, Hashable {
    var name: String
    var iconName: String
    var planSpentPerMonth: Double?
}

