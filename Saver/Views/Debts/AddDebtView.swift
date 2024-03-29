//
//  AddDebtView.swift
//  Saver
//
//  Created by Oleh Dovhan on 18.12.2022.
//

import SwiftUI
import Combine

struct AddDebtView: View {
    @Binding var closeSelf: Bool
    @Binding var debts: [DebtModel]
    @State private var whose = DebtEnum.took
    @State private var debtName = ""
    @State private var startDate = Date.now
    @State private var totalAmount = ""
    @State private var totalMonthesForReturn = ""
    @State var editing: FocusState<Bool>.Binding
    
    var fieldsEmpty: Bool {
        if debtName != "",
           totalAmount != "",
           totalMonthesForReturn != ""{
            return false
        } else {
            return true
            
        }
    }
    
    var body: some View {
        ZStack {
            Color.myGrayLight.opacity(0.3)
                .ignoresSafeArea()
            
            Color.white
                .frame(width: Screen.width/1.2,
                       height: Screen.height/1.3)
                .cornerRadius(25)
                .shadow(radius: 25)
                .offset(y: -40)
            
            VStack(spacing: 20) {
                
                //---Header
                
                HStack {
                    Text("Add new debt")
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
                
                //---Whose
                
                HStack {
                    Text("Whose")
                        .lineLimit(1)
                        .foregroundColor(.myGrayDark)
                        .font(FontType.latoMedium.font(size: 16))
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    Picker("", selection: $whose) {
                        ForEach(DebtEnum.allCases, id: \.self) { value in
                            Text(value.rawValue)
                                .tag(value)
                        }
                    }
                    .frame(width: Screen.width/2.5, height: 30)
                    
                    
                }
                .padding(.horizontal, 20)
                
                //---Start date
                
                HStack {
                    Text("Start date")
                        .lineLimit(2)
                        .foregroundColor(.myGrayDark)
                        .font(FontType.latoMedium.font(size: 16))
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    Image("calendar")
                        .foregroundColor(.myGreen)
                    
                    DatePicker("", selection: $startDate,in: ...(Date.now + 86400) , displayedComponents: .date)
                        .labelsHidden()
                        .frame(width: Screen.width/2.5, height: 30)
                        .id(startDate)
                }
                .padding(.horizontal, 20)
                
                
                //---Name
                
                HStack {
                    Text("Name")
                        .foregroundColor(.myGrayDark)
                        .font(FontType.latoMedium.font(size: 16))
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    TextField("",text: $debtName)
                        .placeholder(when: debtName.isEmpty) {
                                Text("enter debt name").foregroundColor(.gray)
                        }
                        .foregroundColor(.black)
                        .frame(width: Screen.width/2, height: 50)
                        .overlay( RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .stroke( Color.myGreen, lineWidth: 1)
                            .padding(.leading, -10)
                            .padding(.trailing, -10) )
                    
                }
                .padding(.horizontal, 20)
                
                //---Amount
                
                HStack {
                    Text("Amount")
                        .lineLimit(2)
                        .foregroundColor(.myGrayDark)
                        .font(FontType.latoMedium.font(size: 16))
                        .multilineTextAlignment(.leading)
                    Spacer()
                    TextField("",text: $totalAmount)
                        .placeholder(when: totalAmount.isEmpty) {
                                Text("enter amount").foregroundColor(.gray)
                        }
                        .foregroundColor(.black)
                        .frame(width: Screen.width/2, height: 50)
                        .overlay( RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .stroke( Color.myGreen, lineWidth: 1)
                            .padding(.leading, -10)
                            .padding(.trailing, -10)
                        )
                        .keyboardType(.numberPad)
                        .lineLimit(nil)
                        .onReceive(Just(totalAmount)) { newValue in
                            let filtered = newValue.filter { "0123456789 ".contains($0) }
                            if filtered != newValue {
                                self.totalAmount = filtered
                            }
                        }
                }
                .padding(.horizontal, 20)
                
                //---Monthes for return
                
                HStack {
                    Text("Monthes for return")
                        .lineLimit(2)
                        .foregroundColor(.myGrayDark)
                        .font(FontType.latoMedium.font(size: 16))
                        .multilineTextAlignment(.leading)
                    Spacer()
                    TextField("",text: $totalMonthesForReturn)
                        .foregroundColor(.black)
                        .placeholder(when: totalMonthesForReturn.isEmpty) {
                            Text("enter total monthes for return").foregroundColor(.gray)
                    }
                        .frame(width: Screen.width/2, height: 50)
                        .overlay( RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .stroke( Color.myGreen, lineWidth: 1)
                            .padding(.leading, -10)
                            .padding(.trailing, -10)
                        )
                        .keyboardType(.numberPad)
                        .lineLimit(nil)
                        .onReceive(Just(totalMonthesForReturn)) { newValue in
                            let filtered = newValue.filter { "0123456789 ".contains($0) }
                            if filtered != newValue {
                                self.totalMonthesForReturn = filtered
                            }
                        }
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                ImageButton(image: "btnDoneInactive",
                            pressedImage: "btnDone",
                            disabled: fieldsEmpty) {
                    let newDebt = DebtModel(whose: whose,
                                            name: debtName,
                                            totalAmount: Int(totalAmount) ?? 0,
                                            startDate: startDate,
                                            totalMonthesForReturn: Int(totalMonthesForReturn) ?? 0,
                                            returnedAmount: 0)
                
//                    if var copyUser = UserDefaultsManager.shared.userModel {
//                        copyUser.debts.append(newDebt)
//                        UserDefaultsManager.shared.userModel? = copyUser
//                        
//                        if let newDebt = UserDefaultsManager.shared.userModel?.debts {
//                            debts = newDebt
//                        }
//                    }
                    closeSelf = false
                }
                Spacer()
            }
            .frame(width: Screen.width/1.2,
                   height: Screen.height/1.3)
            .offset(y: -40)
        }
        .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
    }
}

//struct AddDebtView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddDebtView(closeSelf: .constant(true),
//                    debts: .constant([DebtModel]()), editing: )
//    }
//}
