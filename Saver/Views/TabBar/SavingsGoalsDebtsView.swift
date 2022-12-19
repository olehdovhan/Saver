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
//    @State var selectedGoal: DebtModel?
    @FocusState var editing: Bool
    
    @State var showAlert = false
    @State var startAnim = false
    
    var plus: String{
        var symbol = ""
        if let saver = user?.saver {
            symbol = saver >= 0 ? "+" : "-"
        }
        return symbol
    }
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
    
    var squareSide = UIScreen.main.bounds.width/2.5
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea(edges: .top)
            ScrollView {
                VStack(spacing: 0) {
                    //Block Saving
                    HStack{
                        Text("Saving")
                            .textCase(.uppercase)
                            .foregroundColor(.myGreen)
                            .font(.custom("Lato-ExtraBold", size: 22))
                        Spacer()
                    }
                    .padding(.horizontal, 26)
                    .padding(.bottom, 28)
                    
                    HStack(spacing: 0) {
                        Button {
                            //TODO: SaverDetailView
                        } label: {
                            VStack(spacing: 9){
                                Text("\(plus)\(String(format: "%.3f", user?.saver ?? 0.0))$")
                                    .font(.custom("Lato-Medium", size: 25))
                                    .foregroundColor(.black)
                            }
                            .frame(width: squareSide,
                                   height: squareSide)
                            .background(
                                RoundedRectangle(cornerRadius: 15).fill(.white)
                                    .myShadow(radiusShadow: 5)
                            )
                        }
                        
                        Spacer()
                        
                        Button {
                            
                        } label: {
                            VStack(spacing: 0){
                                LinearGradient(gradient: Gradient(colors: [.myGradeLilac, .myGradeBlue]),
                                               startPoint: .topLeading,
                                               endPoint: .bottomTrailing)
                                .mask(
                                    Text("\(Int(user?.freeDays ?? 0.0))")
                                        .font(.custom("Lato-Medium", size: 65))
                                )
                                .frame(maxHeight: 61)
                                .padding(.bottom, 15)
                                
                                Text("Days of\nfreedom")
                                    .lineLimit(2)
                                    .foregroundColor(.myGrayDark)
                                    .font(.custom("Lato-Regular", size: 20))
                            }
                            .frame(width: squareSide,
                                   height: squareSide)
                            .background(
                                RoundedRectangle(cornerRadius: 15).fill(.white)
                                    .myShadow(radiusShadow: 5)
                            )
                        }
                    }
                    .padding(.horizontal, 26)
                    .padding(.bottom, 34)
                    
                    //Block Goals
                    HStack{
                        Text("Goals")
                            .textCase(.uppercase)
                            .foregroundColor(.myGreen)
                            .font(.custom("Lato-ExtraBold", size: 22))
                        Spacer()
                    }
                    .padding(.horizontal, 26)
                    .padding(.bottom, 28)
                    
                    VStack(spacing: 20) {
                        ForEach(goals, id: \.self) { goal in
                            
                            Button { detailGoalsViewShow = true
                                selectedGoal = goal
                            }
                            label : {
                                VStack(spacing: 0){
                                    HStack(alignment: .bottom){
                                        Text("\(goal.name)")
                                            .textCase(.uppercase)
                                            .foregroundColor(.black)
                                            .font(.custom("Lato-Medium", size: 15))
                                            .lineLimit(1)
                                        Spacer()
                                    }
                                    .padding(.leading, 17)
                                    .padding(.trailing, 18)
                                    
                                    
                                    
                                    HStack(alignment: .bottom){
                                        Spacer()
                                        Text("collected \(goal.collectedPrice)$ out of \(goal.totalPrice)$")
                                            .foregroundColor(.myGrayDark)
                                            .font(.custom("Lato-Regular", size: 12))
                                            .lineLimit(1)
                                    }
                                    .padding(.leading, 17)
                                    .padding(.trailing, 18)
                                    .padding(.bottom, 12)
                                    
                                    let percentGoal = CGFloat(goal.collectedPrice) / CGFloat(goal.totalPrice)
                                    
                                    Capsule().fill(LinearGradient(gradient: Gradient(colors: [.myGradeBlue, .myGradeGreen]),
                                                                  startPoint: .leading,
                                                                  endPoint: .trailing))
                                    .scaleEffect(x: startAnim ? 0 : percentGoal,  anchor: .leading)
                                    .background(Capsule().foregroundColor(.myGrayCapsule))
                                    .frame(height: 5)
                                    .padding(.leading, 17)
                                    .padding(.trailing, 18)
                                    
                                }
                                .padding(.vertical, 20)
                                .padding(.horizontal, 20)
                                .background(
                                    RoundedRectangle(cornerRadius: 15).fill(.white)
                                        .myShadow(radiusShadow: 5)
                                )
                            }
                        }
                        
                    }
                    .padding(.horizontal, 26)
                    .padding(.bottom, 25)
                    
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
                    .padding(.bottom, 34)
                    
                    //Block Debts
                    HStack{
                        Text("Debts")
                            .textCase(.uppercase)
                            .foregroundColor(.myGreen)
                            .font(.custom("Lato-ExtraBold", size: 22))
                        Spacer()
                    }
                    .padding(.horizontal, 26)
                    .padding(.bottom, 28)
                    
                    VStack(spacing: 20) {
                        ForEach(debts, id: \.self) { debt in
                            
                            Button{
                                
                                /*
                                detailGoalsViewShow = true
                                selectedGoal = goal
                                 */
                                
                            } label: {
                                
                                VStack(spacing: 0){
                                    HStack(alignment: .bottom){
                                        
                                        if debt.whose == .gave {
                                            Text("Gave \(dateFormatter.string(from: debt.startDate))")
                                                .textCase(.uppercase)
                                                .foregroundColor(.orange)
                                                .font(.custom("Lato-Medium", size: 15))
                                                .lineLimit(1)
                                        }
                                        else if debt.whose == .took{
                                            Text("Took \(dateFormatter.string(from: debt.startDate)) ")
                                                .textCase(.uppercase)
                                                .foregroundColor(.red)
                                                .font(.custom("Lato-Medium", size: 15))
                                                .lineLimit(1)
                                        }
                                        
                                        Spacer()
                                    }
                                    .padding(.leading, 17)
                                    .padding(.trailing, 18)
                                    
                                    
                                    HStack(){
                                        Spacer()
                                        Text("returned \(Int(debt.returnedAmount))$ of \(Int(debt.totalAmount))$")
                                            .foregroundColor(.myGrayDark)
                                            .font(.custom("Lato-Regular", size: 12))
                                            .lineLimit(1)
                                    }
                                    .padding(.leading, 17)
                                    .padding(.trailing, 18)
                                    .padding(.bottom, 12)
                                    
                                    HStack(alignment: .bottom){
                                        Spacer()
                                        
                                        if debt.whose == .gave {
                                            
                                            Text("Return \(Int(debt.monthlyDebtPayment))$ per month")
                                                .foregroundColor(.myGrayDark)
                                                .font(.custom("Lato-Regular", size: 12))
                                                .lineLimit(1)
                                        }
                                        else if debt.whose == .took {
                                            Text("Receive \(Int(debt.monthlyDebtPayment))$ per month")
                                                .foregroundColor(.myGrayDark)
                                                .font(.custom("Lato-Regular", size: 12))
                                                .lineLimit(1)
                                        }
                                    }
                                    .padding(.leading, 17)
                                    .padding(.trailing, 18)
                                    .padding(.bottom, 12)
                                    
                                    let percentDebt = CGFloat(debt.returnedAmount) / CGFloat(debt.totalAmount)
                                    
                                    Capsule().fill(LinearGradient(gradient: Gradient(colors: [.myGradeBlue, .myGradeGreen]),
                                                                  startPoint: .leading,
                                                                  endPoint: .trailing))
                                    .scaleEffect(x: startAnim ? percentDebt : 0,  anchor: .leading)
                                    .background(Capsule().foregroundColor(.myGrayCapsule))
                                    .frame(height: 5)
                                    .padding(.leading, 17)
                                    .padding(.trailing, 18)
                                    
                                    
                                    
                                }
                                .padding(.vertical, 20)
                                .padding(.horizontal, 20)
                                .background(
                                    RoundedRectangle(cornerRadius: 15).fill( debt.whose == .gave ? .white : .white )
                                        .myShadow(radiusShadow: 5)
                                )

                            }
                            
                        }
                        
                    }
                    .padding(.horizontal, 26)
                    .padding(.bottom, 25)
                    
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
                .blur(radius: detailGoalsViewShow || addDebtViewShow || addGoalsViewShow ? 5 : 0)
            }
            .padding(.bottom, 70)
            
            if addGoalsViewShow {
                AddGoalsView(closeSelf: $addGoalsViewShow,
                             goals: $goals,
                             editing: $editing)
            }
            
            if addDebtViewShow{
                AddDebtView(closeSelf: $addDebtViewShow, debts: $debts, editing: $editing)
            }
            
            if detailGoalsViewShow {
                if let goal = selectedGoal {
                    DetailGoalView(closeSelf: $detailGoalsViewShow,
                                   goals: $goals,
                                   goal: goal)
                    .onDisappear(){
                        detailGoalsViewShow = false
                    }
                }
            }
        }
        .onAppear {
            if let currentUser = UserDefaultsManager.shared.userModel {
                user = currentUser
                goals = currentUser.goals
                debts = currentUser.debts
                withAnimation(Animation.easeInOut(duration: 3)) {
                    startAnim = true
                }
            }
            
        }
    }
}


struct SavingsGoalsDebtsView_Previews: PreviewProvider {
    static var previews: some View {
        SavingsGoalsDebtsView()
    }
}
