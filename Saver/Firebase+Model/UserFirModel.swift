//
//  UserFirModel.swift
//  Saver
//
//  Created by Oleh Dovhan on 23.01.2023.
//

import Foundation
import Firebase

struct UserFirModel {
    let uid: String
    let email: String
    
    init(user: User) {
        self.uid = user.uid
        self.email = user.email!
    }
}
