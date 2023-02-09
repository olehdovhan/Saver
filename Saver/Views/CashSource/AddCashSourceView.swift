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
    @State var cashSourceName = ""
    @State var currentMoneyAmount = ""
    @State var editing: FocusState<Bool>.Binding
    
    @State var showIconsCashSource = false
    @State var selectedCashIconName = ""
    
    var fieldsEmpty: Bool {
        if selectedCashIconName != "",
           cashSourceName != "",
           currentMoneyAmount != "" {
            return false
        } else { return true }
    }
    
    var body: some View {
        ZStack {
            
            
            
            Color(hex: "C4C4C4").opacity(0.7)
                .ignoresSafeArea()
                .onTapGesture {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
            
            Color.white
                .frame(width: wRatio(320),
                       height: wRatio(320),
                       alignment: .top)
                .cornerRadius(25)
                .shadow(radius: 25)
                .onTapGesture {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
            
            VStack(spacing: 0) {
                
                ZStack{
                    HStack {
                        VStack{
                            Text("Add new money source")
                                .foregroundColor(.myGrayDark)
                                .font(.custom("Lato-Bold", size: wRatio(18)))
                                .lineLimit(2)
                                .frame(width: wRatio(270))
                                .multilineTextAlignment(.center)
                        }
                        Spacer()
                    }
                    
                    HStack(){
                        Spacer()
                        Button {
                            closeSelf = false
                        }
                    label: {
                        Image("btnClose")
                            .resizable()
                            .frame(width: wRatio(30), height: wRatio(30))
                            .myShadow(radiusShadow: 5)
                    }
                    .padding(.trailing, wRatio(10))
                    }
                    
                }
                .frame(width: wRatio(320), alignment: .top)
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
                                                .font(.custom("Lato-Regular", size: 20))
                                            
                                        )
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
                                            
                                            Image(systemName: selectedCashIconName)
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
                        Text("Name:")
                            .foregroundColor(.myGrayDark)
                            .font(.custom("NotoSansDisplay-Medium", size: 14))
                        Spacer()
                        
                        
                        TextField("",text: $cashSourceName)
                            .placeholder(when: cashSourceName.isEmpty) {
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
                    
                Button{
                    if !fieldsEmpty{
                        let newCashSource = CashSource(name: cashSourceName, amount: Double(currentMoneyAmount) ?? 0.0, iconName: selectedCashIconName)
                        if var copyUser = FirebaseUserManager.shared.userModel {
                            copyUser.cashSources.append(newCashSource)
                            FirebaseUserManager.shared.userModel? = copyUser
                            print("AAAA\(newCashSource)")
                        }
                        closeSelf = false
                    }
                } label: {
                    Image(fieldsEmpty ? "btnDoneInactive" : "btnDone")
                        .resizable()
                        .frame(width: wRatio(50), height: wRatio(50))
                        .myShadow(radiusShadow: 5)
                }
                
                
                
                
                Spacer()
//                ImageButton(image: "btnDoneInactive",
//                            pressedImage: "btnDone",
//                            disabled: fieldsEmpty) {
//                    let newCashSource = CashSource(name: cashSourceName, amount: Double(currentMoneyAmount) ?? 0.0, iconName: selectedCashIconName)
//                    if var copyUser = FirebaseUserManager.shared.userModel {
//                        copyUser.cashSources.append(newCashSource)
//                        FirebaseUserManager.shared.userModel? = copyUser
//                        print("AAAA\(newCashSource)")
//                    }
//                    closeSelf = false
//                }
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
        .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
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
