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
    
    private var images = [PhotoJournal]() {
        didSet {
            self.collectionView.reloadData()
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
    
    @IBAction func addImageButtonPressed(_ sender: UIBarButtonItem) {
        addImage()
    }
    
    private func addImage() {
        guard let addAddImageVC = storyboard?.instantiateViewController(identifier: "AddImageVC") as? AddImageVC else {
            fatalError()
        }
        addAddImageVC.delegate = self
        present(addAddImageVC, animated: true)
    }
    
    
    private func appendPhoto() {
        do {
            images = try dataPersistance.loadPhotos()
        } catch {
            print(error)
        }
    }
    
    
    
    
    @IBAction func settingsButtonPressed(_ sender: UIButton) {
    
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


extension MainVC: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//    let maxWidth: CGFloat = UIScreen.main.bounds.size.width // width of the device
//    let itemWidth: CGFloat = maxWidth * 0.90
//    return CGSize(width: itemWidth, height: itemWidth)
//    }
}


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
    func didSave(thisPhoto: PhotoJournal ) {
        self.images.append(thisPhoto)
    }
}

