//
//  View+Extension.swift
//  Saver
//
//  Created by Oleh Dovhan on 14.01.2023.
//

import SwiftUI

// MARK: - Navigate
extension View {
    func navigate<NewView: View>(
        to view: NewView,
        when binding: Binding<Bool>
    ) -> some View {
        NavigationView {
            ZStack {
                self
                    .navigationBarTitle("")
                    .navigationBarHidden(true)
                
                NavigationLink(
                    destination: view
                        .navigationBarTitle("")
                        .navigationBarHidden(true),
                    isActive: binding
                ) {
                    EmptyView()
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}
