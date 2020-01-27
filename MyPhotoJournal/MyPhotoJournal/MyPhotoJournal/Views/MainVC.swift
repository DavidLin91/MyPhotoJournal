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
            collectionView.reloadData()
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
        cell.delegate = image
        return cell
    }
}


