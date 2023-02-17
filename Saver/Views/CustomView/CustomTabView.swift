//
//  CustomTabView.swift
//  Saver
//
//  Created by Пришляк Дмитро on 21.08.2022.
//

import SwiftUI

struct TabItemPreferenceKey: PreferenceKey{
    static var defaultValue: [TabItem] = []
    static func reduce(value: inout [TabItem], nextValue: () -> [TabItem]) {
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
    @Binding var isShow: Bool
    @State private var tabs: [TabItem] = [
        .init(text: "Home", icon: "tabIcon0"),
        .init(text: "Star", icon: "tabIcon1")
    ]
    @Namespace  private var tabBarItem
    
    private var content: Content
    
    var body: some View{
        ZStack(alignment: .bottom){
            content
            HStack{
                tabsView
            }
            
            .frame(width: UIScreen.main.bounds.width, height: wRatio(90))
            .background(Color.white.ignoresSafeArea(edges: .bottom))
            .cornerRadius(20, corners: [.topLeft, .topRight])
            .shadow(color: Color.gray, radius: 15, x: 0, y: 0)
            .opacity(isShow ? 1 : 0.0)
        }
        .onPreferenceChange(TabItemPreferenceKey.self) { value in
            self.tabs = value
        }
    }
    
    init(selection: Binding<Int>, isShow: Binding<Bool>, @ViewBuilder content: () -> Content) {
        self.content = content()
        _selection = selection
        _isShow = isShow
    }
    
    private var tabsView: some View{
        ForEach(Array(tabs.enumerated()), id: \.offset) { index, element in
            Spacer()
                Image(element.icon)
            .background(
                ZStack{
                    if selection == index {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(.green.opacity(0.3))
                            .frame(width: wRatio(80), height: wRatio(80))
                            .matchedGeometryEffect(id: "tabBarItem", in: tabBarItem)
                    }
                }

            )
            .onTapGesture {
                withAnimation(Animation.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0.7)) {
                    selection = index
                }
            }
            Spacer()
        }
    }
    
    
}

struct CustomTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen(isShowTabBar: .constant(true))
            .previewDevice(PreviewDevice(rawValue: "iPhone SE (3rd generation)"))
            .previewDisplayName("iPhone SE")
        
        MainScreen(isShowTabBar: .constant(true))
            .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro"))
            .previewDisplayName("iPhone 14 Pro")
    }
}
