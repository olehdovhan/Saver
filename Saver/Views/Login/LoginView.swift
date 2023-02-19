//
//  LoginView.swift
//  Saver
//
//  Created by Pryshliak Dmytro on 14.01.2023.
//

import SwiftUI
import Foundation
import Combine

struct LoginView: View {
    
    @ObservedObject private var viewModel = LoginViewModel()
    
    @State private var email = ""
    @State private var password = ""
    @State private var isSecure = true
    
    @State private var isShowRegister = false
    @State private var isForceClose = false
    
    @State private var keyboardHeight: CGFloat = 0
    
    var body: some View {
        
            ZStack {
                GeometryReader { reader in
                    Color.myGreen
                        .frame(height: reader.safeAreaInsets.top, alignment: .top)
                        .ignoresSafeArea( edges: .top)
                }
                
                Rectangle()
                    .fill(Color.white)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .onTapGesture {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
                
                VStack(alignment: .center, spacing: 0){
                    
                    //
                    Spacer()
                    
                    Text("Login")
                        .lineLimit(1)
                        .foregroundColor(.myGreen)
                        .font(.custom("Lato-ExtraBold", size: 30))
                        .padding(.bottom, 20)
                    fieldsView
                    
                    Text("or")
                        .font(.custom("NotoSans-Regular", size: 20))
                        .padding(.top, wRatio(5))
                        .foregroundColor(.myGrayDark)
                    VStack(spacing: 20) {
                        AuthGoogleButton(image: "googleIco",
                                         widthImg: 20,
                                         heightImg: 20){
                            viewModel.signInGoogle()
                        }
                                         .frame(width: 230, height: 50)
                        
                        AuthWithAppleButton { }
                        .frame(width: 230, height: 50)
                    }
                    .padding(.top, wRatio(15))
                    .padding(.bottom, wRatio(30))
                    
                    NavigationLink {
                        RegistrationView()
                    } label: {
                        Text("Create an account")
                            .lineLimit(1)
                            .foregroundColor(.myGreen)
                            .font(.custom("Lato-Regular", size: 16))
                            .padding(.bottom, wRatio(28))
                    }
                    
                    Button {
                        viewModel.login(login: email, password: password)
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
                    .padding(.bottom, wRatio(30))
                    
                    NavigationLink {
                        ForgotPasswordView()
                    } label: {
                        Text("Forgot password?")
                            .lineLimit(1)
                            .foregroundColor(.myGreen)
                            .font(.custom("Lato-Regular", size: 16))
                    }
                    Spacer()
                }
                
                
            }
            .onReceive(Publishers.keyboardHeight) { value in
                withAnimation() {
                    self.keyboardHeight = value
                }
            }
            .navigationBarHidden(true)
            .keyboardAdaptive()
            .navigationBarBackButtonHidden(true)
        
        }
    
    private var fieldsView: some View {
        VStack(alignment: .center, spacing: 0) {
            TextField("Email", text: $email, onEditingChanged: { changed in
                viewModel.loginIsEditing = changed
              })
            .authTextField(isEditing: viewModel.loginIsEditing, vState: .validated)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .frame(width: wRatio(250))
            
            Text("Incorrect format")
                .font(.custom("Lato-ExtraBold", size: 11))
                .foregroundColor(.red)
                .padding(.bottom, 5)
                .opacity(viewModel.incorrectEmail ? 0.0 : 1.0)
            
            HStack {
                if isSecure {
                    TextField("Password", text: $password , onEditingChanged: { changed in
                        viewModel.passwordIsEditing = changed
                      })
                     .secure(true)
                } else {
                    TextField("Password", text: $password, onEditingChanged: { changed in
                        viewModel.passwordIsEditing = changed
                      })
                }
                Spacer()
                
                Button {
                    isSecure.toggle()
                } label: {
                    Image(isSecure ? "login_show_pass_ic" : "login_hidden_pass_ic")
                        .renderingMode(.template)
                        .foregroundColor(.green)
                }
            }
            .authTextField(isEditing: viewModel.passwordIsEditing, vState: .validated)
            .frame(width: wRatio(250))
            
            Text("Password")
                .font(.custom("Lato-ExtraBold", size: 11))
                .foregroundColor(.red)
                .opacity(viewModel.incorrectPassword ? 0.0 : 1.0)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            LoginView()
            
                .previewDevice(PreviewDevice(rawValue: "iPhone SE (3rd generation)"))
                .previewDisplayName("iPhone SE")
            
            LoginView()
                .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro"))
                .previewDisplayName("iPhone 14 Pro")
        }
    }
}


struct AuthGoogleButton: View{
    let image: String
    let widthImg: CGFloat
    let heightImg: CGFloat
    let closure: () -> ()
    
    var body: some View{
        Button {
            closure()
        } label: {
            HStack {
                ZStack{
                    RoundedRectangle(cornerRadius: 5).fill(.white).frame(width: 20, height: 20)
                    Image(image)
                        .resizable()
                        .frame(width: 15, height: 15)
                    
                }
                Text("Sign in with Google")
                    .font(.title3)
                    .foregroundColor(.white)
            }
            .frame(width: 230, height: 50)
            .background(RoundedRectangle(cornerRadius: 7).fill(.blue))
        }
    }
}
