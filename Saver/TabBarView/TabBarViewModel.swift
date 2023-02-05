//
//  TabBarViewModel.swift
//  Saver
//
//  Created by Oleh Dovhan on 24.01.2023.
//

import Foundation
import Firebase

final class TabBarViewModel: ObservableObject {
    
    @Published var user: UserModel!
    
    private lazy var databasePath: DatabaseReference? = {
        let ref = Database.database().reference().child("users")
        return ref
    }()
    
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    func listentoRealtimeDatabase() {
        guard let databasePath = databasePath else {
            return
        }
        databasePath
            .observe(.childAdded) { [weak self] (snapshot,optString)  in
                guard
                    let self = self,
                    var json = snapshot.value as? [String: Any]
                else {
                    return
                }
                json["id"] = snapshot.key
                do {
                    let birdData = try JSONSerialization.data(withJSONObject: json)
                    let bird = try self.decoder.decode(UserModel.self, from: birdData)
                    self.user = bird
                } catch {
                    print("an error occurred", error)
                }
            }
    }
    
    func stopListening() {
        databasePath?.removeAllObservers()
    }
}


