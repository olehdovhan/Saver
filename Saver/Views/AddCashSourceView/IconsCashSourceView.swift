//
//  IconsCashSourceView.swift
//  Saver
//
//  Created by Oleh Dovhan on 13.12.2022.
//

import SwiftUI

struct IconsCashSourceView: View {
    
    @Binding var closeSelf: Bool
    var closure: (String) -> ()
    
    let data = ["iconBankCard",
                "iconWallet",
                "briefcase",
                "case",
                "dollarsign",
                "dollarsign.square",
                "dollarsign.square.fill",
                "dollarsign.arrow.circlepath",
                "banknote",
                "eurosign.circle",
                "bitcoinsign.circle"]
    
    var sortedDate: [String] {
        if let existedIcons = UserDefaultsManager.shared.userModel?.cashSources.map {$0.iconName} {
          var dataCopy = data
            for exist in existedIcons {
                if let existedItem = dataCopy.firstIndex(of: exist) {
                    dataCopy.remove(at: existedItem)
                }
            }
            return dataCopy
        } else { return data }
    
    }

    let columns = [ GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()) ]

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color.cyan)
                .frame(width: 260, height: 260)
            ScrollView {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(data, id: \.self) { item in
                        Button {
                            closeSelf.toggle()
                            closure(item)
                        } label: {
                            Image(systemName:item)
                                .resizable()
                                .frame(width: 60, height: 60)
                                .foregroundColor(.white)
                        }
                    }
                }
            }
            .frame(width: 220, height: 220)
        }
    }
}