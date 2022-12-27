//
//  ExpenseView.swift
//  Saver
//
//  Created by O l e h on 05.09.2022.
//
import SwiftUI

struct ExpenseView: View {
    
    @Binding var closeSelf: Bool
    @State  var cashSource: String
    @Binding var purchaseCategoryName: String
    @State private var expense = 0.0
    @State private var comment = ""
    @State private var isDone = false
    @State private var expenseDate = Date.now
    
    @State var purchaseCategories: [String] = []
    @State var editing: FocusState<Bool>.Binding
    
    private var enteredExpense: Bool {
        switch expense {
        case let x where x > 0.0:  return false
        default:                   return true
        }
    }
    
    @State var cashSources: [String]
      
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
                HStack {
                    Text("Expense")
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
            
                TextField("", value: $expense, format: .currency(code: Locale.current.currencyCode ?? "USD"))
                    .placeholder(when: expense != 0.0) {
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
                    Text("From")
                        .foregroundColor(.black)
                    Spacer()
                        Picker("", selection: $cashSource) {
                            ForEach(cashSources ,id: \.self) {
                                Text($0)
                            }
                        }
                        .colorMultiply(.black)
                        .background( RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .stroke( Color.myGreen, lineWidth: 1)
                            .padding(.leading, -20)
                            .padding(.trailing, -20)
                        )
                                  }
                .padding(.leading, 30)
                .padding(.trailing, 60)
                
                HStack {
                    Text("To")
                        .foregroundColor(.black)
                    Spacer()
                    Picker("", selection: $purchaseCategoryName) {
                        Text("").tag("")
                            .frame(height: 1)
                        ForEach(purchaseCategories,id: \.self) {
                            Text($0)
                        }
                    }
                    .colorMultiply(.black)
                    
                    .background( RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke( Color.myGreen, lineWidth: 1)
                        .padding(.leading, -20)
                        .padding(.trailing, -20)
                    )
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
                        .background(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                              .stroke( Color.myGreen, lineWidth: 1)
                        )
                        .id(expenseDate)
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
    
                    TextField("",text: $comment)
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
                ImageButton(image: "btnDoneInactive", pressedImage: "btnDone", disabled: enteredExpense) {
                    print("tap rap snap")
                    print(enteredExpense)
                }
                Spacer()
            }
            .frame(width: 300,
                   height: 500,
                   alignment: .top)
        }
        .onAppear() {
            print(cashSource)
            print( purchaseCategoryName)
            if let purchCats = UserDefaultsManager.shared.userModel?.purchaseCategories {
                purchaseCategories = purchCats.map { $0.name}
            }
        }
    }
}

