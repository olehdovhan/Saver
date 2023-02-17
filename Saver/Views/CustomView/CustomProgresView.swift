//
//  CustomProgresView.swift
//  Saver
//
//  Created by Oleh on 12.02.2023.
//

import SwiftUI

struct CustomProgressView: View {
    var body: some View {
        ZStack {
            Rectangle().fill(.white.opacity(1)).frame(maxWidth: .infinity, maxHeight: .infinity)
            
            ProgressView().progressViewStyle(CircularProgressViewStyle(tint: .green))
                .scaleEffect(2)
        }.ignoresSafeArea()
    }
}
