//
//  Modifiers and Extensions.swift
//  Saver
//
//  Created by Пришляк Дмитро on 21.08.2022.
//

import SwiftUI
import Combine

fileprivate let wScreen = 390.0
fileprivate let hScreen = 844.0

struct GetLocationCashSourcesModifier: ViewModifier{
    var source: CashSource
    var offset: CGFloat
    
    func body(content: Content) -> some View {
        
        content
            .overlay(
                GeometryReader { geo in
                    Color.clear
                        .onAppear {
                            updateLocation(proxy: geo)
                            
                        }
                        .onChange(of: offset) { newValue in
                            updateLocation(proxy: geo)
                        }
                }
            )
    }
    
    fileprivate func updateLocation(proxy: GeometryProxy) {
        let location = CGPoint(x: proxy.frame(in: .global).midX,
                               y: proxy.frame(in: .global).midY)
        CashSourceLocation.standard.locations[source.name] = location
    }
}


struct ShadowCustom : ViewModifier{
    var radiusShadow: Int
    func body(content: Content) -> some View {
        
        
        
        content
            .shadow(color: .black.opacity(0.15), radius: CGFloat(radiusShadow), x: 0, y: 0)
    }
}


struct LiftingViewAtKeyboardOpen: ViewModifier{
    @State private var keyboardHeight: CGFloat = 0
    func body(content: Content) -> some View {
        content
            .onReceive(Publishers.keyboardHeight) { value in
                withAnimation() {
                    self.keyboardHeight = value
                }
            }
            .offset(y: keyboardHeight == 0 ? 0 : -keyboardHeight * 0.30)
    }
}
//    .frame(width: wRatio(120), height: wRatio(30),  alignment: .trailing)
//    .overlay( RoundedRectangle(cornerRadius: 10, style: .continuous)
//        .stroke( Color.myGreen, lineWidth: 1)
//        .padding(.leading, wRatio(-10))
//        .padding(.trailing, wRatio(-10))
//    )

struct TextHeaderStyle: ViewModifier{
    let size: CGFloat = 18
    @State var screenW: CGFloat = .zero
    
    func body(content: Content) -> some View {
        let value = wScreen / size
        let computedSize = screenW / value
        
        content
            .onAppear(){
                self.screenW = UIScreen.main.bounds.size.width
            }
            .foregroundColor(.white)
            .font(.custom("Lato-Bold", size: computedSize))
            .lineLimit(1)
            
    }
}


extension View {
 
    func getLocationCashSources(source: CashSource, offset: CGFloat) -> some View{
        modifier(GetLocationCashSourcesModifier(source: source,
                                                offset: offset))
    }
    
    func textHeaderStyle() -> some View{
        modifier(TextHeaderStyle())
    }
    
    func liftingViewAtKeyboardOpen() -> some View{
        modifier(LiftingViewAtKeyboardOpen())
    }
    
    func myShadow(radiusShadow: Int) -> some View {
        modifier(ShadowCustom(radiusShadow: radiusShadow))
    }
    
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
    
    
    
    
    func draggable(zIndex: Binding<Double>,
                   isPurchaseDetected: Binding<Bool>,
                   isCashSourceReceiverDetected: Binding<Bool>,
                   purchaseType: Binding<String>,
                   cashType: String ,
                   cashSource: Binding<String>,
                   cashSourceReceiver: Binding<String>,
                   draggingItem: Binding<Bool>,
                   draggingIndex: Binding<Int?>,
                   currentIndexCashSource: Binding<Int?>) -> some View {
        
        modifier(DragGestureCustom(zIndex: zIndex,
                                   isPurchaseDetected: isPurchaseDetected,
                                   isCashSourceReceiverDetected: isCashSourceReceiverDetected,
                                   purchaseType: purchaseType,
                                   cashType: cashType,
                                   cashSource: cashSource,
                                   cashSourceReceiver: cashSourceReceiver,
                                   draggingItem: draggingItem,
                                   draggingIndex: draggingIndex,
                                   currentIndexCashSource: currentIndexCashSource
                                  ))
    }
}

