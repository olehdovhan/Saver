//
//  MainScreenViewModel.swift
//  Saver
//
//  Created by Oleh Dovhan on 23.01.2023.
//
import Firebase
import SwiftUI
import Foundation


class MainScreenViewModel: ObservableObject {
    @Published var user: UserModel?
    
    @Published var showErrorMessage = false
    @Published var errorMessage = ""
    @Published var userName = ""
    @Published var currentMonthSpendings = [ExpenseModel]()
    @Published var currentMonthIncoms = [IncomeModel]()
    @Published var totalExpense: Double = .zero
    @Published var cashBalance: Double = .zero
    
    @Published var progress = true
    
    @Published var cashSource: String = ""
    @Published var cashSources: [CashSource] = []
    @Published var purchaseCategories: [PurchaseCategory] = []
    
    @Published var urlImage: URL?
    
    init(){
        self.getUser()
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error.localizedDescription)
            self.errorMessage = error.localizedDescription
            self.showErrorMessage = true
        }
    }
    
    func getUser() -> Void{
        FirebaseUserManager.shared.observeUser {
            
            if let user = FirebaseUserManager.shared.userModel {
                self.user = user
                
                self.getUserName2()
                self.getUrlImage2()
                
                self.getCurrentMonthSpendings2()
                self.getCurrentMonthIncoms2()
                
                self.getCashSources2()
                self.getPurchaseCategories2()
                
            }
        }
    }
    
    func setUser() -> Void{
        guard let user = user else { return }
        FirebaseUserManager.shared.userModel = user
    }
    
    func getUserName2() -> Void{
        guard let user = user else { return }
        userName = user.name
    }
    
    func getUrlImage2() -> Void{
        guard let url = URL(string: user!.avatarUrlString) else {
            errorMessage = "error urlString"
            showErrorMessage = true
            return
        }
        urlImage = url
    }
    
    
    func getCurrentMonthSpendings2() -> Void{
        guard let currentMonthSpendings = user!.currentMonthSpendings else { return }
        self.currentMonthSpendings =  currentMonthSpendings
        self.getTotalExpense2()
    }
    
    func getCurrentMonthIncoms2() -> Void{
        guard let currentMonthIncoms = user!.currentMonthIncoms else { return }
        self.currentMonthIncoms =  currentMonthIncoms
        
    }
    
    func getTotalExpense2() -> Void{
        totalExpense = currentMonthSpendings.reduce(0, {$0 + $1.amount})
    }
    
    func getBalance() -> Void{
        cashBalance = cashSources.reduce(0, {$0 + $1.amount})
    }
    
    func getCashSources2() -> Void{
        guard let user = user else {
            errorMessage = "error sources"
            showErrorMessage = true
            return
        }
        cashSources = user.cashSources
        self.getBalance()
        
        if cashSources.count != 0 {
            cashSource = cashSources[0].name
            progress = false
        }

    }
    
    func getPurchaseCategories2() -> Void{
        guard let user = user else {
            errorMessage = "error categories"
            showErrorMessage = true
            return
        }
        purchaseCategories = user.purchaseCategories
        progress = false
    }
    
//    func getUrlImage() -> Void{
//        if let urlString = FirebaseUserManager.shared.userModel?.avatarUrlString,
//           let url = URL(string: urlString) {
//            urlImage = url
//        } else {
//            errorMessage = "error urlString"
//            showErrorMessage = true
//        }
//    }
    
    //    func getUserName() -> Void{
    //        userName = FirebaseUserManager.shared.userModel?.name ?? "First Name"
    //    }
    
    //    func getCurrentMonthSpendings() -> Void{
    //        currentMonthSpendings =  FirebaseUserManager.shared.userModel?.currentMonthSpendings ?? []
    //    }
    
//    func getTotalExpense() -> Void{
//        totalExpense = currentMonthSpendings.reduce(0, {$0 + $1.amount})
//    }
    
//    func getTotalIncome() -> Void{
//        if let currentMonthIncoms = FirebaseUserManager.shared.userModel?.currentMonthIncoms{
//            totalIncome = currentMonthIncoms.reduce(0, {$0 + $1.amount})
//        }
//    }
    
//    func getCashSources() -> Void{
//        if let sources = FirebaseUserManager.shared.userModel?.cashSources {
//
//                cashSources = sources
//                if sources.count != 0 {
//                    cashSource = sources[0].name
//                    progress = false
//                }
//        } else {
//            errorMessage = "error sources"
//            showErrorMessage = true
//        }
//    }
    
//    func getPurchaseCategories() -> Void{
//        if let categories = FirebaseUserManager.shared.userModel?.purchaseCategories {
//            purchaseCategories = categories
//            progress = false
//        } else {
//            errorMessage = "error categories"
//            showErrorMessage = true
//        }
//    }
}

//struct Notifications {
//      static let updateUserNotification: NSNotification.Name = NSNotification.Name("updateUserNotification")
//
//    }
