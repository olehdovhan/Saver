//
//  ExtensionColor.swift
//  Saver
//
//  Created by Пришляк Дмитро on 21.08.2022.
//

import Foundation
import SwiftUI


extension Color {
    
    init(hex: UInt, alpha: Double = 1) {
           self.init(
               .sRGB,
               red: Double((hex >> 16) & 0xff) / 255,
               green: Double((hex >> 08) & 0xff) / 255,
               blue: Double((hex >> 00) & 0xff) / 255,
               opacity: alpha
           )
       }
    
    static let myGreen = Color(hex: 0x90DE58)
    static let myBlue = Color(hex: 0x5CCCCC)
    
}
