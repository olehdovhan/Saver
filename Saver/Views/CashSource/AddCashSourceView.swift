//
//  AddCashSourceView.swift
//  Saver
//
//  Created by Oleh Dovhan on 10.12.2022.
//

import SwiftUI
import Combine

struct AddCashSourceView: View {
    @Binding var user: UserModel?
    @Binding var closeSelf: Bool
    @State var newCashSourceName = ""
    @State var currentMoneyAmount = ""
    @State var editing: FocusState<Bool>.Binding
    
    @State var showIconsCashSource = false
    @State var selectedCashIconName = ""
    @State var cashSourceNames: [String] = []
    @State var isUniqueName: Bool = true
    
    var fieldsEmpty: Bool {
        if selectedCashIconName != "",
           newCashSourceName != "",
           currentMoneyAmount != "",
           isUniqueName {
            return false
        } else { return true }
    }
    
    
    var body: some View {
        ZStack {
            SublayerView()
            
            Group{
                WhiteCanvasView(width: wRatio(320), height: wRatio(320))
                
                VStack(spacing: 0) {
                    
                    HStack{
                        Text("Add new money source")
                            .textHeaderStyle()
                        
                        Spacer()
                        
                        CloseSelfButtonView($closeSelf)
                    }
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.trailing, wRatio(10))
                    .padding(.leading, wRatio(30))
                    .padding(.bottom, wRatio(20))
                    
                    VStack(spacing: wRatio(10)){
                        
                        ZStack{
                            HStack{
                                Text("Resource icon:")
                                    .foregroundColor(.myGrayDark)
                                    .font(.custom("NotoSansDisplay-Medium", size: 14))
                                
                                Spacer()
                                
                            }
                            .padding(.leading,  wRatio(10))
                            
                            HStack{
                                Spacer()
                                
                                Button {
                                    showIconsCashSource = true
                                } label: {
                                    if selectedCashIconName == "" {
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(Color.myGreen, lineWidth: 1)
                                            .frame(width: wRatio(50), height: wRatio(50))
                                            .overlay(
                                                Text("?")
                                                    .foregroundColor(.gray)
                                                    .font(.custom("Lato-Regular", size: 20)))
                                    } else {
                                        switch selectedCashIconName {
                                        case "iconBankCard", "iconWallet":
                                            Image(selectedCashIconName)
                                                .resizable()
                                                .frame(width: wRatio(50), height: wRatio(50))
                                                .myShadow(radiusShadow: 5)
                                        default:
                                            ZStack{
                                                Color.myGreen
                                                    .frame(width: wRatio(50), height: wRatio(50))
                                                
                                                Image(selectedCashIconName)
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: wRatio(30), height: wRatio(30))
                                                    .foregroundColor(.white)
                                            }
                                            .cornerRadius(15)
                                            .myShadow(radiusShadow: 5)
                                        }
                                    }
                                }
                                .padding(.trailing, wRatio(25))
                                .offset(x: wRatio(-35))
                                
                            }
                        }
                        
                        HStack {
                            ZStack{
                                HStack {
                                    Text("Name:")
                                        .foregroundColor(.myGrayDark)
                                        .font(.custom("NotoSansDisplay-Medium", size: 14))
                                    
                                    Spacer()
                                }
                                
                                HStack {
                                Text("Enter a unique name")
                                        .foregroundColor(isUniqueName ? .clear : .red)
                                    .font(.custom("Noto-Regular", size: 10))
                                    .offset(y: 15)
                                    
                                    Spacer()
                                }
                            }
                            Spacer()
                            
                            TextField("",text: $newCashSourceName)
                                .placeholder(when: newCashSourceName.isEmpty) {
                                    Text("enter name").foregroundColor(.gray)
                                }
                                .foregroundColor(.black)
                                .frame(width: wRatio(120), height: wRatio(50),  alignment: .trailing)
                                .overlay( RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .stroke( Color.myGreen, lineWidth: 1)
                                    .padding(.leading, wRatio(-10))
                                    .padding(.trailing, wRatio(-10))
                                )
                        }
                        .padding(.leading,  wRatio(10))
                        .padding(.trailing, wRatio(25))
                        
                        HStack {
                            Text("Money amount:")
                                .foregroundColor(.myGrayDark)
                                .font(.custom("NotoSansDisplay-Medium", size: 14))
                            Spacer()
                            TextField("", text: $currentMoneyAmount)
                                .placeholder(when: currentMoneyAmount.isEmpty) {
                                    Text("sum to spend per month").foregroundColor(.gray)
                                }
                                .foregroundColor(.black)
                                .frame(width: wRatio(120), height: wRatio(50),  alignment: .trailing)
                                .overlay( RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .stroke( Color.myGreen, lineWidth: 1)
                                    .padding(.leading, wRatio(-10))
                                    .padding(.trailing, wRatio(-10))
                                )
                                .keyboardType(.numberPad)
                                .lineLimit(nil)
                                .onReceive(Just(currentMoneyAmount)) { newValue in
                                    let filtered = newValue.filter { "0123456789 ".contains($0) }
                                    if filtered != newValue {
                                        self.currentMoneyAmount = filtered
                                    }
                                }
                        }
                        .padding(.leading,  wRatio(10))
                        .padding(.trailing, wRatio(25))
                        
                    }
                    Spacer()
                    
                    DoneButtonView(isValid: fieldsEmpty) {
                        doneAction()
                    }
                    
                    Spacer()
                }
                .padding(.top, wRatio(10))
                .frame(width: wRatio(320),
                       height: wRatio(320))
                .blur(radius: showIconsCashSource ? 5 : 0)
                
                if showIconsCashSource {
                    AddIconsView(closeSelf: $showIconsCashSource, type: .cashSource) { iconName in
                        selectedCashIconName = iconName
                    }
                }
            }
            .liftingViewAtKeyboardOpen()
                
        }
        .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
        .onAppear(){
            cashSourceNames = user!.cashSources.map{$0.name}
        }
        .onChange(of: newCashSourceName) { newValue in
        isUniqueName = !cashSourceNames.contains(newCashSourceName)
        }
    }
    
    func doneAction() -> Void {
        if !fieldsEmpty{
            let newCashSource = CashSource(name: newCashSourceName,
                                           amount: Double(currentMoneyAmount) ?? 0.0,
                                           iconName: selectedCashIconName)
            let incomeModel = IncomeModel(amount: Double(currentMoneyAmount.commaToDot())!,
                                          comment: "initial",
                                          incomeDate: Date(),
                                          cashSource: newCashSourceName)
            
            
            if user?.currentMonthIncoms == nil {
                var incomes = [IncomeModel]()
                incomes.append(incomeModel)
                user?.currentMonthIncoms = incomes
                user?.cashSources.append(newCashSource)
                FirebaseUserManager.shared.userModel = user
            } else {
                user?.currentMonthIncoms?.append(incomeModel)
                user?.cashSources.append(newCashSource)
                FirebaseUserManager.shared.userModel = user
            }
         
            closeSelf = false
        }
    }
}

struct Previews_AddCashSourceView: PreviewProvider {
    static var previews: some View {
        MainScreen(isShowTabBar: .constant(false), addCashSourceViewShow: true)
            .previewDevice(PreviewDevice(rawValue: "iPhone SE (3rd generation)"))
            .previewDisplayName("iPhone SE")
        
        MainScreen(isShowTabBar: .constant(false), addCashSourceViewShow: true)
            .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro"))
            .previewDisplayName("iPhone 14 Pro")
    }
}
