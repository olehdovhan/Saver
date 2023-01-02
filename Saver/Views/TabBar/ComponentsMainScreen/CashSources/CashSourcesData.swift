//
//  CashSourcesData.swift
//  Saver
//
//  Created by Pryshliak Dmytro on 30.12.2022.
//

import Foundation

class CashSourcesData: ObservableObject {
    
    var cashSources: [CashSource] {
        if let sources = UserDefaultsManager.shared.userModel?.cashSources {
            
            return sources
        } else {
            return [CashSource]()
        }
    }
    
    var primary: CashSource {
        cashSources.first!
    }
    
//    init(){
//
//    }
    
    
    
}
