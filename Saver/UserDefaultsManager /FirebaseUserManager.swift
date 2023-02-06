//
//  UserDefaultsManager.swift
//  Saver
//
//  Created by Oleh Dovhan on 04.12.2022.
//

import SwiftUI
import Firebase

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
                
                guard let value = dataSnapshot.value as? [String: AnyObject] else { return }
                if let data = value.jsonData {
                    do {
                        self?.userModel =  try JSONDecoder().decode(UserModel.self, from: data)
                        completion()
                    } catch {
                        print("decodable error")
                    }
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



