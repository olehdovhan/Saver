//
//  RegistrationView.swift
//  Saver
//
//  Created by Pryshliak Dmytro on 14.01.2023.
//

import SwiftUI
import Combine
//import AVKit
import Firebase

struct RegistrationView: View {
    
    @StateObject private var viewModel = RegistrationViewModel()
    
    @State private var keyboardHeight: CGFloat = 0
    @State private var showPrivacyWebView = false
    @State private var showTermsWebView = false
    
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
                    .onTapGesture {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
                
                NavigationLink(isActive: $viewModel.willMoveToTabBar) {
                    TabBarView()
                } label: {
                    
                }
                
                VStack( alignment: .center, spacing: 0){
    //                    Spacer(minLength: 50)
                    Spacer()
                    
                    Text("Regisration")
                        .lineLimit(1)
                        .foregroundColor(.myGreen)
                        .font(.custom("Lato-ExtraBold", size: 30))
                        .padding(.bottom, keyboardHeight == 0 ? wRatio(50) : wRatio(10))
                    //
                    //                    Spacer()
                    
                    fieldsView
                    
//                    ZStack{
//                        HStack{
//                            Button {
//                                viewModel.privacyTermsAccepted.toggle()
//                                if viewModel.privacyTermsAccepted {
//                                    viewModel.validatedPrivacy = .validated
//                                }
//                            } label: {
//                                Image(viewModel.privacyTermsAccepted ? "registration_checkmark_green_full" : "registration_checkmark_green_empty")
//                                    .resizable()
//                                    .frame(width: 20, height: 20)
//                            }
//                            .overlay(
//                                RoundedRectangle(cornerRadius: 3)
//                                    .stroke(viewModel.validatedPrivacy == .validated ? Color.clear : Color.myRed, lineWidth: 2)
//                            )
//                            Spacer()
//                        }
//
//                        HStack{
//                            Spacer().frame(width: 27)
//                            Text("With conditions  [User agreement](https://policies.google.com/terms?hl=en-US) and [Policy of confeditionity](https://policies.google.com/privacy?hl=en-US) familiarized")
//                                .font(.custom("Lato-Regular", size: 13))
//                                .lineLimit(3)
//                                .multilineTextAlignment(.center)
//                        }
//                    }
//                    .frame(width: wRatio(270), height: 40)
//                    .padding(.top, keyboardHeight == 0 ? wRatio(20) : wRatio(10))
//                    .padding(.bottom, keyboardHeight == 0 ? wRatio(20) : wRatio(10))
                    
                    
                    NavigationLink(isActive: $viewModel.willMoveToLogin) {
                        LoginView()
                    } label: {
                        Text("Already have account?")
                            .lineLimit(1)
                            .foregroundColor(.myGreen)
                            .font(.custom("Lato-Regular", size: 16))
                            .padding(.bottom, wRatio(28))
                    }
                  //  Spacer().frame(height: 50)
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
                            .frame(width: wRatio(270), height: 50)
                            
                            Text("Go!")
                                .lineLimit(1)
                                .foregroundColor(.white)
                                .font(.custom("Lato-ExtraBold", size: 26))
                        }
                    }
                    Spacer()
                    HStack {
                        Button {
                            showPrivacyWebView = true
                        } label: {
                             Text("Privacy policy")
                            .lineLimit(1)
                            .foregroundColor(.myGreen)
                            .font(.custom("Lato-Regular", size: 13))
                        }
                        Spacer().frame(width: 50)
                        Button {
                            showTermsWebView = true
                        } label: {
                             Text("Terms of use")
                                .lineLimit(1)
                                .foregroundColor(.myGreen)
                                .font(.custom("Lato-Regular", size: 13))
                        }
                    }
                }
            }
            .sheet(isPresented: $showTermsWebView) {
                WebView(url: URL(string: "https://www.app-privacy-policy.com/live.php?token=CtkKClEp0a49NTZdtC1zkswBXscvbBc7")!)
            }
            .sheet(isPresented: $showPrivacyWebView) {
                WebView(url: URL(string: "https://www.termsfeed.com/live/85a4e8c2-e755-43e8-a134-9226a6017dfe")!)
            }
            .navigationBarHidden(true)
            .onAppear() {
                viewModel.ref = Database.database().reference(withPath: "users")
            }
            .onReceive(Publishers.keyboardHeight) { value in
                withAnimation() {
                    self.keyboardHeight = value
                }
            }
            .overlay(overlayView: SnackBarView(show: $viewModel.showErrorMessage,
                                               model: SnackBarModel(type: .warning,
                                                                    text: viewModel.errorMessage,
                                                                    alignment: .leading,
                                                                    bottomPadding: 20)),
                     show: $viewModel.showErrorMessage,
                     ignoreSaveArea: false)
        
    }
    
    private var fieldsView: some View {
        VStack{
            TextField("Email", text: $viewModel.email, onEditingChanged: { changed in
                 viewModel.emailIsEditing = changed
                if viewModel.createAccountOnceTapped {
                    let _ = viewModel.inputValidated()
                }
              })
            
            .authTextField(isEditing: viewModel.emailIsEditing, vState: viewModel.correctEmail)
                .autocapitalization(.none)
            
          // Hidden
            Text(viewModel.correctEmail.message)
                .font(.custom("Lato-ExtraBold", size: 11))
                .foregroundColor(.red)
                .opacity(viewModel.correctEmail == .validated ? 0.0 : 1.0)
            
            HStack {
                if viewModel.isSecure {
                    TextField("Password", text: $viewModel.password , onEditingChanged: { changed in
                        viewModel.passwordIsEditing = changed
                      })
                     .secure(true)
                } else {
                    TextField("Password", text: $viewModel.password, onEditingChanged: { changed in
                        viewModel.passwordIsEditing = changed
                      })
                }
                Spacer()
                
                Button {
                    viewModel.isSecure.toggle()
                } label: {
                    Image(viewModel.isSecure ? "login_show_pass_ic" : "login_hidden_pass_ic")
                        .renderingMode(.template)
                        .foregroundColor(.green)
                }
            }
               
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
        .frame(width: wRatio(270))
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
        .frame(width: wRatio(270))
        
        
        
    }

}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
            .previewDevice(PreviewDevice(rawValue: "iPhone SE (3rd generation)"))
            .previewDisplayName("iPhone SE")
        
        RegistrationView()
            .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro"))
            .previewDisplayName("iPhone 14 Pro")
    }
}




