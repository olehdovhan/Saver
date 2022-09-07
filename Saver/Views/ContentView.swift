//
//  ContentView.swift
//  Saver
//
//  Created by O l e h on 20.08.2022.
//

import SwiftUI
import CoreData

struct ContentView: View {

    
    @State var selectionTab = 1

    var body: some View {
       // ExpenseView()
        CustomTabView(selection: $selectionTab) {

            MainScreen()
                .myTabItem {
                    TabItem(text: "", icon: "tabIcon0")
                }
                .opacity(selectionTab == 0 ? 1 : 0)
       
            ExpensesCircularDiagram()


                .myTabItem {
                    TabItem(text: "", icon: "tabIcon1")
                }
                .opacity(selectionTab == 1 ? 1 : 0)

            Calendar()
                .myTabItem {
                    TabItem(text: "", icon: "tabIcon2")
                }
                .opacity(selectionTab == 2 ? 1 : 0)

            SavingsAndGoals()
                .myTabItem {
                    TabItem(text: "", icon: "tabIcon3")
                }
                .opacity(selectionTab == 3 ? 1 : 0)

            Menu()
                .myTabItem {
                    TabItem(text: "", icon: "tabIcon4")
                }
                .opacity(selectionTab == 4 ? 1 : 0)




        }
  
}
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}





