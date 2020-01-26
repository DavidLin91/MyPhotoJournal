//
//  AddImageVC.swift
//  MyPhotoJournal
//
//  Created by David Lin on 1/25/20.
//  Copyright © 2020 David Lin (Passion Proj). All rights reserved.
//

import UIKit
import AVFoundation

class AddImageVC: UIViewController {
    
    @IBOutlet weak var cancelButton: UIToolbar!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var textField: UITextView!
    @IBOutlet weak var selectPhotoButton: UIToolbar!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    private var imagePicker = UIImagePickerController()
    
    var photos: PhotoJournal?
    
    override func viewDidLayoutSubviews() {
        textField.layer.cornerRadius = 5.0
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    private func saveImage() {
        guard let image = photo.image else {
            return
        }
        
        let size = UIScreen.main.bounds.size
        
        let rect = AVMakeRect(aspectRatio: image.size, insideRect: CGRect(origin: CGPoint.zero, size: size))
        
        let resizedImage = image
        
        guard let photoData = image.jpegData(compressionQuality: 1.0) else { return
        }
        photos = PhotoJournal(name: textField.text, imageDate: photoData, dateCreated: Date())
        guard let image = photos else {
            print("Could not retrieve image")
            return
        }
        delegate?.didSave
    }
    
    
    
    
    
    @IBAction func selectPhotoButtonClicked(_ sender: UIBarButtonItem) {
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.delegate = self
        present(imagePickerVC, animated: true)
    }
    
    
    @IBAction func cameraButtonClicked(_ sender: UIBarButtonItem) {
        // check to see if there is camera access
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
        } else {
            cameraButton.isEnabled = false
            print("cannot access camera")
        }
    }
    
    @IBAction func cancelButtonClicked(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func savedButtonClicked(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true)
    }
    
    private func showImageController(isCameraSelected: Bool) {
        
    }
    
}



extension AddImageVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        photo.image = image
        dismiss(animated: true, completion: nil)
    }
}
