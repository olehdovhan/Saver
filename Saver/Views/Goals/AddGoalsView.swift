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
    @State var goalName = ""
    @State var totalPrice = ""
    @State var monthPayment = ""
    @State var editing: FocusState<Bool>.Binding
    
    var fieldsEmpty: Bool {
      if monthPayment != "",
               goalName != "",
            totalPrice != "" {
          return false
      } else { return true }
    }
    
    var body: some View {
        ZStack {
            Color(hex: 0xC4C4C4, alpha: 0.7)
                .ignoresSafeArea()
            
            Color.white
                .frame(width: 300,
                       height: 360,
                       alignment: .top)
                .cornerRadius(25)
                .shadow(radius: 25)
            
            VStack {
                HStack {
                    Text("Add new goal")
                        .frame(alignment: .leading)
                        .padding(.leading, 34)
                    Spacer()
                    Button {
                        closeSelf = false
                    }
                     label: {
                        Image("btnClose")
                    }
                     .frame( alignment: .trailing)
                     .padding(.trailing, 16)
                }
                .frame(width: 300, alignment: .top)
                .padding(.top, 24)
                
                HStack {
                    Text("Name")
                    Spacer()
                    Spacer()
                    Spacer()
    
                    TextField("enter goal name",text: $goalName)
                        .frame(height: 50, alignment: .trailing)
                        .overlay( RoundedRectangle(cornerRadius: 20, style: .continuous)
                                                    .stroke( .gray, lineWidth: 3)
                                                    .padding(.leading, -10)
                                                    .padding(.trailing, -10) )
                }
                .padding(.leading,  30)
                .padding(.trailing, 35)
                
                HStack {
                    Text("Total Price")
                    Spacer()
                    Spacer()
                    Spacer()
                    TextField("enter total price",text: $totalPrice)
                        .frame(height: 50, alignment: .trailing)
                        .overlay( RoundedRectangle(cornerRadius: 20, style: .continuous)
                                                    .stroke( .gray, lineWidth: 3)
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
                .padding(.leading,  30)
                .padding(.trailing, 35)
            
                
                HStack {
                    Text("Going to invest per month")
                    Spacer()
                    TextField("invest in goal per month",text: $monthPayment)
                        .frame(height: 50, alignment: .trailing)
                        .overlay( RoundedRectangle(cornerRadius: 20, style: .continuous)
                                                    .stroke( .gray, lineWidth: 3)
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
                
                Spacer()
                ImageButton(image: "btnDoneInactive",
                            pressedImage: "btnDone",
                            disabled: fieldsEmpty) {
                  let newGoal = Goal(name: goalName,
                                     totalPrice: Int(totalPrice) ?? 0,
                                     collectedPrice: 0,
                                     collectingSumPerMonth: Int(monthPayment) ?? 0)
                    if var copyUser = UserDefaultsManager.shared.userModel {
                        copyUser.goals.append(newGoal)
                        UserDefaultsManager.shared.userModel? = copyUser
                    }
                    closeSelf = false
                }
                Spacer()
            }
            .frame(width: 300,
                   height: 360)
        }
        .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
    }
}

