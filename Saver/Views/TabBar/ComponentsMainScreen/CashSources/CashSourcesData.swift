//
//  CashSourcesData.swift
//  Saver
//
//  Created by Pryshliak Dmytro on 30.12.2022.
//

import Foundation

class CashSourcesData: ObservableObject {
    
    private var cashSources: [CashSource] {
        if let sources = UserDefaultsManager.shared.userModel?.cashSources {
            
            return sources
        } else {
            return [CashSource]()
        }
    }
    
    private var primary: CashSource {
        cashSources.first!
    }
    
}
