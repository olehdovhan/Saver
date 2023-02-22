//
//  SnackBarView.swift
//  Saver
//
//  Created by Oleh on 22.02.2023.
//

import SwiftUI

struct SnackBarModel {
    let type: SnackBarType
    let text: String
    let buttonTitle: String?
    let textAlignment: Alignment
    let bottomPadding: CGFloat
    let action: () -> ()
    
    init(type: SnackBarType, text: String, buttonTitle: String? = nil, alignment: Alignment = .center, bottomPadding: CGFloat = 16, action: @escaping () -> () = {}) {
        self.type = type
        self.text = text
        self.textAlignment = alignment
        self.buttonTitle = buttonTitle
        self.bottomPadding = bottomPadding
        self.action = action
    }
}

enum SnackBarType {
    case warning
    case attention
    case success
    case mindCompleated
    case mindSuccessSaved
    case saved
    case delete
}

struct SnackBarView: View {
    
    //MARK: - @Binding
    @Binding private var show: Bool
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var timeRemaining = 0
    
    //MARK: - @Private Property
    private let model: SnackBarModel
    
    //MARK: - Initializers
    init(show: Binding<Bool>, model: SnackBarModel) {
        self._show = show
        self.model = model
    }
    
    //MARK: - Body
    var body: some View {
        VStack {
            Spacer()
            HStack(spacing: 0) {
                image.padding(.trailing, 18)
                
                Text(model.text)
                    .foregroundColor(Color.white)
                    .font(.custom("NotoSansDisplay-Medium", size: 14))
                    .frame(maxWidth: .infinity, alignment: model.textAlignment)
                
                if let buttonTitle = model.buttonTitle {
                    Spacer().frame(width: 16)
                    
                    Button {
                        self.timer.upstream.connect().cancel()
                        withAnimation {
                            self.show = false
                        }
                        model.action()
                    } label: {
                        Text(buttonTitle)
                            .underline()
                            .foregroundColor(Color(hex: "77D44F"))
                            .font(.custom("NotoSansDisplay-Medium", size: 14))
                    }
                    
                } else {
                    Spacer().frame(width: 20)
                    
                    Button {
                        self.timer.upstream.connect().cancel()
                        withAnimation {
                            self.show = false
                        }
                    } label: {
                        Image("toastClose")
                    }
                }
            }
            .padding(.vertical, 12)
            .padding(.leading, 14).padding(.trailing, 22.5)
            .background(RoundedRectangle(cornerRadius: 10).fill(Color(hex: "090909").opacity(0.85)))
            .shadow(color: Color(hex: "141726").opacity(0.2), radius: 14, x: 0, y: 8)
        }
        .onReceive(timer, perform: { _ in
            timeRemaining += 1
            debugPrint(timeRemaining)
            if timeRemaining == 4 {
                self.timer.upstream.connect().cancel()
                timeRemaining = 0
                withAnimation {
                    self.show = false
                }
            }
        })
        .zIndex(1)
        .padding(.bottom, model.bottomPadding)
        .padding(.horizontal, 16)
        .animation(.easeInOut(duration: 0.5))
        .animation(.interpolatingSpring(stiffness: 50, damping: 1))
        .transition(AnyTransition.move(edge: .bottom).combined(with: .opacity))
        .onAppear {
            timeRemaining = 0
        }
        
    }
    
    private var image: Image {
        return Image("toastWarningIcon")
    }
}

