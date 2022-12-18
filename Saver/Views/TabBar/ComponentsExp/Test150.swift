//
//  Test.swift
//  Saver
//
//  Created by Пришляк Дмитро on 07.09.2022.
//

import Foundation
import SwiftUI

struct ContentView150: View {
    @State private var relativePosition: CGFloat = 0.5
    
    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                Text("Example for a long view without individual elements that you could use id on. Example for a long view without individual elements that you could use id on. Example for a long view without individual elements that you could use id on. Example for a long view without individual elements that you could use id on. Example for a long view without individual elements that you could use id on. Example for a long view without individual elements that you could use id on. Example for a long view without individual elements that you could use id on. Example for a long view without individual elements that you could use id on. Example for a long view without individual elements that you could use id on. Example for a long view without individual elements that you could use id on.")
            }
            .introspectScrollView { scrollView in
                let width = scrollView.contentSize.width - scrollView.frame.width
                scrollView.contentOffset.x = relativePosition * width
            }
            
            let _ = relativePosition  // Needed to update view
            
            Slider(value: $relativePosition, in: 0 ... 1)
        }
    }
}
