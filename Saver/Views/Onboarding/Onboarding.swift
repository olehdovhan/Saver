//
//  Onboarding.swift
//  Saver
//
//  Created by Pryshliak Dmytro on 16.01.2023.
//

import SwiftUI

struct OnboardingView: View {
    @State private var showSecondOnboard = false
    @State private var calculatedHeight: CGFloat = 0
    var body: some View {
        ZStack{
            TabView(selection: $showSecondOnboard){
                OnboardView(
                    showSecondOnboard: $showSecondOnboard,
                    imageName: "onboardingFirst",
                    imageWidth: 230,
                    imageHeight: 285,
                    description: "Welcome to Saver - an application that will help you manage your income and expenses",
                    buttonText: "Next",
                    calculatedHeight: $calculatedHeight
                ) {
                    showSecondOnboard = true
                }
                .tag(false)
                
                OnboardView(
                    showSecondOnboard: $showSecondOnboard,
                    imageName: "onboardingSecond",
                    imageWidth: 250,
                    imageHeight: 250,
                    description: "Shows where the money goes",
                    buttonText: "Go!",
                    calculatedHeight: $calculatedHeight
                ) {
                    print("Press Button <Next> in One Onboarding")
                }
                .tag(true)
                
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            
            VStack(spacing: 0){
                Rectangle().fill(.clear).frame(width: screenW, height: calculatedHeight).opacity(0.01)
                
                ZStack(){
                    Circle()
                        .fill(.secondary).opacity(0.5)
                        .frame(width: wRatio(20), height: wRatio(20))
                        .onTapGesture {
                            showSecondOnboard = false
                        }
                        .offset(x: -(wRatio(20)))
                    
                    Circle()
                        .fill(.secondary).opacity(0.5)
                        .frame(width: wRatio(20), height: wRatio(20))
                        .onTapGesture {
                            showSecondOnboard = true
                        }
                        .offset(x: wRatio(20))
                    
                    Circle()
                        .fill(Color.myGreen)
                        .frame(width: wRatio(20), height: wRatio(20))
                        .offset(x: showSecondOnboard ? wRatio(20) : -(wRatio(20)))
                        .animation(.spring())
                }
                .offset(y: -(wRatio(30)))
                
                Spacer()
            }

        }
    }
}

struct Onboarding_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}

struct OnboardView: View{
    @Binding var showSecondOnboard: Bool
    let imageName: String
    let imageWidth: CGFloat
    let imageHeight: CGFloat
    let description: String
    let buttonText: String
    @Binding var calculatedHeight: CGFloat
    let buttonAction: () -> (Void)
    @State var animationFirst = false
    @State var animationSecond = false
    let springAnimation = Animation.spring(
        response: 0.7,
        dampingFraction: 0.5,
        blendDuration: 0.3)
    
    var body: some View{
        ZStack {
            Rectangle()
                .fill(Color.white)
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity)
                
            VStack(spacing: 0){
                Group{
                    Spacer(minLength: 30)
                    
                    Text("Saver")
                        .lineLimit(1)
                        .foregroundColor(.myGreen)
                        .font(FontType.latoExtraBold.font(size: 30))
                    
                    
                    Group{
                        Text(description)
                            .foregroundColor(.myGrayDark)
                            .font(FontType.notoSDMedium.font(size: 22))
                            .multilineTextAlignment(.center)
                            .frame(width: wRatio(296),  alignment: .center)
                    }
                    .frame(height: 150)
                    
                    Spacer()
                    
                    Group{
                        Image(imageName)
                            .resizable()
                            .frame(
                                width: wRatio(imageWidth),
                                height: wRatio(imageHeight))
                            .rotationEffect(Angle.degrees(animationSecond ? 0 : 360 ))
                            .scaleEffect(animationFirst ? 1 : 0.9)
                            .onChange(of: showSecondOnboard){ _ in
                                if showSecondOnboard == true{
                                    if imageName == "onboardingSecond"{
                                        withAnimation(springAnimation){
                                            animationSecond = true
                                        }
                                    }
                                    } else {
                                        animationSecond = false
                                    }
                            }
                            .onChange(of: showSecondOnboard){ _ in
                                if showSecondOnboard == false{
                                    if imageName == "onboardingFirst"{
                                        withAnimation(springAnimation){
                                            animationFirst = true
                                        }
                                    }
                                    } else {
                                        animationFirst = false
                                    }
                            }
                            .onAppear(){
                                if imageName == "onboardingFirst"{
                                    withAnimation(springAnimation){
                                        animationFirst = true
                                    }
                                }
                            }
                    }
                    .frame(height: wRatio(285))
                    
                    Spacer()
                    
                }
                .background(GeometryReader {
                    Color.clear.preference(
                        key: ViewHeightKey.self,
                        value: $0.frame(in: .global).size.height)
                })
                
                Button{
                    buttonAction()
                } label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 10)
                            .fill(
                            LinearGradient(colors: [.myGreen, .myBlue],
                                           startPoint: .leading,
                                           endPoint: .trailing)
                        )
                        .frame(
                            width: wRatio(250),
                            height: 50)
                        
                        Text(buttonText)
                            .lineLimit(1)
                            .foregroundColor(.white)
                            .font(FontType.latoExtraBold.font(size: 26))
                    }
                }
                
                Spacer(minLength: 30)
            }
            .onPreferenceChange(ViewHeightKey.self) { calculatedHeight = $0 }
        }
        .ignoresSafeArea()
    }
}

struct ViewHeightKey: PreferenceKey {
    static var defaultValue: CGFloat { 0 }
    static func reduce(
        value: inout Value,
        nextValue: () -> Value
    ) {
        value = value + nextValue()
    }
}
