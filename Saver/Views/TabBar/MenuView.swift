//
//  Menu.swift
//  Saver
//
//  Created by Пришляк Дмитро on 20.08.2022.
//

import SwiftUI


struct MenuView: View {
    
    @Binding var selectedTab: Int
    @State private var urlImage: URL?
    @State private var userModelImage: UIImage?
    @State private var deleteAlertIsShowing = false
    
    var body: some View {
            VStack {
                Spacer().frame(height: 20)
                if  let img = userModelImage{
                    
                    Image(uiImage: img)
                        .resizable()
                        .frame(width: hRatio(250), height: hRatio(250))
                        .clipShape(Circle())
                } else {
                    Image("logo")
                        .resizable()
                        .frame(width: hRatio(250), height: hRatio(250))
                        .clipShape(Circle())
                }
                Spacer().frame(height: 18)
                Text(FirebaseUserManager.shared.userModel?.name ?? "Account_name")
                    .foregroundColor(.black)
                    .font(.custom("Lato-SemiBold", size: 26, relativeTo: .body))
                
                Spacer().frame(height: 30)
                
                Rectangle()
                .fill(LinearGradient(gradient: Gradient(colors: [Color(hex: "90DE58"), Color(hex: "5CCCCC")]), startPoint: .leading, endPoint: .trailing))
                .frame(height: 3)
                
                Spacer().frame(height: 30)
                
                Button {
                deleteAlertIsShowing.toggle()
                } label: {
                    ZStack {
                        Color.white
                            .frame(width: 220, height: 60)
                        HStack {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                            
                            Text("DELETE ACCOUNT")
                                .foregroundColor(.red)
                        }
                    }
                }
                Spacer()
            }
        .onChange(of: selectedTab) { newValue in
            guard userModelImage == nil else { return }
            DispatchQueue.global(qos: .userInteractive).async {
            guard let url = URL(string: FirebaseUserManager.shared.userModel!.avatarUrlString ) else { return }
                 do {
                     let data = try Data(contentsOf: url)
                     userModelImage = UIImage(data: data)
                 } catch let error {
                     print(error.localizedDescription) // -<
                 }
            }
        }
        .alert(isPresented: $deleteAlertIsShowing) {
            Alert(title: Text("Delete Account"),
                  message: Text("Are you sure you want to delete account? It will delete your progress in app and sign out you.") ,
                  primaryButton: .cancel(Text("Yes")) {
                FirebaseUserManager.shared.deleteUser()
            },
                  secondaryButton: .default(Text("No")))
        }
        
    }
}

