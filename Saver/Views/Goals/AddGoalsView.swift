//
//  AddGoalsView.swift
//  Saver
//
//  Created by Oleh Dovhan on 18.12.2022.
//

import SwiftUI
import Combine

struct AddGoalsView: View {
    
    @Binding var closeSelf: Bool
    @Binding var goals: [Goal]
    @State private var goalName = ""
    @State private var totalPrice = ""
    @State var monthPayment = ""
    @State var editing: FocusState<Bool>.Binding
    
    private var fieldsEmpty: Bool {
      if monthPayment != "",
               goalName != "",
            totalPrice != "" {
          return false
      } else { return true }
    }
    
    var body: some View {
        ZStack {
            Color.myGrayLight.opacity(0.3)
                .ignoresSafeArea()
            
            Color.white
                .frame(width: Screen.width/1.2,
                       height: Screen.height/2)
                .cornerRadius(25)
                .shadow(radius: 25)
            
            VStack {
                HStack {
                    Text("Add new goal")
                        .textCase(.uppercase)
                        .foregroundColor(.myGreen)
                        .font(FontType.latoExtraBold.font(size: 22))
                    
                    Spacer()
                    Button {
                        closeSelf = false
                    }
                     label: {
                        Image("btnClose")
                    }
                    
                }
                .padding(.horizontal, 20)
                .padding(.top, 24)
                .padding(.bottom, 15)
                
                HStack {
                    Text("Name")
                        .foregroundColor(.myGrayDark)
                        .font(FontType.latoMedium.font(size: 16))
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
    
                    TextField("", text: $goalName)
                        .placeholder(when: goalName.isEmpty) {
                            Text("enter goal name").foregroundColor(.gray)
                    }
                        .foregroundColor(.myGrayDark)
                        .frame(width: Screen.width/2, height: 50)
                        .overlay( RoundedRectangle(cornerRadius: 20, style: .continuous)
                                                    .stroke( Color.myGreen, lineWidth: 1)
                                                    .padding(.leading, -10)
                                                    .padding(.trailing, -10) )
                    
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 15)
                
                HStack {
                    Text("Total Price")
                        .lineLimit(2)
                        .foregroundColor(.myGrayDark)
                        .font(FontType.latoMedium.font(size: 16))
                        .multilineTextAlignment(.leading)
                    Spacer()
                    TextField("enter total price",text: $totalPrice)
                        .placeholder(when: totalPrice.isEmpty) {
                            Text("enter total price").foregroundColor(.gray)
                    }
                        .foregroundColor(.myGrayDark)
                        .frame(width: Screen.width/2, height: 50)
                        .overlay( RoundedRectangle(cornerRadius: 20, style: .continuous)
                                                    .stroke( Color.myGreen, lineWidth: 1)
                                                    .padding(.leading, -10)
                                                    .padding(.trailing, -10)
                        )
                        .keyboardType(.numberPad)
                        .lineLimit(nil)
                        .onReceive(Just(totalPrice)) { newValue in
                            let filtered = newValue.filter { "0123456789 ".contains($0) }
                              if filtered != newValue {
                                  self.totalPrice = filtered
                              }
                        }
                }
                .padding(.horizontal, 20)
            
                
                HStack {
                    Text("Going to invest per month")
                        .lineLimit(3)
                        .foregroundColor(.myGrayDark)
                        .font(FontType.latoMedium.font(size: 16))
                        .multilineTextAlignment(.leading)
                    Spacer()
                    TextField("invest in goal per month",text: $monthPayment)
                        .placeholder(when: monthPayment.isEmpty) {
                            Text("invest in goal per month").foregroundColor(.gray)
                    }
                        .foregroundColor(.myGrayDark)
                        .frame(width: Screen.width/2, height: 50)
                        .overlay( RoundedRectangle(cornerRadius: 20, style: .continuous)
                                                    .stroke( Color.myGreen, lineWidth: 1)
                                                    .padding(.leading, -10)
                                                    .padding(.trailing, -10)
                        )
                        .keyboardType(.numberPad)
                        .lineLimit(nil)
                        .onReceive(Just(monthPayment)) { newValue in
                            let filtered = newValue.filter { "0123456789 ".contains($0) }
                              if filtered != newValue {
                                  self.monthPayment = filtered
                              }
                        }
                    
                }
                .padding(.horizontal, 20)
                
                Spacer()
                ImageButton(image: "btnDoneInactive",
                            pressedImage: "btnDone",
                            disabled: fieldsEmpty) {
                  let newGoal = Goal(name: goalName,
                                     totalPrice: Int(totalPrice) ?? 0,
                                     collectedPrice: 0,
                                     collectingSumPerMonth: Int(monthPayment) ?? 0)
//                    if var copyUser = UserDefaultsManager.shared.userModel {
//                        copyUser.goals.append(newGoal)
//                        UserDefaultsManager.shared.userModel? = copyUser
//                        
//                        if let newGoals = UserDefaultsManager.shared.userModel?.goals {
//                            goals = newGoals
//                        }
//                    }
                    closeSelf = false
                }
                Spacer()
            }
            .frame(width: Screen.width/1.2,
                   height: Screen.height/2)
        }
        .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
    }
}

