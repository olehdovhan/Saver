//
//  TextView.swift
//  Saver
//
//  Created by O l e h on 07.09.2022.
//

import SwiftUI


struct ImageButtonStyle: ButtonStyle {
    var image: String
    var pressedImage: String

    func makeBody(configuration: Self.Configuration) -> some View {
      let displayImage = configuration.isPressed ? pressedImage : image
      return Image(displayImage)
    }
}

struct ImageButton: View {
    
    var image: String
    var pressedImage: String
    var action: () -> Void
    
    var body: some View {
        Button(action: self.action) { }
            .buttonStyle(ImageButtonStyle(image: image, pressedImage: pressedImage))
    }
}
