//
//  BalanceView.swift
//  Saver
//
//  Created by Пришляк Дмитро on 21.08.2022.
//

import SwiftUI

struct BalanceView: View {
    
    @State private var isDragging = false
    
    var body: some View {
        ZStack{
        LinearGradient(colors: [.myGreen, .myBlue],
                       startPoint: .top,
                       endPoint: .bottom )
        
            .frame(width: Screen.width, height: 120, alignment: .top)
            .cornerRadius(30)

        HStack(alignment: .center){
            VStack {
                Image(systemName: "chevron.down.circle.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.white)
                    
                Image("avatar")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.white)
                if let user = UserDefaultsManager.shared.userModel {
                    Text("\(user.name)")
                        .foregroundColor(.white)
                        .font(FontType.latoSemibold.font(size: 16))
                }
            }
            Spacer()
            VStack{
                Text("Balance")
                    .foregroundColor(.white)
                    .font(FontType.latoSemibold.font(size: 16))
                
                Text("+45.000")
                    .foregroundColor(.white)
                    .font(FontType.latoBold.font(size: 16))
            }
            
            Spacer()
            
            VStack{
                Text("Expence")
                    .foregroundColor(.white)
                    .font(FontType.latoSemibold.font(size: 16))
                
                Text("15.250")
                    .foregroundColor(.white)
                    .font(FontType.latoBold.font(size: 16))
            }
        }
        .padding(.leading, 30)
        .padding(.trailing, 30)
    }
  }
}

//struct BalanceView_Previews: PreviewProvider {
//    static var previews: some View {
//        BalanceView()
//    }
//}
