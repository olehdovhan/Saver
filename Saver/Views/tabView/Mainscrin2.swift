//
//  Mainscrin2.swift
//  Saver
//
//  Created by Пришляк Дмитро on 20.08.2022.
//

import SwiftUI




struct Mainscrin2: View {
    var body: some View {
        ZStack{
            Color.white //.ignoresSafeArea(edges: .top)
            VStack(alignment: .center, spacing: 0){
                BalanceView().zIndex(3)
                CardsPlace().zIndex(2)
                StatisticsPlace().zIndex(1)
                
                LinearGradient(colors: [.myGreen, .myBlue],
                               startPoint: .leading,
                               endPoint: .trailing)
                    .frame(width: UIScreen.main.bounds.width, height: 3, alignment: .top)
                
                
                CoastsPlace()
                
                
                Spacer(minLength: 200)
                
            }
         
        }
        
        .ignoresSafeArea(.all)
 
    }
}

//struct Mainscrin2_Previews: PreviewProvider {
//    static var previews: some View {
//        Mainscrin2()
//    }
//
//}
