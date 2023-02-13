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
                   isAlertShow: Binding<Bool>,
                   purchaseType: Binding<String>,
                   cashType: String ,
                   cashSource: Binding<String>,
                   draggingItem: Binding<Bool>) -> some View {
        modifier(DragGestureCustom(zIndex: zIndex, isAlertShow: isAlertShow, purchaseType: purchaseType, cashType: cashType, cashSource: cashSource, draggingItem: draggingItem))
    }
}

struct DragGestureCustom: ViewModifier {
    
    @State var isDraggingItem = false
    @State var currentOffsetX: CGFloat = 0
    @State var currentOffsetY: CGFloat = 0
    @Binding var zIndex: Double
    @Binding var isAlertShow: Bool
    @Binding var purchaseType: String
    @State var cashType: String
    @Binding var cashSource: String
    @Binding var draggingItem: Bool
   
    var drag: some Gesture{
        DragGesture(coordinateSpace: .global)
            .onChanged({ value in
                draggingItem = true
                withAnimation {
                    zIndex = 5
                    currentOffsetX = value.translation.width
                    currentOffsetY = value.translation.height
                    isDraggingItem.toggle()
                }
//                print(value.location.y)
               
            })
            .onEnded { gesture in
                draggingItem = false
                var locs = PurchaseLocation.standard.locations
                
                for item in locs {
                    let startXRange = item.value.x - 35
                    let finisXRange = item.value.x + 35
                    let xRange = startXRange...finisXRange
                    
                    let startYRange = item.value.y - 35
                    let finishYRange = item.value.y + 35
                    let yRange = startYRange...finishYRange
                    
                    if xRange.contains(gesture.location.x) && yRange.contains(gesture.location.y) {

                        purchaseType = item.key
                        cashSource = cashType
                        isAlertShow.toggle()
                    }
                }
                    
                if abs(gesture.location.x) > 49 && abs(gesture.location.x) < 95 && abs(gesture.location.y) > 419 && abs(gesture.location.y) < 470 {
                 
                    print("moped")
                    withAnimation(.spring()) {
                        zIndex = 1
                        isDraggingItem.toggle()
                        currentOffsetX = 0
                        currentOffsetY = 0
                    }
                            
                } else {
                    withAnimation(.spring()) {
                        zIndex = 1
                        isDraggingItem.toggle()
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




struct IsometricView<Content: View>: View {
    
    var active: Bool
    var content: Content
    var extruded: Bool
    var depth: CGFloat
    
    init(active: Bool, extruded: Bool = false, depth: CGFloat = 20, @ViewBuilder content: ()-> Content) {
        self.active = active
        self.extruded = extruded
        self.depth = depth
        self.content = content()
    }
    
    @ViewBuilder var body: some View {
        if active {
            if extruded {
                content
                    .modifier(ExtrudeModifier(depth: depth, texture: content))
                    .modifier(IsometricViewModifier())
//                    .animation(.easeInOut)
            } else {
                content
                    .modifier(IsometricViewModifier())
//                    .animation(.easeInOut)
            }
        } else {
            content
//                .animation(.easeInOut)
        }
        
    }
}


struct ExtrudeModifier<Texture: View> : ViewModifier {
    
    var depth: CGFloat
    var texture: Texture
    
    func body(content: Content) -> some View {
        content
        // Front Left Side
                    .overlay(
                        GeometryReader { geo in
                            texture // Step 2
                                .brightness(-0.05)
                                .scaleEffect(x: 1, y: geo.size.height * geo.size.height, anchor: .bottom) // Step 3
                                .frame(height: depth, alignment: .top) // Step 4
                                .mask(Rectangle())
                                .rotation3DEffect(
                                    Angle(degrees: 180),
                                    axis: (x: 1.0, y: 0.0, z: 0.0),
                                    anchor: .center,
                                    anchorZ: 0.0,
                                    perspective: 1.0
                                )
                                .projectionEffect(ProjectionTransform(CGAffineTransform(a: 1, b: 0, c: 1, d: 1, tx: 0, ty: 0))) // Step 5
                                .offset(x: 0, y: geo.size.height)
                                
                        }
                        , alignment: .center)
            
            // Front Right Side
            .overlay(
                GeometryReader { geo in
                    texture
                        .brightness(-0.1)
                        .scaleEffect(x: geo.size.width * geo.size.width, y: 1.0, anchor: .trailing)
                        .frame(width: depth, alignment: .leading)
                        .clipped()
                        .rotation3DEffect(
                            Angle(degrees: 180),
                            axis: (x: 0.0, y: 1.0, z: 0.0),
                            anchor: .leading,
                            anchorZ: 0.0,
                            perspective: 1.0
                        )
                        .projectionEffect(ProjectionTransform(CGAffineTransform(a: 1, b: 1, c: 0, d: 1, tx: 0, ty: 0)))
                        .offset(x: geo.size.width + depth, y: 0 + depth)
                }
                , alignment: .center)
                
    }
}

struct IsometricViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .rotationEffect(Angle(degrees: 45), anchor: .center)
            .scaleEffect(x: 1.0, y: 0.5, anchor: .center)
    }
}
