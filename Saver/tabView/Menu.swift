//
//  Menu.swift
//  Saver
//
//  Created by Пришляк Дмитро on 20.08.2022.
//

import SwiftUI

struct Menu: View {
    var body: some View {
        ZStack{
            Color.orange.ignoresSafeArea(edges: .top)
        Text("Menu")
        }
    }
}

struct Menu_Previews: PreviewProvider {
    static var previews: some View {
        Menu()
    }
}
