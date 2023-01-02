//
//  UIApplication+Extension.swift
//  Saver
//
//  Created by Oleh Dovhan on 13.12.2022.
//

import SwiftUI

extension UIApplication {
    func addTapGestureRecognizer() {
        guard let window = windows.first else { return }
        let tapGesture = UITapGestureRecognizer(target: window, action: #selector(UIView.endEditing))
        tapGesture.requiresExclusiveTouchType = false
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        window.addGestureRecognizer(tapGesture)
    }
}

extension UIApplication: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true // set to false if you don't want to detect tap during other gestures
    }
}



extension UIApplication {
    /**
     Get status bar view
     */
    var statusBarUIView: UIView? {
        let tag = 13101996
        if let statusBar = self.windows.first?.viewWithTag(tag) {
            self.windows.first?.bringSubviewToFront(statusBar)
            return statusBar
        } else {
            let statusBarView = UIView(frame: UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame ?? .zero)
            statusBarView.tag = tag
            
            self.windows.first?.addSubview(statusBarView)
            return statusBarView
        }
    }
}


