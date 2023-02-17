//
//  View+Extension.swift
//  Saver
//
//  Created by Oleh Dovhan on 14.01.2023.
//

import SwiftUI

extension View {
    /// Navigate to a new view.
    /// - Parameters:
    ///   - view: View to navigate to.
    ///   - binding: Only navigates when this condition is `true`.
    func navigate<NewView: View>(to view: NewView, when binding: Binding<Bool>) -> some View {
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

extension View {
    func overlay<T: View>( overlayView: T, show: Binding<Bool>, ignoreSaveArea: Bool = true) -> some View {
        self.modifier(Overlay.init(show: show, overlayView: overlayView, ignoreSaveArea: ignoreSaveArea))
    }
}

struct Overlay<T: View>: ViewModifier {

    @Binding var show: Bool
    let overlayView: T
    let ignoreSaveArea: Bool

    func body(content: Content) -> some View {
        ZStack {
            content
            if show {
                if ignoreSaveArea {
                    overlayView
//                        .animation(.spring())
                        .ignoresSafeArea(.all)
                } else {
                    overlayView
                }
            }
        }
    }
}


