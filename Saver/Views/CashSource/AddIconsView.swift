//
//  IconsCashSourceView.swift
//  Saver
//
//  Created by Oleh Dovhan on 13.12.2022.
//

import SwiftUI

enum AddIconsType {
    case cashSource, purchaseCategory
}

struct AddIconsView: View {
    
   @Binding var closeSelf: Bool
    
    var type: AddIconsType
    
    var closure: (String) -> ()
    
   @State var data: [String] = []
    
    var sortedDate: [String] {
        
        switch type {
        case .cashSource:
            if let existedIcons = UserDefaultsManager.shared.userModel?.cashSources.map {$0.iconName} {
              var dataCopy = data
                for exist in existedIcons {
                    if let existedItem = dataCopy.firstIndex(of: exist) {
                        dataCopy.remove(at: existedItem)
                    }
                }
                return dataCopy
            } else { return data }

        case .purchaseCategory:
            if let existedIcons = UserDefaultsManager.shared.userModel?.purchaseCategories.map {$0.iconName} {
              var dataCopy = data
                for exist in existedIcons {
                    if let existedItem = dataCopy.firstIndex(of: exist) {
                        dataCopy.remove(at: existedItem)
                    }
                }
                return dataCopy
            } else { return data }
        }
    }

    let columns = [ GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()) ]

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color.cyan)
                .frame(width: 260, height: 260)
            ScrollView {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(sortedDate, id: \.self) { item in
                        
                        Button {
                            closeSelf.toggle()
                            closure(item)
                        } label: {
                            
                            switch item {
                            case "iconBankCard", "iconWallet" ,"iconProducts",
                                "iconTransport",
                                "iconClothing",
                                "iconRestaurant",
                                "iconHousehold",
                                "iconEntertainment",
                                "iconHealth" :          Image(item)
                                                                            .resizable()
                                                                            .frame(width: 60, height: 60)
                            default:          Image(systemName: item)
                                                    .resizable()
                                                    .frame(width: 60, height: 60)
                                                    .foregroundColor(.white)
                            }
                        }
                    }
                }
            }
            .frame(width: 220, height: 220)
        }
        .onAppear() {
            switch type {
            case .cashSource: data = ["iconBankCard",
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
                
            case .purchaseCategory: data = ["iconProducts",
                                            "iconTransport",
                                            "iconClothing",
                                            "iconRestaurant",
                                            "iconHousehold",
                                            "iconEntertainment",
                                            "iconHealth",
                                            "beach.umbrella",
                                            "water.waves",
                                            "globe.europe.africa",
                                            "figure.cooldown",
                                            "figure.core.training",
                                            "figure.skiing.crosscountry",
                                            "sportscourt.fill",
                                            "car.fill",
                                            "studentdesk",
                                            "play.desktopcomputer",
                                            "gift.fill",
                                            "book",
                                            "figure.2.and.child.holdinghands"]
            }
        }
    }
}
