//
//  UserDefaultsManager.swift
//  Saver
//
//  Created by Oleh Dovhan on 04.12.2022.
//

import SwiftUI
import Firebase
import FirebaseCore

final class FirebaseUserManager {
    
    var firUser: UserFirModel!
    var userRef: DatabaseReference!
    var userModel: UserModel? {
        didSet{
            updateUser(userModel)
        }
    }
    
    func observeUser(completion: @escaping (() -> ()) ) {
        if let currentUser = Auth.auth().currentUser {
            firUser = UserFirModel(user: currentUser)
            
            userRef = Database.database().reference(withPath: "users").child(firUser.uid).child("userDataModel")
            
            userRef.observe(.value) { [weak self] dataSnapshot in
                if dataSnapshot.exists() {
                    guard let value = dataSnapshot.value as? [String: AnyObject] else { return }
                    if let data = value.jsonData {
                        do {
                            self?.userModel =  try JSONDecoder().decode(UserModel.self, from: data)
                            completion()
                        } catch {
                            print("decodable error")
                        }
                    }
                } else {
                  //  let user
                    let dataUserModel =  UserModel(avatarImgName: "person.circle",
                                                   name: "Noname user",
                                                   email: self?.firUser.email  ?? "no Email",
                                                   registrationDate: Int(Date().millisecondsSince1970),
                                                   cashSources: [CashSource(name: "Bank card",
                                                                            amount: 0.0,
                                                                            iconName: "iconBankCard"),
                                                                 CashSource(name: "Wallet",
                                                                            amount: 0.0,
                                                                            iconName: "iconWallet")],
                                                   purchaseCategories: [PurchaseCategory(name: "Products",iconName: "iconProducts"),
                                                                        PurchaseCategory(name: "Transport", iconName: "iconTransport"),
                                                                        PurchaseCategory(name: "Clothing", iconName: "iconClothing"),
                                                                        PurchaseCategory(name: "Restaurant",iconName: "iconRestaurant"),
                                                                        PurchaseCategory(name: "Household", iconName: "iconHousehold"),
                                                                        PurchaseCategory(name: "Entertainment", iconName: "iconEntertainment"),
                                                                        PurchaseCategory(name: "Health", iconName: "iconHealth")])
                    Database.database().reference(withPath: "users").child((self?.firUser.uid)!).setValue(["userDataModel": dataUserModel.createDic()])
                }
            }
        }
    }
    
    static var shared: FirebaseUserManager = {
        let manager = FirebaseUserManager()
        return manager
    }()
    
    func updateUser(_ model: UserModel?) {
        if let model = model {
            Database.database().reference(withPath: "users").child(firUser.uid).setValue(["userDataModel": model.createDic()])
        }
    }
    
    private init () { }
}

extension FirebaseUserManager: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}



