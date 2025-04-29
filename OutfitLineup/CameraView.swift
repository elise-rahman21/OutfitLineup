//
//  CameraView.swift
//  OutfitLineup
//
//  Created by Rahman, Elise (513171) on 4/29/25.
//

import SwiftUI

struct CameraView: UIViewControllerRepresentable {
    
    // Coordinator class manages the UIImagePickerController's delegate methods.
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate
    {
        var parent: CameraView // Reference to the parent view (CameraView)
        
        init(parent: CameraView)
        {
            self.parent = parent
        }
        
        // Delegate method called when a photo is selected or captured
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
        {
            // Retrieve the captured image
            if let image = info[.originalImage] as? UIImage
            {
                parent.didCaptureImage(image) // Pass the image back to the parent view
            }
            parent.presentationMode.wrappedValue.dismiss() // Dismiss the camera view after taking the photo
        }
        
        // Delegate method called if the user cancels the photo capture
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
        {
            parent.presentationMode.wrappedValue.dismiss() // Just dismiss the camera view without saving anything
        }
    }
    
    var didCaptureImage: (UIImage) -> Void // Closure to handle the captured image in the parent view
    @Environment(\.presentationMode) var presentationMode // Used to dismiss the camera view
    
    
    //******
    @Binding var isCameraActive: Bool // To control camera visibility from parent view
    @Binding var capturedImage: UIImage? // Store the captured image
    //@State private var showButtons = false // Flag to show the redo/confirm buttons after photo capture
    //******
    
    
    
    // Creates the UIImagePickerController instance (used for capturing photos)
    func makeCoordinator() -> Coordinator
    {
        return Coordinator(parent: self)
    }
    
    // Configures and returns the UIImagePickerController for the camera
    func makeUIViewController(context: Context) -> UIImagePickerController
    {
        let picker = UIImagePickerController() // Create the image picker
        picker.delegate = context.coordinator // Set the delegate to handle image selection
        picker.sourceType = .camera // Use the camera for capturing images
        picker.cameraCaptureMode = .photo // Capture photos
        return picker
    }
    
    // Update the view controller if needed (not used here)
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}


