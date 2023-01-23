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
            Color.myGrayLight.opacity(0.3)
                .ignoresSafeArea()
            
            Color.white
                .frame(width: Screen.width/1.2,
                       height: Screen.height/1.5)
                .cornerRadius(25)
                .myShadow(radiusShadow: 5)
            
            
            VStack(spacing: 20) {
                
                //Header
                HStack(alignment: .center, spacing: 10){
                    Text("Attention")
                        .lineLimit(1)
                        .textCase(.uppercase)
                        .foregroundColor(.myGreen)
                        .font(FontType.latoExtraBold.font(size: 22))
                        .frame(width: Screen.width/2.2)
                    
                    Spacer()
                    
                    Button {
                        closeSelf = false
                    } label: {
                        Image("btnClose")
                            .resizable()
                            .frame(width: 45, height: 45)
                    }
                }
                .padding(.top, 20)
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                
                Spacer()
                
                VStack(spacing: 10){
                 
                    
                    Text("Limitation")
                        .foregroundColor(.myGrayDark)
                        .font(FontType.latoBold.font(size: 16))
                        .multilineTextAlignment(.center)
                        .lineLimit(1)
                        .textCase(.uppercase)
                    
                    Text("You have reached the maximum number of cash resources")
                        .foregroundColor(.myGrayDark)
                        .font(FontType.latoRegular.font(size: 16))
                        .multilineTextAlignment(.center)
                        .lineLimit(4)
                        .padding(.horizontal, 20)
                }
                .frame(width: Screen.width/1.5, height: Screen.height/5.5)
                .background(
                    RoundedRectangle(cornerRadius: 15).fill(.white)
                        .myShadow(radiusShadow: 5)
                )
                
                Spacer()
            }
            .frame(width: Screen.width/1.2,
                   height: Screen.height/1.5)
            

        }
        

    }
}

