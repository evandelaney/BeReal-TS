//
//  Created by Evan DeLaney on 12/17/23.
//

import UIKit
import SwiftUI
import PhotosUI

struct ImagePicker: UIViewControllerRepresentable {
    
    @Binding var image: UIImage?
    @Binding var filename: String
    
    func makeUIViewController(context: Context) -> some UIViewController
    {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        
        let pickerViewController = PHPickerViewController(configuration: configuration)
        pickerViewController.delegate = context.coordinator
        
        return pickerViewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
    
    func makeCoordinator() -> Coordinator
    {
        Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        
        let parent: ImagePicker
        
        init(parent: ImagePicker)
        {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult])
        {
            picker.dismiss(animated: true)
            
            guard let result = results.first else { return }
            
            guard result.itemProvider.canLoadObject(ofClass: UIImage.self) else { return }
            
            let filename = result.itemProvider.suggestedName ?? "IMG_\(Int.random(in: 1000..<10000))"
            
            result.itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                self.parent.image = image as? UIImage
                self.parent.filename = filename
            }
        }
    }
}

#Preview {
    ImagePicker(image: .constant(nil), filename: .constant("IMG_0001"))
}
