//
//  Modifiers and Extensions.swift
//  Saver
//
//  Created by Пришляк Дмитро on 21.08.2022.
//


import SwiftUI

struct ShadowCustom : ViewModifier{
    var radiusShadow: Int
    func body(content: Content) -> some View {
        content
            .shadow(color: .black.opacity(0.15), radius: CGFloat(radiusShadow), x: 0, y: 0)
    }
}

extension View {
    
    func myShadow(radiusShadow: Int) -> some View{
        modifier(ShadowCustom(radiusShadow: radiusShadow))
    }
    
    func draggable(zIndex: Binding<Double>, isAlertShow: Binding<Bool>, purchaseType: Binding<ExpenseCategory>, cashType: String , cashSource: Binding<String> ) -> some View {
        modifier(DragGestureCustom(zIndex: zIndex, isAlertShow: isAlertShow, purchaseType: purchaseType, cashType: cashType, cashSource: cashSource))
    }
}

struct DragGestureCustom: ViewModifier {
    
    @State var isDragging = false
    @State var currentOffsetX: CGFloat = 0
    @State var currentOffsetY: CGFloat = 0
    @Binding var zIndex: Double
    @Binding var isAlertShow: Bool
    @Binding var purchaseType: ExpenseCategory
    @State var cashType: String
    @Binding var cashSource: String
   
    var drag: some Gesture{
        DragGesture(coordinateSpace: .global)
            .onChanged({ value in
                withAnimation {
                    zIndex = 5
                    currentOffsetX = value.translation.width
                    currentOffsetY = value.translation.height
                    isDragging.toggle()
                }
                print(value.location.y)
               
            })
            .onEnded { gesture in
                var locs = PurchaseLocation.standard.locations
                
                for item in locs {
                    let startXRange = item.value.x - 35
                    let finisXRange = item.value.x + 35
                    let xRange = startXRange...finisXRange
                    
                    let startYRange = item.value.y - 35
                    let finishYRange = item.value.y + 35
                    let yRange = startYRange...finishYRange
                    
                    if xRange.contains(gesture.location.x) && yRange.contains(gesture.location.y) {
                        print(item.key.rawValue)
                        
                        switch item.key {
                        case .products: purchaseType = .products
                        case .transport: purchaseType = .transport
                        case .clouthing: purchaseType = .clothing
                        case .restaurant: purchaseType = .restaurant
                        }
                        cashSource = cashType
                        isAlertShow.toggle()
                    }
                }
                    
                if abs(gesture.location.x) > 49 && abs(gesture.location.x) < 95 && abs(gesture.location.y) > 419 && abs(gesture.location.y) < 470 {
                 
                    print("moped")
                    withAnimation(.spring()) {
                        zIndex = 1
                        isDragging.toggle()
                        currentOffsetX = 0
                        currentOffsetY = 0
                    }
                            
                } else {
                    withAnimation(.spring()) {
                        zIndex = 1
                        isDragging.toggle()
                        currentOffsetX = 0
                        currentOffsetY = 0
                    }
                }
          }
    }
//    let tapGesture =  TapGesture()
//                            .onEnded { value in
//                               print("Bank Card")
//                            }
//    
    func body(content: Content) -> some View {
              content
            .offset(x: currentOffsetX)
            .offset(y: currentOffsetY)
        
            .gesture(drag)
    }
}
//
//class AlertView: ObservableObject{
//    @Published var name = ""
//    @Published var imageName = ""
//
//}
