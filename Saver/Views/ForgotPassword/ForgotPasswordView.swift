//
//  ForgotPasswordView.swift
//  Saver
//
//  Created by Pryshliak Dmytro on 15.01.2023.
//

import SwiftUI

struct ForgotPasswordView: View{
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject private var viewModel = ForgotPasswordViewModel()
    
    @State private var email = ""
    
    var body: some View{
            ZStack {
                GeometryReader { reader in
                    Color.myGreen
                        .frame(
                            height: reader.safeAreaInsets.top,
                            alignment: .top)
                        .ignoresSafeArea()
                    
                }
                Rectangle()
                    .fill(Color.white)
                    .frame(
                        maxWidth: .infinity,
                           maxHeight: .infinity)
                    .onTapGesture {
                        UIApplication.shared.sendAction(
                            #selector(UIResponder.resignFirstResponder),
                            to: nil,
                            from: nil,
                            for: nil)
                    }
                
                VStack(spacing: 0){
                    
                    Spacer()
                    
                    Image("logo")
                        .resizable()
                        .frame(width: 150, height: 150)
                        .padding(.bottom, wRatio(60))
                    
                    Text("Restore acces")
                        .lineLimit(1)
                        .foregroundColor(.myGrayDark)
                        .font(FontType.latoRegular.font(size: 18))
                        .padding(.bottom, wRatio(30))
                    
                    Text("Enter the email address specified during registration")
                        .lineLimit(2)
                        .foregroundColor(.myGrayDark)
                        .font(FontType.latoRegular.font(size: 14))
                        .padding(.bottom, wRatio(30))
                    
                    fieldsView
                        .padding(.bottom, wRatio(60))
                    
                    Button{
                        viewModel.resetEmail(email: viewModel.email) {
                            presentationMode.wrappedValue.dismiss()
                        }
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 10).fill(
                                LinearGradient(colors: [.myGreen, .myBlue],
                                               startPoint: .leading,
                                               endPoint: .trailing)
                            )
                            .frame(
                                width: wRatio(250),
                                height: 50)
                            
                            Text("Proceed!")
                                .lineLimit(1)
                                .foregroundColor(.white)
                                .font(FontType.latoExtraBold.font(size: 26))
                        }
                        
                    }
                    .padding(.bottom, wRatio(30))
                    
                    Spacer()

                }
            }
            .navigationBarBackButtonHidden(true)
           
    }
    
    private var fieldsView: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            TextField("Email", text: $viewModel.email, onEditingChanged: { changed in
                 viewModel.emailIsEditing = changed
                if viewModel.createAccountOnceTapped {
                    let _ = viewModel.inputValidated()
                }
              })
            .frame(width: wRatio(250))
            .authTextField(
                isEditing: viewModel.emailIsEditing,
                vState: viewModel.correctEmail)
            .autocapitalization(.none)
            .keyboardType(.emailAddress)
            
          // Hidden
            Text(viewModel.correctEmail.message)
                .font(FontType.latoExtraBold.font(size: 11))
                .foregroundColor(.red)
                .opacity(viewModel.correctEmail == .validated ? 0.0 : 1.0)
        }
    }
}

