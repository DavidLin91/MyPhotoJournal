//
//  ViewController.swift
//  MyPhotoJournal
//
//  Created by David Lin on 1/25/20.
//  Copyright © 2020 David Lin (Passion Proj). All rights reserved.
//

import UIKit
import AVFoundation

class MainVC: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let dataPersistance = PersistenceHelper(filename: "images.plist")
    
    var images = [PhotoJournal]() {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    var selectedImage: UIImage? {
        didSet {
            appendPhoto()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        loadImages()
    }
    
    func loadImages() {
        do {
            images = try dataPersistance.loadPhotos()
        } catch {
            print(error)
        }
    }
    
    private func appendPhoto() {
        guard let image = selectedImage else {
            return
        }
        
        let size = UIScreen.main.bounds.size
        let rect = AVMakeRect(aspectRatio: image.size, insideRect: CGRect(origin: CGPoint.zero, size: size))
        let thumbnail = image.resizeImage(to: rect.size.width, height: rect.size.height)
        guard let imageData = thumbnail.jpegData(compressionQuality: 1.0) else {return}
        
        let photo = PhotoJournal(name: "", imageData: imageData, dateCreated: Date())
        images.insert(photo, at: 0)
        let indexPath = IndexPath(row:0 , section: 0)
        collectionView.insertItems(at: [indexPath])
        
        do {
            try dataPersistance.create(photo: photo)
        } catch {
            print(error)
        }
    }
    
    private func showMenu(for cell: CollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else {
            return
        }
        let optionsMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let edit = UIAlertAction(title: "Edit", style: .default) { [weak self] (action) in
//            self?.showViewController(self?.photos[indexPath.row])
        }
        let delete = UIAlertAction(title: "Delete", style: .destructive) { [weak self] (action) in
            do{
                try self?.dataPersistance.delete(photo: indexPath.row)
                self?.loadImages()
                self?.collectionView.reloadData()
            }catch{
                print(error)
            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { [weak self] (action) in
            self?.dismiss(animated: true)
        }
        optionsMenu.addAction(edit)
        optionsMenu.addAction(delete)
        optionsMenu.addAction(cancel)
        present(optionsMenu, animated: true, completion: nil)
    }
    
}


extension MainVC: UICollectionViewDelegateFlowLayout {}


extension MainVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mainCell", for: indexPath) as? CollectionViewCell else {
            fatalError("Could not dequeue Collection View Cell")
        }
        let image = images[indexPath.row]
        cell.configureCell(for: image)
        return cell
    }
}

extension MainVC: SaveImageDelegate {
    func didSave(photo: PhotoJournal, type: photoType ) {
        if type == .newImage {
            self.images.append(photo)
                do {
                    try dataPersistance.create(photo: photo)
                    
                } catch {
                    print("could not create photo")
                }
        } else if type == .editImage {
            print("")
        }
    
    }
}

