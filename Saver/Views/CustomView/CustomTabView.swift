//
//  CustomTabView.swift
//  Saver
//
//  Created by Пришляк Дмитро on 21.08.2022.
//

import SwiftUI

struct TabItemPreferenceKey: PreferenceKey{
    static var defaultValue: [TabItem] = []
    static func reduce(
        value: inout [TabItem],
        nextValue: () -> [TabItem]
    ) {
        value += nextValue()
    }
}

struct TabItemModifier: ViewModifier{
    let tabBarItem: TabItem

    func body(content: Content) -> some View {
        content
            .preference(key: TabItemPreferenceKey.self, value: [tabBarItem])
    }

}

// MARK: - CustomTabItem
extension View{
    func myTabItem(_ label: () -> TabItem) -> some View{
        modifier(TabItemModifier(tabBarItem: label()))
    }
}

struct TabItem: Identifiable, Equatable{
    var id = UUID()
    var text: String
    var icon: String
}

struct CustomTabView<Content: View>: View{
    @Binding var selection: Int
    @State private var tabs: [TabItem] = [
        .init(text: "Home", icon: "tabIcon0"),
//        .init(text: "Star", icon: "tabIcon1")
    ]
    @Namespace  private var tabBarItem
    
    private var content: Content
    
    var body: some View{
        ZStack(alignment: .bottom){
            content
            HStack{
                tabsView
            }
            
            .frame(width: Screen.width, height: 140, alignment: .top)
            .padding(.vertical, 5)
            .background(Color.white.ignoresSafeArea(edges: .bottom))
            .cornerRadius(20)
            .offset( y: 80)
            .shadow(color: Color.gray, radius: 15, x: 0, y: 0)
        }
        .onPreferenceChange(TabItemPreferenceKey.self) { value in
            self.tabs = value
        }
    }
    
    init(selection: Binding<Int>, @ViewBuilder content: () -> Content) {
        self.content = content()
        _selection = selection
    }
    
    private var tabsView: some View{
        ForEach(Array(tabs.enumerated()), id: \.offset) { index, element in
            Spacer()
            VStack(spacing: 5) {
                Image(element.icon)
                Text(element.text)
                    .font(.system(size: 10))
            }
            .foregroundColor(selection == index ? .black : .green)
            .background(
                ZStack{
                    if selection == index {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.green.opacity(0.3))
                            .frame(width: 60, height: 60, alignment: Alignment.top)
                            .offset(y: -10)
                            .matchedGeometryEffect(id: "tabBarItem", in: tabBarItem)
                    }
                }

            )
            .onTapGesture {
                withAnimation(Animation.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0.7)) {
                    selection = index
                    print(index)
                }
            }
            Spacer()
        }
    }
    
    
}
