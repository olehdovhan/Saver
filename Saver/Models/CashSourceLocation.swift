//
//  CashSourceLocation.swift
//  Saver
//
//  Created by Oleh on 17.02.2023.
//

import Foundation

struct CashSourceLocation {
    
    var locations: [String: CGPoint]
    
    static var standard = CashSourceLocation(locations: [String : CGPoint]())
    
}
