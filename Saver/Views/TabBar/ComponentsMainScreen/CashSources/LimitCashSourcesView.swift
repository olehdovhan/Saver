//
//  LimitCashSourcesView.swift
//  Saver
//
//  Created by Pryshliak Dmytro on 04.01.2023.
//

import SwiftUI

struct LimitCashSourcesView: View {
    @Binding var closeSelf: Bool
    var body: some View {
        
        ZStack {
            SublayerView()
            
            WhiteCanvasView(width: wRatio(320), height: wRatio(220))
            
            
            VStack(spacing: 0) {
                
                HStack{
                    Text("Attention")
                        .textHeaderStyle()
                        
                    
                    Spacer()
                    
                    CloseSelfButtonView($closeSelf)
                }
                
                .fixedSize(horizontal: false, vertical: true)
                .padding(.trailing, wRatio(10))
                .padding(.leading, wRatio(30))
                
                Spacer()
                
                VStack(spacing: 10){
                    Text("Limitation")
                        .foregroundColor(.myGrayDark)
                        .font(.custom("Lato-Bold", size: 14))
                        .multilineTextAlignment(.center)
                        .lineLimit(1)
                        .textCase(.uppercase)
                    
                    Text("You have reached the maximum number of cash resources")
                        .foregroundColor(.myGrayDark)
                        .font(.custom("Lato-Regular", size: 14))
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                }
                .frame(width: wRatio(220), height: wRatio(100))
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 15).fill(.white)
                        .myShadow(radiusShadow: 5)
                )
                
                
                Spacer()
            }
            .padding(.top, wRatio(10))
            .frame(width: wRatio(320),
                   height: wRatio(220))
            

        }
        

    }
}

struct Previews_Limitation: PreviewProvider {
    
    static var previews: some View {
     
        MainScreen(isShowTabBar: .constant(false),
                   limitCashSourcesViewShow: true)
//            .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro"))
//            .previewDisplayName("iPhone 14 Pro")
            
    }
}
