//
//  ExpenseView.swift
//  Saver
//
//  Created by O l e h on 05.09.2022.
//
import SwiftUI

struct ExpenseView: View {
    
    @State private var expense = 0.0
    @State private var comment = ""
    
    @State private var isDone = false
    
    // Should be initialized when tapEnded
    @State private var cashSource = CashSource.bankCard
    @State private var cashSources = [CashSource.bankCard, CashSource.wallet]
    @State private var expenseDate = Date.now
    
    // Should be initialized when tapEnded
    @State private var expenseCategory = ExpenseCategory.clothing
    @FocusState private var editing: Bool
    
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
                    Text("Expense")
                        .frame(alignment: .leading)
                        .padding(.leading, 34)
                    Spacer()
                    Button {}
                     label: {
                        Image("btnClose")
                    }
                     .frame( alignment: .trailing)
                     .padding(.trailing, 16)
                }
                .frame(width: 300, alignment: .top)
                .padding(.top, 24)
            
                TextField("Expense", value: $expense, format: .currency(code: Locale.current.currencyCode ?? "USD"))
                    
                    .padding(.leading, 30)
                    .padding(.trailing, 30)
                    .keyboardType(.decimalPad)
                    .focused($editing)
                    .background(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .stroke(editing ? Color.red : Color.gray, lineWidth: 3)
                    ).padding()

                
                HStack {
                    Text("From")
                    Spacer()
                
                    Picker("Tip percentage", selection: $cashSource) {
                        ForEach(cashSources,id: \.self) {
                            Text($0.rawValue)
                        }
                      
                    }
                    .colorMultiply(.black)
                   // .foregroundColor(.brown)
            
                    .background( RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke( .gray, lineWidth: 3)
                        .padding(.leading, -20)
                        .padding(.trailing, -20)

                    )
                    
                //    .tint(.black)
                    
                }
                .padding(.leading, 30)
                .padding(.trailing, 60)
                
                HStack {
                    Text("To")
                    Spacer()
                
                    Picker("", selection: $expenseCategory) {
                        ForEach(ExpenseCategory.allCases,id: \.self) {
                            Text($0.rawValue)
                        }
                    }
                    .colorMultiply(.black)
                    
                    .background( RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke( .gray, lineWidth: 3)
                        .padding(.leading, -20)
                        .padding(.trailing, -20)
                    )
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
                ImageButton(image: "btnDoneInactive", pressedImage: "btnDone") {}
                Spacer()
            }
            .frame(width: 300,
                   height: 500,
                   alignment: .top)
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        editing = false
                    }
                }
            }
        }
    }
}



struct ExpenseView_Previews: PreviewProvider {
    static var previews: some View {
        ExpenseView()
    }
}
