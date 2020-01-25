//
//  AddImageVC.swift
//  MyPhotoJournal
//
//  Created by David Lin on 1/25/20.
//  Copyright © 2020 David Lin (Passion Proj). All rights reserved.
//

import UIKit

class AddImageVC: UIViewController {

    @IBOutlet weak var cancelButton: UIToolbar!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var textField: UITextView!
    @IBOutlet weak var selectPhotoButton: UIToolbar!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    
    override func viewDidLayoutSubviews() {
        textField.layer.cornerRadius = 5.0
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func selectPhotoButtonClicked(_ sender: UIBarButtonItem) {
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.delegate = self
        present(imagePickerVC, animated: true)
    }
    
    
    @IBAction func cameraButtonClicked(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func cancelButtonClicked(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func savedButtonClicked(_ sender: UIBarButtonItem) {
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
