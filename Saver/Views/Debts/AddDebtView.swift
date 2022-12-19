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
    @State var whose = DebtEnum.took.rawValue
    @State var debtName = ""
    @State var startDate = Date.now
    @State var totalAmount = ""
    @State var totalMonthesForReturn = ""
    @State var editing: FocusState<Bool>.Binding
    
    var fieldsEmpty: Bool {
      if debtName != "",
         totalAmount != "",
         totalMonthesForReturn != ""{
          return false
      } else { return true }
    }
    
    var body: some View {
        ZStack {
            Color(hex: "C4C4C4").opacity(0.3)
                .ignoresSafeArea()
            
            Color.white
                .frame(width: UIScreen.main.bounds.width/1.2,
                       height: UIScreen.main.bounds.height/1.5)
                .cornerRadius(25)
                .shadow(radius: 25)
            
            VStack(spacing: 20) {
                    //---Header☑️
                    HStack {
                        Text("Add new debt")
                            .textCase(.uppercase)
                            .foregroundColor(.myGreen)
                            .font(.custom("Lato-ExtraBold", size: 22))
                        
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
                        Text("Whose")
                            .lineLimit(1)
                            .foregroundColor(.myGrayDark)
                            .font(.custom("Lato-Medium", size: 16))
                            .multilineTextAlignment(.leading)
                        
                        Spacer()
                        
                            Picker("", selection: $whose) {
                                Text("").tag("")
                                    .frame(height: 1)
                                ForEach(DebtEnum.allCases, id: \.self) { value in
                                    Text(value.rawValue)
                                        .tag(value)
                                }
                            }
                            .frame(width: UIScreen.main.bounds.width/2.5, height: 30)
                            
                        
                                      }
                    .padding(.horizontal, 20)
                    
                    //---Start date
                    
                    HStack {
                        Text("Start date")
                            .lineLimit(2)
                            .foregroundColor(.myGrayDark)
                            .font(.custom("Lato-Medium", size: 16))
                            .multilineTextAlignment(.leading)
                        
                        Spacer()
                        Image("calendar")
                        
                        DatePicker("", selection: $startDate,in: ...(Date.now + 86400) , displayedComponents: .date)
                            .labelsHidden()
                            .frame(width: UIScreen.main.bounds.width/2.5, height: 30)
                            .id(startDate)
                    }
                    .padding(.horizontal, 20)
                    
                    
                    //---Name☑️
                    
                    HStack {
                        Text("Name")
                            .foregroundColor(.myGrayDark)
                            .font(.custom("Lato-Medium", size: 16))
                            .multilineTextAlignment(.leading)
                        
                        Spacer()
                        
                        TextField("enter debt name",text: $debtName)
                            .frame(width: UIScreen.main.bounds.width/2, height: 50)
                            .overlay( RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .stroke( .gray, lineWidth: 1)
                                .padding(.leading, -10)
                                .padding(.trailing, -10) )
                        
                    }
                    .padding(.horizontal, 20)
                    
                    
                    
                    //---Amount☑️
                    
                    HStack {
                        Text("Amount")
                            .lineLimit(2)
                            .foregroundColor(.myGrayDark)
                            .font(.custom("Lato-Medium", size: 16))
                            .multilineTextAlignment(.leading)
                        Spacer()
                        TextField("enter amount",text: $totalAmount)
                            .frame(width: UIScreen.main.bounds.width/2, height: 50)
                            .overlay( RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .stroke( .gray, lineWidth: 1)
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
                    
                    //---totalMonthesForReturn☑️
                    
                    HStack {
                        Text("Monthes for return")
                            .lineLimit(2)
                            .foregroundColor(.myGrayDark)
                            .font(.custom("Lato-Medium", size: 16))
                            .multilineTextAlignment(.leading)
                        Spacer()
                        TextField("enter total monthes for return",text: $totalMonthesForReturn)
                            .frame(width: UIScreen.main.bounds.width/2, height: 50)
                            .overlay( RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .stroke( .gray, lineWidth: 1)
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
                        let newDebt = DebtModel(whose: DebtEnum(rawValue: whose) ?? .took,
                                                name: debtName,
                                                totalAmount: Int(totalAmount) ?? 0,
                                                startDate: startDate,
                                                totalMonthesForReturn: Int(totalMonthesForReturn) ?? 0,
                                                returnedAmount: 0)
                      
                        
                        if var copyUser = UserDefaultsManager.shared.userModel {
                            copyUser.debts.append(newDebt)
                            UserDefaultsManager.shared.userModel? = copyUser
                            
                            if let newDebt = UserDefaultsManager.shared.userModel?.debts {
                                debts = newDebt
                            }
                        }
                        closeSelf = false
                    }
                    Spacer()
                    
                }
              
            .frame(width: UIScreen.main.bounds.width/1.2,
                   height: UIScreen.main.bounds.height/1.5)
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
