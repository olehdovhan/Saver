//
//  CustomAlert.swift
//  Saver
//
//  Created by Пришляк Дмитро on 30.08.2022.
//

import SwiftUI

struct CustomAlert: View {
    @Binding var isAlertShow: Bool
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Text("Documents were copied")
                .foregroundColor(.white)
            Image(systemName: "doc.on.doc.fill")
                .resizable()
                .frame(width: 125, height: 125, alignment: .center)
                .foregroundColor(.green)
            Button("Cancel") {
                withAnimation(Animation.spring()) {
                    isAlertShow.toggle()
                }
            }
            .foregroundColor(.myBlue)

        }
        .padding(35)
        .background(
        RoundedRectangle(cornerRadius: 20)
            .fill(.yellow)
        )
        .padding(.top, 100)
        .shadow(radius: 15)
    }
}
