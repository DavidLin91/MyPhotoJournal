//
//  AddImageVC.swift
//  MyPhotoJournal
//
//  Created by David Lin on 1/25/20.
//  Copyright © 2020 David Lin (Passion Proj). All rights reserved.
//

import UIKit
import AVFoundation // we want to use AVMakeRect() to maintain image aspect ratio

protocol SaveImageDelegate: AnyObject {
    func didSave(thisPhoto: PhotoJournal)
}

class AddImageVC: UIViewController {
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var textField: UITextView!
    
    weak var delegate: SaveImageDelegate?
    
    
    private var imagePersistence = PersistenceHelper(filename: "images.plist")
    
    private var imagePicker = UIImagePickerController()
    
    var photos: PhotoJournal!
    
    override func viewDidLayoutSubviews() {
        textField.layer.cornerRadius = 5.0
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.isEnabled = false
    }
    
    @IBAction func selectPhotoButtonClicked(_ sender: UIBarButtonItem) {
        imagePicker.delegate = self
        present(imagePicker, animated: true)
        saveButton.isEnabled = true
    }
    
    
    @IBAction func cameraButtonClicked(_ sender: UIBarButtonItem) {
        // check to see if there is camera access
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true)
    }
    
    @IBAction func cancelButtonClicked(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    
    @IBAction func savedButtonClicked(_ sender: UIBarButtonItem) {
        savePhoto()
    }
    
    func savePhoto() {
        // setting the image being saved to UIImageView
        guard let thisImage = photo.image else {
            return
        }
        
        // the size to resize image
        let size = UIScreen.main.bounds.size
        
        // we will maintain the aspect ratio of the image
        let rect = AVMakeRect(aspectRatio: thisImage.size, insideRect: CGRect(origin: CGPoint.zero, size: size))
        
        // resize image
        let resized = thisImage.resizeImage(to: rect.size.width, height: rect.size.height)
        
        guard let photoData = resized.jpegData(compressionQuality: 1.0) else {
            return
        }
        
        photos = PhotoJournal(imageData: photoData, dateCreated: Date(), description: textField.text!)
        delegate?.didSave(thisPhoto: photos)
        do {
            try? imagePersistence.create(photo: photos)
        } catch {
            print("saving error: \(error)")
        }
        
        dismiss(animated: true)
    }
    
}



extension AddImageVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        photo.image = image
        dismiss(animated: true)
    }
}

extension UIImage{
    func resizeImage(to width: CGFloat, height: CGFloat) -> UIImage {
            let size = CGSize(width: width, height: height)
            let renderer = UIGraphicsImageRenderer(size: size)
            return renderer.image { (context) in
                self.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
