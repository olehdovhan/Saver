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
    @Published var showErrorMessage = false
    @Published var errorMessage = ""
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error.localizedDescription)
            self.errorMessage = error.localizedDescription
            self.showErrorMessage = true
        }
    }
}
