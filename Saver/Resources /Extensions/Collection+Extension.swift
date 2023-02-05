//
//  Collection+Extension.swift
//  Saver
//
//  Created by Oleh Dovhan on 05.02.2023.
//

import Foundation

extension Collection {
    //Designed for use with Dictionary and Array types
    var jsonData: Data? {
        return try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
    }
}
