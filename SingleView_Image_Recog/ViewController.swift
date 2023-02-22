//
//  ViewController.swift
//  SingleView_Image_Recog
//
//  Created by Denver Lopes on 22/2/2023.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // so first we will check if the image was picked or not
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            imageView.image = userPickedImage
            
            // this is needed to help the MLModel to access the image.
            guard let ciimage = CIImage(image: userPickedImage) else {
                fatalError("Could not convert to CIImage")
            }
            
            detect(image: ciimage)
            
            
        }
        imagePicker.dismiss(animated: true)
        
    }

    
    func detect(image: CIImage) {
        
        guard  let model = try? VNCoreMLModel(for: MobileNetV2().model) else{
            fatalError("loading eerror")
        }
        
        let request = VNCoreMLRequest(model: model) {(request, error) in
            guard let results = request.results as? [VNClassificationObservation] else{
                fatalError("Wth! something went wrong")
            }
     
            if let firstResult = results.first{
                if firstResult.identifier.contains("hotdog") {
                    self.navigationItem.title = "Hotdog!"
                }else{
                    self.navigationItem.title = "Not hotdog!"
                }
            }
            
            
            
            
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do{
            try handler.perform([request])
        }catch{
            print(error)
        }
    }
  
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        
        present(imagePicker, animated: true)
        
        
    }
    
    
    
    
}

