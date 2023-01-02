//
//  ContentView.swift
//  Saver
//
//  Created by O l e h on 20.08.2022.
//

import SwiftUI
import CoreData

struct TabBarView: View {

    @State var selectedTab = 3

    var body: some View {
        CustomTabView(selection: $selectedTab) {
            
            MainScreen()
                .myTabItem {
                    TabItem(text: "", icon: "tabIcon0")
                }
                .opacity(selectedTab == 0 ? 1 : 0)
       
            ExpensesCircularDiagram(selectedTab: $selectedTab)
                .myTabItem {
                    TabItem(text: "", icon: "tabIcon1")
                }
                .opacity(selectedTab == 1 ? 1 : 0)

            CalendarView()
                .myTabItem {
                    TabItem(text: "", icon: "tabIcon2")
                }
                .opacity(selectedTab == 2 ? 1 : 0)

            SavingsGoalsDebtsView()
                .myTabItem {
                    TabItem(text: "", icon: "tabIcon3")
                }
                .opacity(selectedTab == 3 ? 1 : 0)

            Menu()
                .myTabItem {
                    TabItem(text: "", icon: "tabIcon4")
                }
                .opacity(selectedTab == 4 ? 1 : 0)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}





