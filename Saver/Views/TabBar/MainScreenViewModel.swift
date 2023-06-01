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
    
    @Published var progress = false 
    
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
    
    func getUser() -> () {
        FirebaseUserManager.shared.observeUser { [weak self] in
            if let user = FirebaseUserManager.shared.userModel {
                self?.user = user
                
                self?.getUserName2()
                self?.getUrlImage2()
                
                self?.getCurrentMonthSpendings2()
                self?.getCurrentMonthIncoms2()
                
                self?.getCashSources2()
                self?.getPurchaseCategories2()
                
            } else {
                self?.errorMessage = "User is absent"
                self?.showErrorMessage = true
            }
        }
    }
    
    func setUser() -> () {
        guard let user = user else { return }
        FirebaseUserManager.shared.userModel = user
    }
    
    func getUserName2() -> (){
        guard let user = user else { return }
        userName = user.name
    }
    
    func getUrlImage2() -> (){
        guard let url = URL(string: user!.avatarUrlString) else {
            errorMessage = "error urlString"
            showErrorMessage = true
            return
        }
        urlImage = url
    }
    
    func getCurrentMonthSpendings2() -> () {
        guard let currentMonthSpendings = user!.currentMonthSpendings else { return }
        self.currentMonthSpendings =  currentMonthSpendings
        self.getTotalExpense2()
    }
    
    func getCurrentMonthIncoms2() -> () {
        guard let currentMonthIncoms = user!.currentMonthIncoms else { return }
        self.currentMonthIncoms =  currentMonthIncoms
        
    }
    
    func getTotalExpense2() -> () {
        totalExpense = currentMonthSpendings.reduce(0, {$0 + $1.amount})
    }
    
    func getBalance() -> () {
        cashBalance = cashSources.reduce(0, {$0 + $1.amount})
    }
    
    func getCashSources2() -> () {
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
    
    func getPurchaseCategories2() -> () {
        guard let user = user else {
            errorMessage = "error categories"
            showErrorMessage = true
            return
        }
        purchaseCategories = user.purchaseCategories
        progress = false
    }
}

