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
    @Published var totalExpense: Double = .zero
    @Published var totalIncome: Double = .zero
    
    @Published var progress = true
    
    @Published var cashSource: String = ""
    @Published var cashSources: [CashSource] = []
    @Published var purchaseCategories: [PurchaseCategory] = []
    
    @Published var urlImage: URL?
    
    init(){
        FirebaseUserManager.shared.observeUser {
            self.getUrlImage()
            self.getUserName()
            self.getCurrentMonthSpendings()
            self.getTotalExpense()
            self.getTotalIncome()
            self.getCashSources()
            self.getPurchaseCategories()
            
        
        }
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
    
    func getUserName() -> Void{
        userName = FirebaseUserManager.shared.userModel?.name ?? "First Name"
    }
    
    func getCurrentMonthSpendings() -> Void{
        currentMonthSpendings =  FirebaseUserManager.shared.userModel?.currentMonthSpendings ?? []
    }
    
    func getTotalExpense() -> Void{
        totalExpense = currentMonthSpendings.reduce(0, {$0 + $1.amount})
    }
    
    func getTotalIncome() -> Void{
        if let currentMonthIncoms = FirebaseUserManager.shared.userModel?.currentMonthIncoms{
//                print(currentMonthIncoms)
            totalIncome = currentMonthIncoms.reduce(0, {$0 + $1.amount})
        }
    }
    
    func getCashSources() -> Void{
        if let sources = FirebaseUserManager.shared.userModel?.cashSources {

                cashSources = sources
                if sources.count != 0 {
                    cashSource = sources[0].name
                    progress = false
                }
        } else {
            errorMessage = "error sources"
            showErrorMessage = true
        }
    }
    
    func getPurchaseCategories() -> Void{
        if let categories = FirebaseUserManager.shared.userModel?.purchaseCategories {
            purchaseCategories = categories
            progress = false
        } else {
            errorMessage = "error categories"
            showErrorMessage = true
        }
    }
    
    func getUrlImage() -> Void{
        if let urlString = FirebaseUserManager.shared.userModel?.avatarUrlString,
           let url = URL(string: urlString) {
            urlImage = url
        } else {
            errorMessage = "error urlString"
            showErrorMessage = true
        }
    }
    
    
}