struct DragGestureCustom: ViewModifier {
    
    @State var isDraggingItem = false
    @State var currentOffsetX: CGFloat = 0
    @State var currentOffsetY: CGFloat = 0
    @Binding var zIndex: Double
    @Binding var isPurchaseDetected: Bool
    @Binding var isCashSourceReceiverDetected: Bool
    @Binding var purchaseType: String
    @State var cashType: String
    @Binding var cashSource: String
    @Binding var cashSourceReceiver: String
    @Binding var draggingItem: Bool
    @Binding var draggingIndex: Int?
    @Binding var currentIndexCashSource: Int?
   
    var drag: some Gesture{
        DragGesture(coordinateSpace: .global)
            .onChanged({ value in
                draggingItem = true
                
                
                
                draggingIndex = currentIndexCashSource
                withAnimation {
//                    zIndex = 100
                    currentOffsetX = value.translation.width
                    currentOffsetY = value.translation.height
                    isDraggingItem.toggle()
                    
                }
                print("AAA draggingIndex \(String(describing: draggingIndex)) index \(String(describing: currentIndexCashSource))")
               
               
            })
            .onEnded { gesture in
                draggingItem = false
                let purchaseLocations = PurchaseLocation.standard.locations
//                let cashSourceLocations = CashSourceLocation.standard.locations
                
                for purchaseItem in purchaseLocations {
                    let startXRange = purchaseItem.value.x - 35
                    let finisXRange = purchaseItem.value.x + 35
                    let xRange = startXRange...finisXRange
                    
                    let startYRange = purchaseItem.value.y - 35
                    let finishYRange = purchaseItem.value.y + 35
                    let yRange = startYRange...finishYRange
                    
                    if xRange.contains(gesture.location.x) && yRange.contains(gesture.location.y) {

                        purchaseType = purchaseItem.key
                        cashSource = cashType
                        isPurchaseDetected.toggle()
                    }
                }
                let cashSourceLocations = CashSourceLocation.standard.locations
                for cashSourceItem in cashSourceLocations {
                    let startXRange = cashSourceItem.value.x - 35
                    let finisXRange = cashSourceItem.value.x + 35
                    let xRange = startXRange...finisXRange

                    let startYRange = cashSourceItem.value.y - 35
                    let finishYRange = cashSourceItem.value.y + 35
                    let yRange = startYRange...finishYRange

                    if xRange.contains(gesture.location.x) && yRange.contains(gesture.location.y) {
                        cashSourceReceiver = cashSourceItem.key
                        cashSource = cashType
                        
                        if cashSource != cashSourceReceiver{
                            isCashSourceReceiverDetected.toggle()
                        }
                    }
                }
                    
                if abs(gesture.location.x) > 49 && abs(gesture.location.x) < 95 && abs(gesture.location.y) > 419 && abs(gesture.location.y) < 470 {
                 
                    withAnimation(.spring()) {
//                        zIndex = 1
                        isDraggingItem.toggle()
                        currentOffsetX = 0
                        currentOffsetY = 0
                    }
                            
                } else {
                    withAnimation(.spring()) {
//                        zIndex = 1
                        isDraggingItem.toggle()
                        currentOffsetX = 0
                        currentOffsetY = 0
                    }
                }
                
                currentOffsetX = 0
                currentOffsetY = 0
                
                draggingIndex = nil
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


let screenSize = UIScreen.main.bounds
let screenWidth = screenSize.width
let screenHeight = screenSize.height

extension View {
    
    public var screenW: CGFloat {
        return UIScreen.main.bounds.size.width
    }
    
    public var screenH: CGFloat {
        return UIScreen.main.bounds.size.height
    }
    
    func wRatio(_ cW: CGFloat) -> CGFloat {
        let value = wScreen / cW
        let ratio = screenW / value
        return ratio
    }
    
    func hRatio(_ cH: CGFloat) -> CGFloat {
        let value = hScreen / cH
        let ratio = screenH / value
        return ratio
    }
    
}






