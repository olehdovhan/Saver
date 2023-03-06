//
//  AddPurchaseCategoryView.swift
//  Saver
//
//  Created by Oleh Dovhan on 17.12.2022.
//

import SwiftUI
import Combine

struct AddPurchaseCategoryView: View {
    @Binding var user: UserModel?
    @Binding var closeSelf: Bool
    @State var newCategoryName = ""
    @State var currentMoneyAmount = ""
    @State var editing: FocusState<Bool>.Binding
  
    @State var showIconsCategory = false
    @State var selectedCategoryIconName = ""
    
    @State var categoryNames: [String] = []
    @State var isUniqueName: Bool = true
    
    var fieldsEmpty: Bool {
      if selectedCategoryIconName != "",
         newCategoryName != "",
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
                            Text("Add new purchase category")
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
                                Text("Category icon:")
                                    .foregroundColor(.myGrayDark)
                                    .font(.custom("NotoSansDisplay-Medium", size: 14))
                                
                                Spacer()
                            }
                            .padding(.leading,  wRatio(10))
                            
                            
                            HStack{
                                Spacer()
                                
                                Button {
                                    showIconsCategory = true
                                } label: {
                                    if selectedCategoryIconName == "" {
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(Color.myGreen, lineWidth: 1)
                                            .frame(width: wRatio(50), height: wRatio(50))
                                            .overlay(
                                                Text("?")
                                                    .foregroundColor(.gray)
                                                    .font(.custom("Lato-Regular", size: 20))
                                                
                                            )
                                    } else {
                                        switch selectedCategoryIconName {
                                        case "iconClothing",
                                            "iconEntertainment",
                                            "iconHealth",
                                            "iconHousehold",
                                            "iconProducts",
                                            "iconRestaurant",
                                            "iconTransport":
                                            Image(selectedCategoryIconName)
                                                .resizable()
                                                .frame(width: wRatio(50), height: wRatio(50))
                                                .myShadow(radiusShadow: 5)
                                        default:
                                            ZStack{
                                                Color.white
                                                    .frame(width: wRatio(50), height: wRatio(50))
                                                
                                                Image(selectedCategoryIconName)
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: wRatio(30), height: wRatio(30))
                                                    .foregroundColor(.gray.opacity(0.75))
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
                            
                            TextField("",text: $newCategoryName)
                                .placeholder(when: newCategoryName.isEmpty) {
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
                            Text("Plannning to spend:")
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
                .blur(radius: showIconsCategory ? 5 : 0 )
                
                if showIconsCategory {
                    AddIconsView(closeSelf: $showIconsCategory,
                                 type: .purchaseCategory) { iconName in
                        selectedCategoryIconName = iconName
                    }
                }
                
            }
            .liftingViewAtKeyboardOpen()
        }
        .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
        .onAppear(){
            categoryNames = user!.purchaseCategories.map{$0.name}
        }
        .onChange(of: newCategoryName) { newValue in
        isUniqueName = !categoryNames.contains(newCategoryName)
        }
    }
    
    
    func doneAction() -> Void{
        if !fieldsEmpty{
            let newPurchaseCategory = PurchaseCategory(name: newCategoryName,
                                                       iconName: selectedCategoryIconName,
                                                       planSpentPerMonth: Double(currentMoneyAmount) ?? 0.0)
      
                user?.purchaseCategories.append(newPurchaseCategory)
                FirebaseUserManager.shared.userModel = user

            closeSelf = false
        }
    }
}

struct Previews_AddPurchaseCategoryView: PreviewProvider {
    static var previews: some View {
        MainScreen(isShowTabBar: .constant(false), addPurchaseCategoryViewShow: true)
            .previewDevice(PreviewDevice(rawValue: "iPhone SE (3rd generation)"))
            .previewDisplayName("iPhone SE")
        
        MainScreen(isShowTabBar: .constant(false), addPurchaseCategoryViewShow: true)
            .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro"))
            .previewDisplayName("iPhone 14 Pro")
    }
}
