//
//  ContentView.swift
//  Saver
//
//  Created by O l e h on 20.08.2022.
//

import SwiftUI
import CoreData

struct MainView: View {

    
    @State var tabSelected = 0

    var body: some View {

        
        TabView(selection: $tabSelected.animation()) {
            
            Mainscrin2()
                .tabItem {
                    Image("tabIcon0")
                }
                .tag(0)
            
            IncomeAndExpenses()
                .tabItem {
                    Image("tabIcon1")
                }
                .tag(1)
            
            Calendar()
                .tabItem {
                    Image("tabIcon2")
                }
                .tag(2)
            
            SavingsAndGoals()
                .tabItem {
                    Image("tabIcon3")
                }
                .tag(3)
            
            Menu()
                .tabItem {
                    Image("tabIcon4")
                }
                .tag(4)
            
            
    }


}
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
