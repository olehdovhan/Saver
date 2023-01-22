//
//  SocialButtonView.swift
//  Saver
//
//  Created by Pryshliak Dmytro on 21.01.2023.
//

import SwiftUI

struct SocialButtonView: View{
    let image: String
    let widthImg: CGFloat, heightImg: CGFloat
    let closure: () -> ()
    
    var body: some View{
        Button {
            closure()
        } label: {
            ZStack{
                Circle()
                    .fill(Color.white)
                    .frame(
                        width: 50,
                        height: 50)
                    .shadow(radius: 10)
                
                Image(image)
                    .resizable()
                    .frame(
                        width: widthImg,
                        height: heightImg)
            }
        }
    }
}
