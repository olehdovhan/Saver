//
//  ExtensionColor.swift
//  Saver
//
//  Created by Пришляк Дмитро on 21.08.2022.
//

import SwiftUI

// MARK: - ColorModifier
extension Color {
    static let myGreen = Color(hex: "#90DE58")
    static let myBlue = Color(hex: "#5CCCCC")
    static let myRed = Color(hex: "#FF2230")
    static let myGrayDark = Color(hex: "#595959")
    static let myGrayLight = Color(hex: "#C4C4C4")
    static let myGradeBlue = Color(hex: "#5CCCCC")
    static let myGradeGreen = Color(hex: "#4CD964")
    static let myGradeLilac = Color(hex: "#E6399B")
    
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
