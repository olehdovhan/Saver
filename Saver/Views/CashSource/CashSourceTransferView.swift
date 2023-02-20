//
//  CashSourceTransferView.swift
//  Saver
//
//  Created by Oleh on 19.02.2023.
//

import SwiftUI
import Combine

struct CashSourceTransferView: View {
    
    @ObservedObject private var viewModel = CashSourceTransferViewModel()
    
    @Binding var closeSelf: Bool
    @State var cashSourceProvider: String
    @State var cashSourceReceiver: String
    @State var editing: FocusState<Bool>.Binding
    @State var cashSources: [String]
    
    var body: some View {
        
        ZStack {
            SublayerView()
            
            Group{
                WhiteCanvasView(width: wRatio(320), height: wRatio(380))
                
                VStack(spacing: 0) {
                  
                    HStack{
                        Text("Transfer")
                            .textHeaderStyle()
                        
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
                            
                            TextField("", value: $viewModel.transferAmount, format: .currency(code: Locale.current.currencyCode ?? "USD"))
                                .foregroundColor(viewModel.transferAmount == 0.0 ? .gray : .black)
                                .frame(width: wRatio(120), height: wRatio(30),  alignment: .trailing)
                                .overlay( RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .stroke(Color.myGreen, lineWidth: 1)
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
                            
                            Picker("", selection: $cashSourceProvider) {
                                ForEach(cashSources, id: \.self) {
                                    Text($0)
                                        .frame(width: wRatio(120), height: wRatio(30))
                                }
                            }
                            .pickerStyle(.menu)
                            .opacity(0.025)
                            .frame(width: wRatio(120), height: wRatio(30))
                            .overlay( RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .stroke( Color.myGreen, lineWidth: 1)
                                .padding(.leading, wRatio(-10))
                                .padding(.trailing, wRatio(-10))
                            )
                            .background(
                                Text("\(cashSourceProvider)")
                                    .foregroundColor(.myBlue)
                                    .frame(width: wRatio(120), height: wRatio(30))
                            )
                            
                        }
                        .padding(.leading,  wRatio(10))
                        .padding(.trailing, wRatio(25))
                        
                        HStack {
                            Text("To")
                                .foregroundColor(.myGrayDark)
                                .font(.custom("NotoSansDisplay-Medium", size: 14))
                            
                            Spacer()
                            
                            Picker("", selection: $cashSourceReceiver) {
                                ForEach(cashSources, id: \.self) {
                                    Text($0)
                                        .frame(width: wRatio(120), height: wRatio(30))
                                }
                            }
                            .pickerStyle(.menu)
                            .opacity(0.025)
                            .colorMultiply(.black)
                                .frame(width: wRatio(120), height: wRatio(30))
                            .overlay( RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .stroke( Color.myGreen, lineWidth: 1)
                                .padding(.leading, wRatio(-10))
                                .padding(.trailing, wRatio(-10))
                            )
                            .background(
                                Text("\(cashSourceReceiver)")
                                    .foregroundColor(.myBlue)
                                    .frame(width: wRatio(120), height: wRatio(30))
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
                                .padding(.trailing, wRatio(10))
                            
                            DatePicker("", selection: $viewModel.expenseDate,in: ...(Date.now + 86400) , displayedComponents: .date)
                                .frame(width: wRatio(120), height: wRatio(30))
                                .labelsHidden()
                                .opacity(0.025)
                                .overlay( RoundedRectangle(cornerRadius: 7, style: .continuous)
                                    .stroke( Color.myGreen, lineWidth: 1)
                                    .padding(.leading, wRatio(-10))
                                    .padding(.trailing, wRatio(-10))
                                )
                                .background(
                                    Text(viewModel.expenseDate, format: Date.FormatStyle().year().month(.abbreviated).day())
                                        .frame(width: wRatio(120), height: wRatio(30))
                                        .foregroundColor(.myBlue)
                                )
                                .id(viewModel.expenseDate)
                        }
                        .padding(.leading,  wRatio(10))
                        .padding(.trailing, wRatio(25))
                        
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
                            .padding(.trailing, wRatio(10))
                            
                            DatePicker("", selection: $viewModel.expenseDate, displayedComponents: .hourAndMinute)
                                .frame(width: wRatio(120), height: wRatio(30))
                                .labelsHidden()
                                .opacity(0.025)
                                .overlay( RoundedRectangle(cornerRadius: 7, style: .continuous)
                                    .stroke( Color.myGreen, lineWidth: 1)
                                    .padding(.leading, wRatio(-10))
                                    .padding(.trailing, wRatio(-10))
                                )
                                .background(
                                    Text(viewModel.expenseDate, style: .time)
                                        .frame(width: wRatio(120), height: wRatio(30))
                                        .foregroundColor(.myBlue)
                                )
                        }
                        .padding(.leading,  wRatio(10))
                        .padding(.trailing, wRatio(25))
                        
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
                        
                    DoneButtonView(isValid: viewModel.isEnteredTransferAmount) {
//                        viewModel.transferBetweenCashSources(from: cashSourceProvider,
//                                                                    to: cashSourceReceiver)
                        viewModel.transferBetweenCashSources(from: cashSourceProvider,
                                                             to: cashSourceReceiver)
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
            
        }
        
    }
}

//struct CashSourceTransferView_Previews: PreviewProvider {
//    static var previews: some View {
//        CashSourceTransferView()
//    }
//}
