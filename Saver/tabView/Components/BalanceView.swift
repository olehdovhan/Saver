//
//  BalanceView.swift
//  Saver
//
//  Created by Пришляк Дмитро on 21.08.2022.
//

import SwiftUI

struct BalanceView: View {
    var body: some View {
        ZStack{
            
        LinearGradient(colors: [.myGreen, .myBlue],
                       startPoint: .topLeading,
                       endPoint: .bottomTrailing)
        
            .frame(width: UIScreen.main.bounds.width, height: 150, alignment: .top)
            .cornerRadius(30)

        HStack(alignment: .center){
            VStack{
                
                Image(systemName: "chevron.down.circle.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.white)
                    
                Image("avatar")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.white)
                
                Text("Daria")
                    .foregroundColor(.white)
                    .font(.custom("Lato-SemiBold", size: 16, relativeTo: .body))
                    
                
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
