//
//  PurchaseLocation.swift
//  Saver
//
//  Created by O l e h on 29.08.2022.
//

import SwiftUI

struct PurchaseLocation {
    
    var locations: [String: CGPoint]
    
    static var standard = PurchaseLocation(locations: [String : CGPoint]())
    
}
