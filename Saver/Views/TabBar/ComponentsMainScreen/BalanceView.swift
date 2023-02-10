//
//  BalanceView.swift
//  Saver
//
//  Created by Пришляк Дмитро on 21.08.2022.
//

import SwiftUI

struct BalanceView: View {
    
    @State var isDragging = false
    @Binding var showQuitAlert: Bool
    
    var body: some View {
        ZStack{
            LinearGradient(colors: [.myGreen, .myBlue],
                           startPoint: .top,
                           endPoint: .bottom )
            .frame(width: UIScreen.main.bounds.width, height: hRatio(130), alignment: .top)
            .cornerRadius(30, corners: [.bottomLeft, .bottomRight])
            
            VStack(){
                Spacer().frame(height: 20)
                HStack(){
                    ZStack{
                        Button {
                            showQuitAlert = true
                            
                        } label: {
                            Image("avatar")
                                .resizable()
                                .frame(width: hRatio(50), height: hRatio(50))
                                .foregroundColor(.white)
                        }
                        
                        Image(systemName: "chevron.down.circle.fill")
                            .resizable()
                            .frame(width: hRatio(20), height: hRatio(20))
                            .foregroundColor(.white)
                            .offset(y: -hRatio(40))
                    }
                    
                    Spacer()
                    
                    VStack{
                        Text("Balance")
                            .foregroundColor(.white)
                            .font(.custom("Lato-SemiBold", size: 16, relativeTo: .body))
                        
                        Text("+45.000")
                            .foregroundColor(.white)
                            .font(.custom("Lato-Bold", size: 16, relativeTo: .body))
                    }
                    
                    Spacer()
                    
                    VStack{
                        Text("Expence")
                            .foregroundColor(.white)
                            .font(.custom("Lato-SemiBold", size: 16, relativeTo: .body))
                        
                        Text("15.250")
                            .foregroundColor(.white)
                            .font(.custom("Lato-Bold", size: 16, relativeTo: .body))
                    }
                }
                
                HStack(){
                    if let user = FirebaseUserManager.shared.userModel {
                        Text("\(user.name)")
                            .foregroundColor(.white)
                            .font(.custom("Lato-SemiBold", size: 16, relativeTo: .body))
                            .lineLimit(1)
                    } else {
                        Text("User name = nil")
                            .foregroundColor(.white)
                            .font(.custom("Lato-SemiBold", size: 16, relativeTo: .body))
                    }
                    
                    Spacer()
                }

            }
            .padding(.leading, 30)
            .padding(.trailing, 30)
        }
    }
}

struct BalanceView_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen(isShowTabBar: .constant(true))
            .previewDevice(PreviewDevice(rawValue: "iPhone SE (3rd generation)"))
            .previewDisplayName("iPhone SE")
        
        MainScreen(isShowTabBar: .constant(true))
            .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro"))
            .previewDisplayName("iPhone 14 Pro")
    }
}
