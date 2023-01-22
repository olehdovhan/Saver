//
//  Font.swift
//  Saver
//
//  Created by Pryshliak Dmytro on 21.01.2023.
//

import SwiftUI
import UIKit

enum FontType: String {
    case notoSBold = "NotoSans-Bold"
    case notoSExtraBold = "NotoSans-ExtraBold"
    case notoSRegular = "NotoSans-Regular"
    case notoSSemiBold = "NotoSans-SemiBold"
    case notoSDMedium = "NotoSansDisplay-Medium"
    
    case latoBold = "Lato-Bold"
    case latoExtraBold = "Lato-ExtraBold"
    case latoMedium = "Lato-Medium"
    case latoRegular = "Lato-Regular"
    case latoSemibold = "Lato-Semibold"
}

// MARK: - FontTypeModifier
extension FontType {
    
    func font(size: CGFloat) -> Font {
        return Font.custom(self.rawValue, fixedSize: size)
    }
    
    func uiFont(size: CGFloat) -> UIFont {
        return UIFont(name: self.rawValue, size: size)!
    }
}
