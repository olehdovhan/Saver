//
//  ForgotPasswordView.swift
//  Saver
//
//  Created by Pryshliak Dmytro on 15.01.2023.
//


import SwiftUI
import Combine

struct ForgotPasswordView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject private var viewModel = ForgotPasswordViewModel()
    @State private var keyboardHeight: CGFloat = 0
    
    
    var body: some View{
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
                    
                    Spacer()
                    
                    Image("logo")
                        .resizable()
                        .frame(width: keyboardHeight == 0 ? wRatio(150) : wRatio(75),
                               height: keyboardHeight == 0 ? wRatio(150) : wRatio(75))
                        .padding(.top, keyboardHeight == 0 ? 0 : wRatio(10))
                        .padding(.bottom, keyboardHeight == 0 ? wRatio(60) : wRatio(10))
                    
                    Text("Restore acces")
                        .lineLimit(1)
                        .foregroundColor(.myGrayDark)
                        .font(.custom("Lato-Regular", size: 18))
                        .padding(.bottom, wRatio(30))
                    
                    Text("Enter the email address specified during registration")
                        .lineLimit(2)
                        .foregroundColor(.myGrayDark)
                        .font(.custom("Lato-Regular", size: 14))
                        .padding(.bottom, wRatio(30))
                    
                    fieldsView
                        .padding(.bottom, keyboardHeight == 0 ? wRatio(60) : wRatio(20))
                    
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
                            .frame(width: wRatio(270), height: 50)
                            
                            Text("Continue!")
                                .lineLimit(1)
                                .foregroundColor(.white)
                                .font(.custom("Lato-ExtraBold", size: 26))
                        }
                        
                    }
                    .padding(.bottom, wRatio(30))
                    
                    Spacer()
                  
                }
            }
            .onReceive(Publishers.keyboardHeight) { value in
                withAnimation() {
                    self.keyboardHeight = value
                }
                
                
            }
            .keyboardAdaptive()
          
        
    }
    
    private var fieldsView: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            TextField("Email", text: $viewModel.email, onEditingChanged: { changed in
                 viewModel.emailIsEditing = changed
                if viewModel.createAccountOnceTapped {
                    let _ = viewModel.inputValidated()
                }
              })
            
            .authTextField(isEditing: viewModel.emailIsEditing, vState: viewModel.correctEmail)
            .autocapitalization(.none)
            .keyboardType(.emailAddress)
            
          // Hidden
            Text(viewModel.correctEmail.message)
                .font(.custom("Lato-ExtraBold", size: 11))
                .foregroundColor(.red)
                .opacity(viewModel.correctEmail == .validated ? 0.0 : 1.0)
        }
        .frame(width: wRatio(270))
    }
    
    
}


struct RegistrationView_ForgotPasswordView: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView()
            .previewDevice(PreviewDevice(rawValue: "iPhone SE (3rd generation)"))
            .previewDisplayName("iPhone SE")
        
        ForgotPasswordView()
            .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro"))
            .previewDisplayName("iPhone 14 Pro")
    }
}
