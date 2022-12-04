//
//  Calendar.swift
//  Saver
//
//  Created by Пришляк Дмитро on 20.08.2022.
//

import SwiftUI

struct Calendar: View {
    
    @State var currentDate: Date = Date()
    
    var body: some View {
        ZStack{
            Color.red.ignoresSafeArea(edges: .top)
            ScrollView(.vertical, showsIndicators: true) {
                VStack(spacing: 20) {
                    CustomDatePicker(currentDate: $currentDate)
                }
            }
        }
    }
}

struct Calendar_Previews: PreviewProvider {
    static var previews: some View {
        Calendar()
    }
}
