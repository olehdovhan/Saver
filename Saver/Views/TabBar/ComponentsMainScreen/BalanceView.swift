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
    @Binding var sourceType: UIImagePickerController.SourceType //
    @Binding var selectedImage: UIImage? //
    @Binding var isImagePickerDisplay: Bool //
    @Binding var urlImage: URL?
    @State var userModelImage: UIImage?
    @Binding var userName: String
    @Binding var totalIncome: Double
    @Binding var totalExpense: Double
    @Binding var avatarIsChanging: Bool
    
    var body: some View {
        ZStack{
            ZStack{
                LinearGradient(colors: [.myGreen, .myBlue],
                               startPoint: .top,
                               endPoint: .bottom )
                .frame(width: UIScreen.main.bounds.width, height: hRatio(130), alignment: .top)
                .cornerRadius(30, corners: [.bottomLeft, .bottomRight])
                
                VStack(spacing: 0){
                    HStack(){
                        VStack(spacing: hRatio(15)){
                            Button {
                                showQuitAlert = true
                            } label: {
                                ZStack {
                                    Color.white.opacity(0.0025)
                                        .frame(width: hRatio(50), height: hRatio(30))
                                    Image(systemName: "rectangle.portrait.and.arrow.right")
                                        .resizable()
                                        .frame(width: hRatio(20), height: hRatio(20))
                                        .foregroundColor(.white)
                                        .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                                }
                            }
                            
                            Button {
                                sourceType = .photoLibrary
                                isImagePickerDisplay.toggle()
                            } label: {
                                ZStack {
                                    if let img = userModelImage {
                                        Image(uiImage: img)
                                            .resizable()
                                            .frame(width: hRatio(50), height: hRatio(50))
                                            .clipShape(Circle())
                                    } else {
                                        Image("logo")
                                            .resizable()
                                            .frame(width: hRatio(50), height: hRatio(50))
                                            .clipShape(Circle())
                                    }
                                    ZStack{
                                        Color.white
                                        ProgressView()
                                    }
                                    .frame(width: hRatio(50), height: hRatio(50))
                                    .clipShape(Circle())
                                    .opacity(avatarIsChanging ? 1 : 0)
                                }
                            }
                        }
                        Spacer()
                        VStack{
                            Text("Balance")
                                .foregroundColor(.white)
                                .font(.custom("Lato-SemiBold", size: 16, relativeTo: .body))
                            
                            Text("\(totalIncome.formatted()) \(Locale.current.currencyCode ?? "USD")")
                                .foregroundColor(.white)
                                .font(.custom("Lato-Bold", size: 16, relativeTo: .body))
                        }
                        
                        Spacer()
                        VStack{
                            Text("Expense")
                                .foregroundColor(.white)
                                .font(.custom("Lato-SemiBold", size: 16, relativeTo: .body))
                            
                            Text("\(totalExpense.formatted()) \(Locale.current.currencyCode ?? "USD")")
                                .foregroundColor(.white)
                                .font(.custom("Lato-Bold", size: 16, relativeTo: .body))
                        }
                    }
                    HStack(){
                            Text("\(userName)")
                                .foregroundColor(.white)
                                .font(.custom("Lato-SemiBold", size: 16, relativeTo: .body))
                                .lineLimit(1)
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
                        print(error.localizedDescription) // -<
                    }
                    //userModelImage = UIImage(data: Data(contentsOf: url))
                }
            })
            .onAppear(){
                print(userModelImage) //nil
                print(selectedImage) //nil
                print(urlImage)
            }
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

