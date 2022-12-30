//
//  AddPurchaseCategoryView.swift
//  Saver
//
//  Created by Oleh Dovhan on 17.12.2022.
//

import SwiftUI
import Combine

struct AddPurchaseCategoryView: View {
    
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
            Color(hex: "C4C4C4").opacity(0.3)
                .ignoresSafeArea()
            
            Color.white
                .frame(width: 300,
                       height: 360,
                       alignment: .top)
                .cornerRadius(25)
                .shadow(radius: 25)
            
            VStack {
                HStack {
                    Text("Add new purchase category")
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
                
                HStack {
                    Text("Name")
                    Spacer()
                    Spacer()
                    Spacer()
    
                    TextField("enter name",text: $cashSourceName)
                        .frame(height: 50, alignment: .trailing)
                        .overlay( RoundedRectangle(cornerRadius: 20, style: .continuous)
                                                    .stroke( .gray, lineWidth: 3)
                                                    .padding(.leading, -10)
                                                    .padding(.trailing, -10) )
                }
                .padding(.leading,  30)
                .padding(.trailing, 35)
                
                HStack {
                    Text("Plannning to spend ")
                    Spacer()
                    Spacer()
                    Spacer()
                    TextField("sum to spend per month", text: $currentMoneyAmount)
                        .frame(height: 50, alignment: .trailing)
                        .overlay( RoundedRectangle(cornerRadius: 20, style: .continuous)
                                                    .stroke( .gray, lineWidth: 3)
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
                            .foregroundColor(.cyan)
                    } else {
                        switch selectedCashIconName {
                        case "iconClothing",
                             "iconEntertainment",
                             "iconHealth",
                             "iconHousehold",
                             "iconProducts",
                             "iconRestaurant",
                             "iconTransport":          Image(selectedCashIconName)
                                                        .resizable()
                                                        .frame(width: 65, height: 65)
                        default:         Image(systemName: selectedCashIconName)
                                         .resizable()
                                         .frame(width: 65, height: 65)
                        }
                    }
                }
                
                Spacer()
                ImageButton(image: "btnDoneInactive",
                            pressedImage: "btnDone",
                            disabled: fieldsEmpty) {
                    let newPurchaseCategory = PurchaseCategory(name: cashSourceName,
                                                         iconName: selectedCashIconName,
                                                         planSpentPerMonth: Double(currentMoneyAmount) ?? 0.0)
                    if var copyUser = UserDefaultsManager.shared.userModel {
                        copyUser.purchaseCategories.append(newPurchaseCategory)
                        UserDefaultsManager.shared.userModel? = copyUser
                        print("AAAA\(newPurchaseCategory)")
                    }
                    closeSelf = false
                }
                Spacer()
            }
            .frame(width: 300,
                   height: 360)
            
            if showIconsCashSource {
                AddIconsView(closeSelf: $showIconsCashSource,
                             type: .purchaseCategory) { iconName in
                selectedCashIconName = iconName
                }
            }
        }
        .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
    }
}

