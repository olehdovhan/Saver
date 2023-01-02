//
//  CalendarView.swift
//  Saver
//
//  Created by Pryshliak Dmytro on 20.12.2022.
//

import SwiftUI

struct CalendarView: View {
    
    var body: some View {
        ZStack{
//            Color.red.ignoresSafeArea(edges: .top)
            ScrollView(.vertical, showsIndicators: true) {
                VStack(spacing: 20) {
                    CustomDatePicker3()
                }
            }
        }
    }
}

struct Calendar_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
 
