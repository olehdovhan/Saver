//
//  ExpenseView.swift
//  Saver
//
//  Created by O l e h on 05.09.2022.
//
import SwiftUI
import Combine

struct ExpenseView: View {
    
    @Binding var closeSelf: Bool
    @State   var cashSource: String
    @Binding var purchaseCategoryName: String
   
    
    @State var purchaseCategories: [String] = []
    @State var editing: FocusState<Bool>.Binding
    

    
    @ObservedObject private var viewModel = ExpenseViewModel()
    @State var cashSources: [String]
    
      
    var body: some View {
        ZStack {
            SublayerView()
            
            Group{
                WhiteCanvasView(width: wRatio(320), height: wRatio(380))
                
                VStack(spacing: 0) {
                    HStack{
                        Text("Expense")
                            .foregroundColor(.myGrayDark)
                            .font(.custom("Lato-Bold", size: wRatio(18)))
                            .lineLimit(1)
                        
                        Spacer()
                        
                        CloseSelfButtonView($closeSelf)
                    }
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.trailing, wRatio(10))
                    .padding(.leading, wRatio(30))
                    .padding(.bottom, wRatio(20))
                    
                    VStack(spacing: 10){
                        HStack{
                            Text("Amount:")
                                .foregroundColor(.myGrayDark)
                                .font(.custom("NotoSansDisplay-Medium", size: 14))
                            
                            Spacer()
                            
                            TextField("", value: $viewModel.expense, format: .currency(code: Locale.current.currencyCode ?? "USD"))
                                .foregroundColor(.black)
                                .frame(width: wRatio(120), height: wRatio(30),  alignment: .trailing)
                                .overlay( RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .stroke( Color.myGreen, lineWidth: 1)
                                    .padding(.leading, wRatio(-10))
                                    .padding(.trailing, wRatio(-10))
                                )
                                .keyboardType(.decimalPad)
                                .focused(editing)
                        }
                        .padding(.leading,  wRatio(10))
                        .padding(.trailing, wRatio(25))
                            
                        
                        HStack {
                            Text("From")
                                .foregroundColor(.myGrayDark)
                                .font(.custom("NotoSansDisplay-Medium", size: 14))
                            
                            Spacer()
                            
                            Picker("", selection: $cashSource) {
                                ForEach(cashSources ,id: \.self) {
                                    Text($0)
                                        .frame(width: wRatio(120), height: wRatio(30))
                                }
                            }
                            .colorMultiply(.black)
                                .frame(width: wRatio(120), height: wRatio(30))
                            .overlay( RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .stroke( Color.myGreen, lineWidth: 1)
                                .padding(.leading, wRatio(-10))
                                .padding(.trailing, wRatio(-10))
                            )
                        }
                        .padding(.leading,  wRatio(10))
                        .padding(.trailing, wRatio(25))
                        
                        HStack {
                            Text("To")
                                .foregroundColor(.myGrayDark)
                                .font(.custom("NotoSansDisplay-Medium", size: 14))
                            
                            Spacer()
                            
                            Picker("", selection: $purchaseCategoryName) {
                                Text("").tag("").frame(height: 1)
                                
                                ForEach(purchaseCategories,id: \.self) {
                                    Text($0)
                                        .frame(width: wRatio(120), height: wRatio(30))
                                }
                            }
                            .colorMultiply(.black)
                                .frame(width: wRatio(120), height: wRatio(30))
                            .overlay( RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .stroke( Color.myGreen, lineWidth: 1)
                                .padding(.leading, wRatio(-10))
                                .padding(.trailing, wRatio(-10))
                            )
                        }
                        .padding(.leading,  wRatio(10))
                        .padding(.trailing, wRatio(25))
                        
                        
                        HStack {
                            Text("Date")
                                .foregroundColor(.myGrayDark)
                                .font(.custom("NotoSansDisplay-Medium", size: 14))
                            
                            Spacer()
                            
                            Image("Calendar")
                                .resizable()
                                .frame(width: wRatio(30), height: wRatio(30))
                            
                            DatePicker("", selection: $viewModel.expenseDate,in: ...(Date.now + 86400) , displayedComponents: .date)
                                .labelsHidden()
                                .frame(height: wRatio(30))
                                .overlay( RoundedRectangle(cornerRadius: 7, style: .continuous)
                                    .stroke( Color.myGreen, lineWidth: 1)
                                )
                                .id(viewModel.expenseDate)
                        }
                        .padding(.leading,  wRatio(10))
                        .padding(.trailing, wRatio(16))
                        
                        HStack {
                            Text("Time")
                                .foregroundColor(.myGrayDark)
                                .font(.custom("NotoSansDisplay-Medium", size: 14))
                            
                            Spacer()
                            
                            ZStack{
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .stroke( Color.gray, lineWidth: 0.5)
                                    .frame(width: wRatio(30), height: wRatio(30))
                                
                                Image("clock")
                                    .resizable()
                                    .frame(width: wRatio(20), height: wRatio(20))
                                    .colorInvert()
                                    .colorMultiply(.gray)
                            }
                            
                            DatePicker("", selection: $viewModel.expenseDate, displayedComponents: .hourAndMinute)
                                .labelsHidden()
                                .frame(height: wRatio(30))
                                .overlay( RoundedRectangle(cornerRadius: 7, style: .continuous)
                                    .stroke( Color.myGreen, lineWidth: 1)
                                )
                        }
                        .padding(.leading,  wRatio(10))
                        .padding(.trailing, wRatio(16))
                        
                        HStack {
                            Text("Comment")
                                .foregroundColor(.myGrayDark)
                                .font(.custom("NotoSansDisplay-Medium", size: 14))
                            
                            Spacer()
                            
                            TextField("",text: $viewModel.comment)
                                .placeholder(when: viewModel.comment.isEmpty) {
                                    Text("Comment").foregroundColor(.gray)
                                }
                                .foregroundColor(.black)
                                .frame(width: wRatio(120), height: wRatio(30),  alignment: .trailing)
                                .overlay( RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .stroke( Color.myGreen, lineWidth: 1)
                                    .padding(.leading, wRatio(-10))
                                    .padding(.trailing, wRatio(-10))
                                )
                        }
                        .padding(.leading,  wRatio(10))
                        .padding(.trailing, wRatio(25))
                        
                        
                    }
                    Spacer()
                        
                        DoneButtonView(isValid: viewModel.enteredExpense) {
                            viewModel.addAndCalculateExpens(from: cashSource,
                                                            to: purchaseCategoryName)
                            closeSelf = false
                        }
                        
                        
                    Spacer()
                }
                
                .padding(.top, wRatio(10))
                .frame(width: wRatio(320),
                       height: wRatio(380))
            }
            .liftingViewAtKeyboardOpen()
        }
        .onAppear() {
//            print(cashSource)
//            print(purchaseCategoryName)
            if let purchCats = FirebaseUserManager.shared.userModel?.purchaseCategories {
                purchaseCategories = purchCats.map { $0.name }
            }
        }
       
    }
}

