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
    
    func myShadow(radiusShadow: Int) -> some View {
        modifier(ShadowCustom(radiusShadow: radiusShadow))
    }
    
    func draggable(zIndex: Binding<Double>,
                   isAlertShow: Binding<Bool>,
                   purchaseType: Binding<String>,
                   cashType: String ,
                   cashSource: Binding<String>,
                   dragging: Binding<Bool>) -> some View {
        modifier(DragGestureCustom(zIndex: zIndex, isAlertShow: isAlertShow, purchaseType: purchaseType, cashType: cashType, cashSource: cashSource, dragging: dragging))
    }
}

struct DragGestureCustom: ViewModifier {
    
    @State var isDragging = false
    @State var currentOffsetX: CGFloat = 0
    @State var currentOffsetY: CGFloat = 0
    @Binding var zIndex: Double
    @Binding var isAlertShow: Bool
    @Binding var purchaseType: String
    @State var cashType: String
    @Binding var cashSource: String
    @Binding var dragging: Bool
   
    var drag: some Gesture{
        DragGesture(coordinateSpace: .global)
            .onChanged({ value in
                dragging = true
                withAnimation {
                    zIndex = 5
                    currentOffsetX = value.translation.width
                    currentOffsetY = value.translation.height
                    isDragging.toggle()
                }
                print(value.location.y)
               
            })
            .onEnded { gesture in
                dragging = false
                var locs = PurchaseLocation.standard.locations
                
                for item in locs {
                    let startXRange = item.value.x - 35
                    let finisXRange = item.value.x + 35
                    let xRange = startXRange...finisXRange
                    
                    let startYRange = item.value.y - 35
                    let finishYRange = item.value.y + 35
                    let yRange = startYRange...finishYRange
                    
                    if xRange.contains(gesture.location.x) && yRange.contains(gesture.location.y) {
//                        print(item.key.rawValue)
                        
//                        switch item.key {
//                        case .products: purchaseType = "Products"
//                        case .transport: purchaseType = "Transport"
//                        case .clouthing: purchaseType = "Clothing"
//                        case .restaurant: purchaseType = "Restaurant"
//                        }
                        purchaseType = item.key
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
                
                currentOffsetX = 0
                currentOffsetY = 0
          }
    }
    
    func body(content: Content) -> some View {
              content
            .offset(x: currentOffsetX)
            .offset(y: currentOffsetY)
            .gesture(drag)
    }
}






extension View {
    func delaysTouches(for duration: TimeInterval = 0.25, onTap action: @escaping () -> Void = {}) -> some View {
        modifier(DelaysTouches(duration: duration, action: action))
    }
}

fileprivate struct DelaysTouches: ViewModifier {
    @State private var disabled = false
    @State private var touchDownDate: Date? = nil

    var duration: TimeInterval
    var action: () -> Void

    func body(content: Content) -> some View {
        Button(action: action) {
            content
        }
        .buttonStyle(DelaysTouchesButtonStyle(disabled: $disabled, duration: duration, touchDownDate: $touchDownDate))
        .disabled(disabled)
    }
}

fileprivate struct DelaysTouchesButtonStyle: ButtonStyle {
    @Binding var disabled: Bool
    var duration: TimeInterval
    @Binding var touchDownDate: Date?

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .onChange(of: configuration.isPressed, perform: handleIsPressed)
    }

    private func handleIsPressed(isPressed: Bool) {
        if isPressed {
            let date = Date()
            touchDownDate = date
            
            DispatchQueue.main.asyncAfter(deadline: .now() + max(duration, 0)) {
                if date == touchDownDate {
                    disabled = true
                    
                    DispatchQueue.main.async {
                        disabled = false
                    }
                }
            }
        } else {
                    touchDownDate = nil
                    disabled = false
                }
            }
        }
