//
//  AddCashSourceView.swift
//  Saver
//
//  Created by Oleh Dovhan on 10.12.2022.
//

import SwiftUI
import Combine

struct AddCashSourceView: View {
    
    @Binding var closeSelf: Bool
    @State private var cashSourceName = ""
    @State private var currentMoneyAmount = ""
    @State var editing: FocusState<Bool>.Binding
    
    @State private var showIconsCashSource = false
    @State private var selectedCashIconName = ""
    
    var fieldsEmpty: Bool {
        if selectedCashIconName != "",
           cashSourceName != "",
           currentMoneyAmount != "" {
            return false
        } else { return true }
    }
    
    var body: some View {
        ZStack {
            Color.myGrayLight.opacity(0.7)
                .ignoresSafeArea()
            
            Color.white
                .frame(
                    width: 300,
                    height: 360,
                    alignment: .top)
                .cornerRadius(25)
                .shadow(radius: 25)
            
            VStack {
                HStack {
                    Text("Add new money source")
                        .foregroundColor(.black)
                        .frame(alignment: .leading)
                        .padding(.leading, 34)
                    
                    Spacer()
                    
                    Button{
                        closeSelf = false
                    }
                label: {
                    Image("btnClose")
                }
                .frame(alignment: .trailing)
                .padding(.trailing, 16)
                }
                .frame(width: 300,
                       alignment: .top)
                .padding(.top, 24)
                
                HStack {
                    Text("Name")
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    TextField("",text: $cashSourceName)
                        .placeholder(when: cashSourceName.isEmpty) {
                            Text("enter name")
                                .foregroundColor(.gray)
                        }
                        .foregroundColor(.black)
                        .frame(height: 50,
                               alignment: .trailing)
                        .overlay(RoundedRectangle(cornerRadius: 20,
                                                  style: .continuous)
                            .stroke(Color.myGreen,
                                    lineWidth: 1)
                                .padding(.leading, -10)
                                .padding(.trailing, -10))
                }
                .padding(.leading,  30)
                .padding(.trailing, 35)
                
                HStack {
                    Text("Money amount")
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    TextField("", text: $currentMoneyAmount)
                        .placeholder(when: currentMoneyAmount.isEmpty) {
                            Text("sum to spend per month")
                                .foregroundColor(.gray)
                        }
                        .foregroundColor(.black)
                        .frame(height: 50,
                               alignment: .trailing)
                        .overlay(
                            RoundedRectangle(
                                cornerRadius: 20,
                                style: .continuous)
                            .stroke(
                                Color.myGreen,
                                lineWidth: 1)
                            .padding(.leading, -10)
                            .padding(.trailing, -10)
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
                .padding(.leading,  30)
                .padding(.trailing, 35)
                
                // Icon - with
                Button {
                    showIconsCashSource = true
                } label: {
                    if selectedCashIconName == "" {
                        CircleTextView(text: "ICON")
                            .foregroundColor(.myGreen)
                            .myShadow(radiusShadow: 5)
                    } else {
                        
                        switch selectedCashIconName {
                        case "iconBankCard", "iconWallet":
                            Image(selectedCashIconName)
                                .resizable()
                                .frame(
                                    width: 50,
                                    height: 50)
                                .myShadow(radiusShadow: 5)
                        default:
                            ZStack{
                                Color.myGreen
                                    .frame(
                                        width: 50,
                                        height: 50)
                                
                                Image(systemName: selectedCashIconName)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(
                                        width: 30,
                                        height: 30)
                                    .foregroundColor(.white)
                            }
                            .cornerRadius(15)
                            .myShadow(radiusShadow: 5)
                        }
                    }
                }
                
                Spacer()
                ImageButton(image: "btnDoneInactive",
                            pressedImage: "btnDone",
                            disabled: fieldsEmpty) {
                    let newCashSource = CashSource(
                        name: cashSourceName,
                        amount: Double(currentMoneyAmount) ?? 0.0,
                        iconName: selectedCashIconName)
                    
                    if var copyUser = UserDefaultsManager.shared.userModel {
                        copyUser.cashSources.append(newCashSource)
                        UserDefaultsManager.shared.userModel? = copyUser
                        print("AAAA\(newCashSource)")
                    }
                    closeSelf = false
                }
                Spacer()
            }
            .frame(
                width: 300,
                height: 360)
            .blur(radius: showIconsCashSource ? 5 : 0)
            
            if showIconsCashSource {
                AddIconsView(
                    closeSelf: $showIconsCashSource,
                    type: .cashSource) { iconName in
                        selectedCashIconName = iconName
                    }
            }
        }
        .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
    }
}
