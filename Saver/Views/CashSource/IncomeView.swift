//
//  IncomeView.swift
//  Saver
//
//  Created by Oleh Dovhan on 05.12.2022.
//

import SwiftUI

struct IncomeView: View {
    
    @Binding var closeSelf: Bool
    @State  var cashSource: String
    @State private var income = 0.0
    @State private var comment = ""
    @State private var isDone = false
    @State private var expenseDate = Date.now
    @State var editing: FocusState<Bool>.Binding
    @Binding var cashSources: [CashSource]
    
    private var enteredIncome: Bool {
        switch income {
        case let x where x > 0.0:  return false
        default:                   return true
        }
    }
    
    var body: some View {
        ZStack {
            Color(hex: "C4C4C4").opacity(0.7)
                .ignoresSafeArea()
            
            Color.white
                .frame(width: 300,
                       height: 500,
                       alignment: .top)
                .cornerRadius(25)
                .shadow(radius: 25)
            
            VStack {
                HStack {
                    Text("Income")
                        .foregroundColor(.black)
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
            
                TextField("Expense", value: $income, format: .currency(code: Locale.current.currencyCode ?? "USD"))
                    .placeholder(when: income != 0.0) {
                            Text("Expense").foregroundColor(.gray)
                    }
                
                    .foregroundColor(.black)
                    .padding(.leading, 30)
                    .padding(.trailing, 30)
                    .keyboardType(.decimalPad)
                    .focused(editing)
                    .background(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .stroke(editing.wrappedValue ? Color.red : Color.myGreen, lineWidth: 1)
                    ).padding()
                
                HStack {
                    Text("To")
                        .foregroundColor(.black)
                    Spacer()
                    if let cashSources = UserDefaultsManager.shared.userModel?.cashSources {
                        Picker("", selection: $cashSource) {
                            ForEach(cashSources ,id: \.self) {
                                Text($0.name)
                            }
                        }
                        
                        .colorMultiply(.black)
                        
                        .background( RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .stroke( Color.myGreen, lineWidth: 1)
                            .padding(.leading, -20)
                            .padding(.trailing, -20)
                        )
                    }
                }
                .padding(.leading, 30)
                .padding(.trailing, 60)
                
                
                HStack {
                    Text("Date")
                        .foregroundColor(.black)
                    Spacer()
                    Image("calendar")
                 
                    DatePicker("", selection: $expenseDate,in: ...(Date.now + 86400) , displayedComponents: .date)
                        .labelsHidden()
                        .background( RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .stroke( Color.myGreen, lineWidth: 1)
                        )
                        .id(expenseDate)
                       // .foregroundColor(.red)
                }
                .padding(.leading,  30)
                .padding(.trailing, 35)
  
                HStack {
                    Text("Time")
                        .foregroundColor(.black)
                    Spacer()
                    
                    DatePicker("", selection: $expenseDate, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .background( RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .stroke( Color.myGreen, lineWidth: 1)
                        )
                }
                .padding(.leading,  30)
                .padding(.trailing, 35)
                
                HStack {
                    Text("Comment")
                        .foregroundColor(.black)
                    Spacer()
                    Spacer()
                    Spacer()
    
                    TextField("Comment",text: $comment)
                        .placeholder(when: comment.isEmpty) {
                                Text("Comment").foregroundColor(.gray)
                        }
                        .foregroundColor(.black)
                        .frame(height: 50, alignment: .trailing)
                        .overlay( RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .stroke( Color.myGreen, lineWidth: 1)
                            .padding(.leading, -10)
                            .padding(.trailing, -10)
                        )
                        .lineLimit(nil)
                }
                .padding(.leading,  30)
                .padding(.trailing, 35)
        
                Spacer()
                ImageButton(image: "btnDoneInactive", pressedImage: "btnDone", disabled: enteredIncome) {
                    print("tap rap snap")
                    print(enteredIncome)
                }
                Spacer()
                Button("delete",role: .destructive) {
                    
                    if var user = UserDefaultsManager.shared.userModel {
                        var sources = user.cashSources
                        for (index,source) in sources.enumerated() {
                            if source.name == cashSource {
                                sources.remove(at: index)
                            }
                        }
                        user.cashSources = sources
                        UserDefaultsManager.shared.userModel = user
                        if let cashes = UserDefaultsManager.shared.userModel?.cashSources {
                            cashSources = cashes
                        }
                        closeSelf = false
                    }
                }
            }
            .frame(width: 300,
                   height: 500,
                   alignment: .top)
        }
        .offset(y: -50)
    
    }
}
