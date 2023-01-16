//
//  LoginView.swift
//  Saver
//
//  Created by Pryshliak Dmytro on 14.01.2023.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject private var viewModel = LoginViewModel()
    
    @State private var email = ""
    @State private var password = ""
    @State private var isSecure = true
    
    @State private var isShowRegister = false
    @State private var isForceClose = false
    
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
                    .onTapGesture {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
                
                VStack(spacing: 0){
                    
                    Spacer(minLength: 50)
                    
                    Text("Login")
                        .lineLimit(1)
                        .foregroundColor(.myGreen)
                        .font(.custom("Lato-ExtraBold", size: 30))
                    //
                    Spacer()
                    
                    
                    fieldsView
                    
                    Text("or")
                        .font(.custom("NotoSans-Regular", size: 20))
                        .padding(.top, wRatio(30))
                        .foregroundColor(.myGrayDark)
                    
                    //                Spacer()
                    
                    HStack(spacing: wRatio(50)){
                        SocialButton(image: "icoGoogle",
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
                    
                    
                    
                    Button{
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
                            .padding(.bottom, wRatio(28))
                    }
                    
                    
                    Spacer()
                }
                
            }
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
//                     .frame(width: wRatio(250))
                } else {
                    TextField("Password", text: $password, onEditingChanged: { changed in
                        viewModel.passwordIsEditing = changed
                      })
//                    .frame(width: wRatio(250))
                      
                }
                Spacer()
                
                Button {
                    isSecure.toggle()
                } label: {
                    isSecure ? Image("login_show_pass_ic") : Image("login_hidden_pass_ic")
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
        LoginView()
    }
}
