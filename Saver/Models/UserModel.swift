//
//  UserModel.swift
//  Saver
//
//  Created by Oleh Dovhan on 07.11.2022.
//

import SwiftUI

struct UserModel: Codable {
    
    var avatarSystemName: String
    var name: String
    var registrationDate: Date
    
    // Spendings
    var currentMonthSpendings: [ExpenseModel]?
    var previousMonthesSpendings: [ExpenseModel]?
    var debts: [DebtModel]?
    
    //Budget
    var planBudget: Budget?
    var thisMonthBudget: Budget?
    var previousMonthesBudgets: [Budget]?
    var averageBudget: Int? {
        if previousMonthesBudgets?.count != 0 {
            var total = Int()
            for budget in previousMonthesBudgets! {
                total += budget.totalMonth
            }
            return total / previousMonthesBudgets!.count
        } else if planBudget != nil { return planBudget!.totalMonth } else { return nil }
    }
    
    // GoalsBudget
    var planGoalsBudget: Budget?
    var thisMonthGoalsBudget: Budget?
    var previousMonthesGoalsBudgets: [Budget]?
        
    var averageGoalsBudget: Int? {
        var total = Int()
        if previousMonthesGoalsBudgets?.count != 0 {
            for budget in previousMonthesBudgets! {
                total += budget.totalMonth
            }
            return total / previousMonthesGoalsBudgets!.count
        } else if planGoalsBudget != nil {
            return planGoalsBudget!.totalMonth
        } else { return nil }
    }
    
    // make it computed from
    var freeDays: Double? {
        // 30.44 average days count in month in regular and leap years
        if averageBudget != nil,
           averageGoalsBudget != nil {
            let oneDayCost = Double(averageBudget! + averageGoalsBudget!) / 30.44 // add averageGoalsMoney
            return saver / oneDayCost
        } else { return nil }
    }
    // savings
    var saver: Double = 0.0
    // write logic depends on this func will execute every month on the first day
    func renewThisMonthBudgetAndAverage() {}
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
    var cashSource: CashSource
    var spentCategory: ExpenseCategory
}

struct DebtModel: Codable {
    var startDate: Date
    var whose: DebtEnum
    var expirationDate: Date
    var totalAmount: Int
    var returnedAmount: Int
}

// описати PercentageDividerCounterToGoalInMonthes
enum DebtEnum: Codable  {
    case gave, took
}
