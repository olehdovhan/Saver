//
//  SavingsAndGoals.swift
//  Saver
//
//  Created by Пришляк Дмитро on 20.08.2022.
//

import SwiftUI

struct SavingsGoalsDebtsView: View {
    
    @State var addGoalsViewShow = false
    @State var addDebtViewShow = false
    
    @State var detailGoalsViewShow = false
    
    @State var user: UserModel?
    @State var goals: [Goal] = []
    @State var selectedGoal: Goal?
    @State var debts: [DebtModel] = []
    @FocusState var editing: Bool
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea(edges: .top)
            ScrollView {
                VStack {
                    Text("Saving")
                    
                    HStack {
                        ZStack {
                            Color.gray.frame(width: 150, height: 150)
                            Button {
                                // TODO: SaverDetailView
                            } label: {
                                VStack(alignment: .trailing) {
                                    Text("\(user?.saver ?? 0.0)$")
                                }
                            }
                        }
                        ZStack {
                            Color.gray.frame(width: 150, height: 150)
                            VStack(alignment: .center) {
                                Text("\(user?.freeDays ?? 0.0)")
                                Text("Days of freedom")
                            }
                        }
                    }
                    
                    Text("Goals")
                    
                    VStack {
                        ForEach(goals, id: \.self) { goal in
                            Button { detailGoalsViewShow = true
                                selectedGoal = goal
                            }
                            label : {
                            ZStack {
                                Color.green.frame(width: 300, height: 100)
                                HStack {
                                    Text("Goal \(goal.name)")
                                    Text("collected \(goal.collectedPrice)$ out of \(goal.totalPrice)$")
                                }
                            }
                        }
                        }
                        Button {
                            addGoalsViewShow = true
                            // TODO: Forecast: If it will be 0.25, 0.5, 0.7, 1.5, 2.5, 4.0 coef of monthlyPayment - your totalMonthes for achieve will be
                        } label: {
                            VStack {
                                Image("iconPlus")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .myShadow(radiusShadow: 5)
                            }
                        }
                    }
                    
                    Text("Debts")
                    
                    VStack {
                        ForEach(debts, id: \.self) { debt in
                            ZStack {
                                switch debt.whose {
                                case .gave:  Color.yellow.frame(width: 300, height: 100)
                                case .took:  Color.red .frame(width: 300, height: 100)
                                }
                                
                                VStack {
                                    switch debt.whose {
                                    case .gave:  Text("Gave \(debt.startDate)")
                                    case .took:  Text("Took \(debt.startDate)")
                                    }
                                    Text("returned \(debt.returnedAmount)$ of \(debt.totalAmount)$")
                                    switch debt.whose {
                                    case .gave:  Text("Return \(debt.monthlyDebtPayment)$ per month")
                                    case .took:  Text("Receive \(debt.monthlyDebtPayment)$ per month")
                                    }
                                }
                            }
                        }
                        Button {
                            addDebtViewShow = true
                        } label: {
                            VStack {
                                Image("iconPlus")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .myShadow(radiusShadow: 5)
                            }
                        }
                    }
                }
            }
            .padding(.bottom, 100)
            if addGoalsViewShow {
                AddGoalsView(closeSelf: $addGoalsViewShow,
                             goals: $goals,
                             editing: $editing)
            }
            if detailGoalsViewShow {
                if let goal = selectedGoal {
                    DetailGoalView(closeSelf: $detailGoalsViewShow,
                                   goals: $goals,
                                   goal: goal)
                }
            }
        }
        .onAppear() {
            if let currentUser = UserDefaultsManager.shared.userModel {
                user = currentUser
                goals = currentUser.goals
                debts = currentUser.debts
            }
        }
    }
}


