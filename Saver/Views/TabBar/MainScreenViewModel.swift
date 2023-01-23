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
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error.localizedDescription)
        }
    }
}
