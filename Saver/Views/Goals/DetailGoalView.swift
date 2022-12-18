//
//  DetailGoalView.swift
//  Saver
//
//  Created by Oleh Dovhan on 18.12.2022.
//

import SwiftUI

struct DetailGoalView: View {
    
    @Binding var closeSelf: Bool
    @Binding var goals: [Goal]
    var goal: Goal
    var body: some View {
        
        ZStack {
            Color(hex: "C4C4C4").opacity(0.3)
                .ignoresSafeArea()
            
            Color.white
                .frame(width: 300,
                       height: 500,
                       alignment: .top)
                .cornerRadius(25)
                .shadow(radius: 25)
            
        VStack {
           
        
                Button {
                    closeSelf = false
                } label: {
                    Image("btnClose")
                        .resizable()
                        .frame(width: 45, height: 45)
                }
            
                Text(goal.name)
                  
            HStack {
                Text("You shold invest \(goal.collectingSumPerMonth)$ per month to achieve this goal in \(goal.totalMonthesPerGoal)")
                Text("Recently you make \(goal.monthesSaveForGoal) payments and you collected \(goal.collectedPrice)$.")
         
            }
  
            Button("delete", role: .destructive) { deleteGoal() }
        }
      }
   }
    
    func deleteGoal() {
        if var user = UserDefaultsManager.shared.userModel {
            var previousGoals = user.goals
            for (index,source) in previousGoals.enumerated() {
                if source.name == goal.name {
                    previousGoals.remove(at: index)
                }
            }
            user.goals = previousGoals
            UserDefaultsManager.shared.userModel = user
            if let gols = UserDefaultsManager.shared.userModel?.goals { goals = gols }
            closeSelf = false
        }
    }
}

