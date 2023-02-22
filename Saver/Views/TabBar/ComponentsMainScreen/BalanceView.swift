//
//  BalanceView.swift
//  Saver
//
//  Created by Пришляк Дмитро on 21.08.2022.
//

import SwiftUI

struct BalanceView: View {
    
    @State var isDragging = false
    @Binding var showQuitAlert: Bool
    
//  @Binding var showImageCropper: Bool
    @Binding var sourceType: UIImagePickerController.SourceType //
    @Binding var selectedImage: UIImage? //
    @Binding var isImagePickerDisplay: Bool //
    @Binding var urlImage: URL?
    @State var userModelImage: UIImage?
    
    var body: some View {
        ZStack{
            ZStack{
                LinearGradient(colors: [.myGreen, .myBlue],
                               startPoint: .top,
                               endPoint: .bottom )
                .frame(width: UIScreen.main.bounds.width, height: hRatio(130), alignment: .top)
                .cornerRadius(30, corners: [.bottomLeft, .bottomRight])
                
                VStack(){
                    Spacer().frame(height: 20)
                    HStack(){
                        VStack{
                            Button {
                                showQuitAlert = true
                            } label: {
                                Text("Log Out")
                            }
                            Button {
                                sourceType = .photoLibrary
                                isImagePickerDisplay.toggle()
                            } label: {
                                if  let img = userModelImage{
                                    Image(uiImage: img)
                                        .resizable()
                                        .frame(width: hRatio(50), height: hRatio(50))
                                        .foregroundColor(.white)
                                } else if selectedImage != nil{
                                    Image(uiImage: selectedImage!)
                                        .resizable()
                                        .frame(width: hRatio(50), height: hRatio(50))
                                        .clipShape(Circle())
                                }
                            }
                        }
                        Spacer()
                        VStack{
                            Text("Balance")
                                .foregroundColor(.white)
                                .font(.custom("Lato-SemiBold", size: 16, relativeTo: .body))
                            
                            Text("+45.000")
                                .foregroundColor(.white)
                                .font(.custom("Lato-Bold", size: 16, relativeTo: .body))
                        }
                        .onTapGesture {
                            print("AAA locations: \(CashSourceLocation.standard.locations)")
                        }
                        
                        Spacer()
                        VStack{
                            Text("Expence")
                                .foregroundColor(.white)
                                .font(.custom("Lato-SemiBold", size: 16, relativeTo: .body))
                            
                            Text("15.250")
                                .foregroundColor(.white)
                                .font(.custom("Lato-Bold", size: 16, relativeTo: .body))
                        }
                    }
                    
                    HStack(){
                        if let user = FirebaseUserManager.shared.userModel {
                            Text("\(user.name)")
                                .foregroundColor(.white)
                                .font(.custom("Lato-SemiBold", size: 16, relativeTo: .body))
                                .lineLimit(1)
                        }
                        Spacer()
                    }
                }
                .padding(.leading, 30)
                .padding(.trailing, 30)
            }
            .onChange(of: urlImage, perform: { newValue in
               if let url = urlImage {
                    do {
                        let data = try Data(contentsOf: url)
                        userModelImage = UIImage(data: data)
                    } catch let error {
                        print(error.localizedDescription)
                    }
                    //userModelImage = UIImage(data: Data(contentsOf: url))
                }
            })
        }
    }
}

struct BalanceView_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen(isShowTabBar: .constant(true))
            .previewDevice(PreviewDevice(rawValue: "iPhone SE (3rd generation)"))
            .previewDisplayName("iPhone SE")
        
        MainScreen(isShowTabBar: .constant(true))
            .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro"))
            .previewDisplayName("iPhone 14 Pro")
    }
}
