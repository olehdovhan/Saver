//
//  RegistrationView.swift
//  Saver
//
//  Created by Pryshliak Dmytro on 14.01.2023.
//

import SwiftUI
import Combine
import AVKit

struct RegistrationView: View {
    
    @StateObject private var viewModel = RegistrationViewModel()
    
    let validCharsPass = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,@:?!()$\\/#"
    
    var body: some View {
            ZStack {
                GeometryReader { reader in
                    Color.myGreen
                        .frame(height: reader.safeAreaInsets.top, alignment: .top)
                        .ignoresSafeArea()
                    
                }
                Rectangle()
                    .fill(Color.white)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                NavigationLink(isActive: $viewModel.willMoveToTabBar) {
                    TabBarView()
                } label: { }
                
                VStack(spacing: 0){
                    Spacer(minLength: 50)
                    
                    Text("Regisration")
                        .lineLimit(1)
                        .foregroundColor(.myGreen)
                        .font(.custom("Lato-ExtraBold", size: 30))
                    //
                    Spacer()
                    
                    fieldsView
                    
                    HStack(spacing: 0){
                        Button {
                            viewModel.privacyTermsAccepted.toggle()
                            if viewModel.privacyTermsAccepted {
                                viewModel.validatedPrivacy = .validated
                            }
                        } label: {
                            Image(viewModel.privacyTermsAccepted ? "registration_checkmark_full" : "registration_checkmark_empty")
                                .resizable()
                                .frame(width: 20, height: 20)
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 3)
                                .stroke(viewModel.validatedPrivacy == .validated ? Color.clear : Color.myRed, lineWidth: 2)
                        )
                        Spacer()
                            .frame(width: 10)
                        
                        Text("With conditions  [User agreement](https://policies.google.com/terms?hl=en-US) and [Policy of confeditionity](https://policies.google.com/privacy?hl=en-US) familiarized")
                            .font(.custom("Lato-Regular", size: 13))
                    }
                    .frame(width: wRatio(250))
                    .padding(.top, wRatio(30))
                    
                    Text("or")
                        .font(.custom("NotoSans-Regular", size: 20))
                        .padding(.top, wRatio(30))
                        .foregroundColor(.myGrayDark)

                    HStack(spacing: wRatio(50)){
                        SocialButton(image: "icoGoogle" ,
                                     widthImg: 20,
                                     heightImg: 20){
                            print("F")
                        }
                        SocialButton(image: "icoFacebook",
                                     widthImg: 10,
                                     heightImg: 20){
                            print("F")
                        }
                    }
                    .padding(.top, wRatio(30))
                    .padding(.bottom, wRatio(30))
               
  
                    NavigationLink(isActive: $viewModel.willMoveToLogin) {
                        LoginView()
                    } label: {
                        Text("Already have account?")
                            .lineLimit(1)
                            .foregroundColor(.myGreen)
                            .font(.custom("Lato-Regular", size: 16))
                            .padding(.bottom, wRatio(28))
                    }
                    
            
                    
                    
                    
                    Button {
                        viewModel.createAccountOnceTapped = true
                        let inputTFCorrect = viewModel.inputValidated()
                        if inputTFCorrect && viewModel.privacyTermsAccepted { viewModel.registerUser() }
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 10).fill(
                                LinearGradient(colors: [.myGreen, .myBlue],
                                               startPoint: .leading,
                                               endPoint: .trailing)
                            )
                            .frame(width: wRatio(250), height: 50)
                            
                            Text("Go!")
                                .lineLimit(1)
                                .foregroundColor(.white)
                                .font(.custom("Lato-ExtraBold", size: 26))
                        }
                    }
                    Spacer()
                }
            }
            .navigationBarHidden(true)
        
    }
    
    private var fieldsView: some View {
        VStack{
            TextField("Email", text: $viewModel.email, onEditingChanged: { changed in
                 viewModel.emailIsEditing = changed
                if viewModel.createAccountOnceTapped {
                    let _ = viewModel.inputValidated()
                }
              })
            .frame(width: wRatio(250))
            .authTextField(isEditing: viewModel.emailIsEditing, vState: viewModel.correctEmail)
                .autocapitalization(.none)
            
          // Hidden
            Text(viewModel.correctEmail.message)
                .font(.custom("Lato-ExtraBold", size: 11))
                .foregroundColor(.red)
                .opacity(viewModel.correctEmail == .validated ? 0.0 : 1.0)
            
            TextField("Password", text: $viewModel.password, onEditingChanged: { changed in
                viewModel.passwordIsEditing = changed
                if viewModel.createAccountOnceTapped {
                 let _ = viewModel.inputValidated()
                }
              })
                
                .secure(true)
                .frame(width: wRatio(250))
                .authTextField(isEditing: viewModel.passwordIsEditing,
                               vState: viewModel.correctPassword)
                .onReceive(Just(viewModel.password), perform: { value in
                                    let filtered = value.filter { validCharsPass.contains($0) }
                                    if filtered != value {
                                        viewModel.password = filtered
                                    }
                                })

            // Hidden
              Text(viewModel.correctPassword.message)
            
                .font(.custom("Lato-ExtraBold", size: 11))
                  .foregroundColor(.red)
                  .opacity(viewModel.correctPassword == .validated ? 0.0 : 1.0)
            
            TextField("Repeat password", text: $viewModel.repeatPassword, onEditingChanged: { changed in
                viewModel.repeatPasswordIsEditing = changed
                if viewModel.createAccountOnceTapped {
                    let _ = viewModel.inputValidated()
                }
              })
                .secure(true)
                .frame(width: wRatio(250))
                .authTextField(isEditing: viewModel.repeatPasswordIsEditing, vState: viewModel.correctPassword)
                .onReceive(Just(viewModel.repeatPassword), perform: { value in
                                    let filtered = value.filter { validCharsPass.contains($0) }
                                    if filtered != value {
                                        viewModel.repeatPassword = filtered
                                    }
                                })
            
            // Hidden
              Text(viewModel.correctPassword.message)
                .font(.custom("Lato-ExtraBold", size: 11))
                  .foregroundColor(.red)
                  .opacity(viewModel.correctPassword == .validated ? 0.0 : 1.0)
            
            
            
            
            
            
        }
    }
    
    var privacyPolicy: some View{
        HStack{
            Button {
                viewModel.privacyTermsAccepted.toggle()
                if viewModel.privacyTermsAccepted {
                    viewModel.validatedPrivacy = .validated
                }
            } label: {
                viewModel.privacyTermsAccepted ? Image("registration_checkmark_full") : Image("registration_checkmark_empty")
                  
            }
            .overlay(
                      RoundedRectangle(cornerRadius: 3)
                        .stroke(viewModel.validatedPrivacy == .validated ? Color.clear : Color.myGreen, lineWidth: 2)
              )
            Spacer()
                .frame(width: 10)
            
            Text("With conditions  [User agreement](https://policies.google.com/terms?hl=en-US) and [Policy of confeditionity](https://policies.google.com/privacy?hl=en-US) familiarized")
                .font(.custom("Lato-Regular", size: 13))
        }
        .frame(width: wRatio(250))
        
        
        
    }

}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}


struct SocialButton: View{
    let image: String
    let widthImg: CGFloat
    let heightImg: CGFloat
    let closure: () -> ()
    
    var body: some View{
        Button {
            closure()
        } label: {
            ZStack{
                Circle().fill(Color.white).frame(width: 50, height: 50).shadow(radius: 10)
                Image(image)
                    .resizable()
                    .frame(width: widthImg, height: heightImg)
                
            }
            
            
        }
    }
}

