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
    
    private var enteredIncome: Bool {
        switch income {
        case let x where x > 0.0:  return false
        default:                   return true
        }
    }
    
    var body: some View {
        ZStack {
            Color(hex: 0xC4C4C4, alpha: 0.7)
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
                    
                    .padding(.leading, 30)
                    .padding(.trailing, 30)
                    .keyboardType(.decimalPad)
                    .focused(editing)
                    .background(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .stroke(editing.wrappedValue ? Color.red : Color.gray, lineWidth: 3)
                    ).padding()
                
                HStack {
                    Text("To")
                    Spacer()
                    if let cashSources = UserDefaultsManager.shared.userModel?.cashSources {
                        Picker("", selection: $cashSource) {
                            ForEach(cashSources ,id: \.self) {
                                Text($0.name)
                            }
                        }
                        
                        .colorMultiply(.black)
                        
                        .background( RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .stroke( .gray, lineWidth: 3)
                            .padding(.leading, -20)
                            .padding(.trailing, -20)
                        )
                    }
                }
                .padding(.leading, 30)
                .padding(.trailing, 60)
                
                
                HStack {
                    Text("Date")
                  
                    Spacer()
                    Image("calendar")
                 
                    DatePicker("", selection: $expenseDate,in: ...(Date.now + 86400) , displayedComponents: .date)
                        .labelsHidden()
                        .background( RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .stroke( .gray, lineWidth: 3)
                        )
                        .id(expenseDate)
                       // .foregroundColor(.red)
                }
                .padding(.leading,  30)
                .padding(.trailing, 35)
  
                HStack {
                    Text("Time")
                    Spacer()
                    
                    DatePicker("", selection: $expenseDate, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .background( RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .stroke( .gray, lineWidth: 3)
                        )
                }
                .padding(.leading,  30)
                .padding(.trailing, 35)
                
                HStack {
                    Text("Comment")
                    Spacer()
                    Spacer()
                    Spacer()
    
                    TextField("  Comment",text: $comment)
                        .frame(height: 50, alignment: .trailing)
                        .overlay( RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .stroke( .gray, lineWidth: 3)
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
            }
            .frame(width: 300,
                   height: 500,
                   alignment: .top)
        }
    }
}