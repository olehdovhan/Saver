//
//  IncomeView.swift
//  Saver
//
//  Created by Oleh Dovhan on 05.12.2022.
//

import SwiftUI
import Combine

struct IncomeView: View {
    
    @Binding var closeSelf: Bool
    @Binding  var cashSourceNameSelect: String
    @State private var amountIncome = ""
    @State private var comment = ""
    @State private var isDone = false
    @State private var expenseDate = Date.now
    @State var editing: FocusState<Bool>.Binding
    @Binding var cashSources: [CashSource]
    
    private var enteredIncome: Bool {
        switch amountIncome {
            
        case let x where Double(x.commaToDot())! > 0.0:
            return false
        default:
            return true
        }
    }
    
    
    var body: some View {
        ZStack {
            SublayerView()
            
            Group{
                WhiteCanvasView(width: wRatio(320), height: wRatio(340))
                
                VStack(spacing: 0) {
                    HStack{
                        Text("Income")
                            .textHeaderStyle()
                        
                        Spacer()
                        
                        DeleteSelfButtonView {
                            deleteCashSource()
                        }
                        
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
                            
                            ZStack{
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .stroke( Color.gray, lineWidth: 0.5)
                                    .frame(width: wRatio(30), height: wRatio(30))
                                
                                Text(Locale.current.currencyCode ?? "USD")
                                    .foregroundColor(Color.gray)
                                    .font(.custom("NotoSans-Regular", size: 30))
                                    .minimumScaleFactor(0.01)
                                    .frame(width: wRatio(30), height: wRatio(30))
                                
                            }
                            .padding(.trailing, wRatio(10))
                            .opacity(amountIncome.isEmpty ? 0 : 1)
                            
                            TextField("",text: $amountIncome)
                                .placeholder(when: amountIncome.isEmpty) {
                                    Text("0 " + (Locale.current.currencyCode ?? "USD")).foregroundColor(.gray)
                                }
                                .numbersOnly($amountIncome, includeDecimal: true)
                                .keyboardType(.decimalPad)
                                .focused(editing)
                                .foregroundColor(Double(amountIncome.commaToDot())! == 0.0 ? .gray : .black)
                                .frame(width: wRatio(120), height: wRatio(30),  alignment: .trailing)
                                .overlay( RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .stroke( Color.myGreen, lineWidth: 1)
                                    .padding(.leading, wRatio(-10))
                                    .padding(.trailing, wRatio(-10))
                                )
                                
                               
                                
                        }
                        .padding(.leading,  wRatio(10))
                        .padding(.trailing, wRatio(25))
                        
                        HStack {
                            Text("To:")
                                .foregroundColor(.myGrayDark)
                                .font(.custom("NotoSansDisplay-Medium", size: 14))
                            
                            Spacer()
                            
                                
                            Picker("", selection: $cashSourceNameSelect) {
                                let cashSorcesNames = cashSources.map{$0.name}
                                ForEach(cashSorcesNames, id: \.self) {
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
                                Text("\(cashSourceNameSelect)")
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
                            
                            DatePicker("", selection: $expenseDate,in: ...(Date.now + 86400) , displayedComponents: .date)
                                .frame(width: wRatio(120), height: wRatio(30))
                                .labelsHidden()
                                .opacity(0.025)
                                .overlay( RoundedRectangle(cornerRadius: 7, style: .continuous)
                                    .stroke( Color.myGreen, lineWidth: 1)
                                    .padding(.leading, wRatio(-10))
                                    .padding(.trailing, wRatio(-10))
                                )
                                .background(
                                    Text(expenseDate, format: Date.FormatStyle().year().month(.abbreviated).day())
                                        .frame(width: wRatio(120), height: wRatio(30))
                                        .foregroundColor(.myBlue)
                                )
                                .id(expenseDate)
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
                            
                            DatePicker("", selection: $expenseDate, displayedComponents: .hourAndMinute)
                                .frame(width: wRatio(120), height: wRatio(30))
                                .labelsHidden()
                                .frame(height: wRatio(30))
                                .opacity(0.025)
                                .overlay( RoundedRectangle(cornerRadius: 7, style: .continuous)
                                    .stroke( Color.myGreen, lineWidth: 1)
                                    .padding(.leading, wRatio(-10))
                                    .padding(.trailing, wRatio(-10))
                                )
                                .background(
                                    Text(expenseDate, style: .time)
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
                            
                            TextField("",text: $comment)
                                .placeholder(when: comment.isEmpty) {
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
                    
                    DoneButtonView(isValid: enteredIncome) {
                        
                        let incomeModel = IncomeModel(amount: Double(amountIncome.commaToDot())!,
                                                      comment: comment,
                                                      incomeDate: Date(),
                                                      cashSource: cashSourceNameSelect)
                        if var user = FirebaseUserManager.shared.userModel {
                            if user.currentMonthIncoms == nil {
                                var incomes = [IncomeModel]()
                                incomes.append(incomeModel)
                                user.currentMonthIncoms = incomes
                            } else {
                                user.currentMonthIncoms?.append(incomeModel)
                            }
                            
                            var cashSourceIncreaseIndex: Int?
                            for (index, source) in user.cashSources.enumerated() {
                                if source.name == cashSourceNameSelect {
                                    cashSourceIncreaseIndex = index
                                }
                            }
                            
                            if let index = cashSourceIncreaseIndex {
                                user.cashSources[index].increaseAmount(Double(amountIncome.commaToDot())!)
                            }
                            
                            FirebaseUserManager.shared.userModel = user
                        }
                        
                        
                        
                        closeSelf = false
                    }
                    
                    Spacer()
                }
                .padding(.top, wRatio(10))
                .frame(width: wRatio(320),
                       height: wRatio(340))
                
            }
            .liftingViewAtKeyboardOpen()
            
        }
        .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
    
       
    
    }
    
    
    
    func deleteCashSource() -> Void{
        if var user = FirebaseUserManager.shared.userModel {
            var sources = user.cashSources
            for (index,source) in sources.enumerated() {
                if source.name == cashSourceNameSelect {
                    sources.remove(at: index)
                }
            }
            user.cashSources = sources
            FirebaseUserManager.shared.userModel = user
            if let cashes = FirebaseUserManager.shared.userModel?.cashSources {
                cashSources = cashes
            }
            closeSelf = false
        }
    }
    
}

struct Previews_Income: PreviewProvider {
    
    static var previews: some View {
     
        MainScreen(isShowTabBar: .constant(false),
                   incomeViewShow: true,
                   cashSource: "Bank card",
                   cashSources: [CashSource.init(name: "Bank card",
                                                 amount: 1000,
                                                 iconName: "")],
                   progress: false)
        
            .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro"))
            .previewDisplayName("iPhone 14 Pro")
        
            
    }
}


