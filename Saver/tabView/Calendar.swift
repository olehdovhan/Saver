//
//  Calendar.swift
//  Saver
//
//  Created by Пришляк Дмитро on 20.08.2022.
//

import SwiftUI

struct Calendar: View {
    var body: some View {
        ZStack{
            Color.red.ignoresSafeArea(edges: .top)
        Text("Calendar")
        }
    }
}

struct Calendar_Previews: PreviewProvider {
    static var previews: some View {
        Calendar()
    }
}
