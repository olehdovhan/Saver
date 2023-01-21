//
//  TextField+Extension.swift
//  Saver
//
//  Created by Pryshliak Dmytro on 14.01.2023.
//

import SwiftUI

extension TextField {
    
    public func secure(_ secure: Bool = true) -> TextField {
        if secure {
            var secureField = self
            withUnsafeMutablePointer(to: &secureField) { pointer in
                let offset = 32
                let valuePointer = UnsafeMutableRawPointer(mutating: pointer)
                    .assumingMemoryBound(to: Bool.self)
                    .advanced(by: offset)
                valuePointer.pointee = true
            }
            return secureField
        } else {
            return self
        }
    }
}
