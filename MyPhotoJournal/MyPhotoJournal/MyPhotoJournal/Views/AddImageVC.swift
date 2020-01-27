//
//  AddImageVC.swift
//  MyPhotoJournal
//
//  Created by David Lin on 1/25/20.
//  Copyright © 2020 David Lin (Passion Proj). All rights reserved.
//

import UIKit
import AVFoundation // we want to use AVMakeRect() to maintain image aspect ratio

enum photoType {
    case newImage
    case editImage
}

protocol SaveImageDelegate: AnyObject {
    func didSave(photo: PhotoJournal, type: photoType)
}

class AddImageVC: UIViewController {
    
    @IBOutlet weak var cancelButton: UIToolbar!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var textField: UITextView!
    @IBOutlet weak var selectPhotoButton: UIToolbar!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    weak var delegate: SaveImageDelegate?
    
    public private(set) var type = photoType.newImage
    
    private var imagePicker = UIImagePickerController()
    
    var photos: PhotoJournal?
    
    
    
    override func viewDidLayoutSubviews() {
        textField.layer.cornerRadius = 5.0
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.isEnabled = false
        }

    
    private func saveImage() {
        // setting the image being saved to UIImageView
        guard let image = photo.image else {
            return
        }
        
        // the size to resize image
        let size = UIScreen.main.bounds.size
        // we will maintain the aspect ratio of the image
        let rect = AVMakeRect(aspectRatio: image.size, insideRect: CGRect(origin: CGPoint.zero, size: size))
        // resize image
        let imageResize = image.resizeImage(to: rect.size.width, height: rect.size.height)
        
        guard let photoData = imageResize.jpegData(compressionQuality: 1.0) else { return
        }
        photos = PhotoJournal(name: textField.text, imageData: photoData, dateCreated: Date())
        guard let thisImage = photos else {
            print("Could not retrieve image")
            return
        }
        delegate?.didSave(photo: thisImage, type: .newImage)
    }
    
    
    @IBAction func selectPhotoButtonClicked(_ sender: UIBarButtonItem) {
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.delegate = self
        present(imagePickerVC, animated: true)
        saveButton.isEnabled = true
    }
    
    
    @IBAction func cameraButtonClicked(_ sender: UIBarButtonItem) {
        // check to see if there is camera access
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
        } else {
            cameraButton.isEnabled = false
            print("cannot access camera")
        }
        saveButton.isEnabled = true
    }
    
    @IBAction func cancelButtonClicked(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func savedButtonClicked(_ sender: UIBarButtonItem) {
        if type == .newImage {
                saveImage()
            print("image saved")
            } else if type == .editImage {
              //  updateUI()
            }
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

extension UIImage {
    func resizeImage(to width: CGFloat, height: CGFloat) -> UIImage {
        let size = CGSize(width: width, height: height)
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { (context) in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
