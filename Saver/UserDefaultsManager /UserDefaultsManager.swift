//
//  UserDefaultsManager.swift
//  Saver
//
//  Created by Oleh Dovhan on 04.12.2022.
//

import SwiftUI


class UserDefaultsManager {
    
    var userModel: UserModel? {
        get {
            if let data = UserDefaults.standard.data(forKey: "UserModel") {
                do {
                    let decoder = JSONDecoder()
                    let userModels = try decoder.decode(UserModel.self, from: data)
                    return userModels
                } catch { print("Unable to Decode UserModels (\(error))")}
            }
            return nil
        }
        set {
            do {
                let encoder = JSONEncoder()
                let data = try encoder.encode(newValue)
                UserDefaults.standard.set(data, forKey: "UserModel")
            } catch { print("Unable to Encode Note (\(error))") }
        }
    }
    
    static var shared: UserDefaultsManager {
        return UserDefaultsManager()
    }
    private init () { }
}

// MARK: - NSCopying
extension UserDefaultsManager: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}



