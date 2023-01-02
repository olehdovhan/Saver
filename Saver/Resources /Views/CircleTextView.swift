//
//  CircleTextView.swift
//  Saver
//
//  Created by Oleh Dovhan on 13.12.2022.
//

import SwiftUI

struct CircleTextView: View {

    let text: String
    @State private var radius: CGFloat = .zero

    var body: some View {
        
        return ZStack {
            
            Text(text)
                .fontWeight(.bold)
                .padding()
                .background(GeometryReader { proxy in Color.clear.onAppear() { radius = max(proxy.size.width, proxy.size.height) } }.hidden())
            
            if (!radius.isZero) {
                
                Circle().strokeBorder().frame(width: radius, height: radius)
                
            }
            
        }
     
    }
}
