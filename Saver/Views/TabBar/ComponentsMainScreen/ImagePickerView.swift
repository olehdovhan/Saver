//
//  ImagePickerView.swift
//  Saver
//
//  Created by Oleh on 15.02.2023.
//

import UIKit
import SwiftUI

struct ImagePickerView: UIViewControllerRepresentable {
    
    @Binding var selectedImage: UIImage?
    var onlyImage: Bool
    @Environment(\.presentationMode) var isPresented
    var sourceType: UIImagePickerController.SourceType
    var closure: (URL?) -> ()
        
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = self.sourceType
        if !onlyImage {
            imagePicker.mediaTypes = ["public.image", "public.movie"]
        }
        imagePicker.delegate = context.coordinator // confirming the delegate
        return imagePicker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {

    }

    // Connecting the Coordinator class with this struct
    func makeCoordinator() -> Coordinator {
        return Coordinator(picker: self,
                           closure: closure)
    }
}

class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var picker: ImagePickerView
    var closure: (URL?)->()
    
    init(picker: ImagePickerView, closure: @escaping (URL?)->()) {
        self.picker = picker
        self.closure = closure
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let selectedImage = info[.originalImage] as? UIImage {
//            ,
//           let selectedImageURL = info[.imageURL] as? URL {
            self.picker.selectedImage = selectedImage
            self.picker.isPresented.wrappedValue.dismiss()
         //   closure(selectedImageURL)
            closure(nil)
        } else if let selectedVideoURL = info[.mediaURL] as? URL {
            self.picker.isPresented.wrappedValue.dismiss()
            closure(selectedVideoURL)
        }
    }
    
}
