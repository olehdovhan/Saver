//
//  RegistrationTFState.swift
//  Saver
//
//  Created by Pryshliak Dmytro on 14.01.2023.
//

import Foundation

import Foundation


enum RegistrationTFState: Equatable {
    case validated
    case empty
    case lessThanLetters(count: Int)
    case lessThanSymbols(count: Int)
    case lessThanNumbers(count: Int)
    case incorrectEmailFormat
    case passwordsDoNotMatch
    
    var message: String {
        switch self {
        case .validated:                   return ""
        case .empty:                       return "The field cannot be empty"
        case .lessThanLetters(let count):  return "Less than \(count) letters per field"
        case .lessThanSymbols(let count):  return "Less than \(count) characters"
        case .lessThanNumbers(let count):  return "Less than \(count) digits"
        case .incorrectEmailFormat:        return "Wrong format"
        case .passwordsDoNotMatch:         return "Passwords do not match"
        }
    }
}
