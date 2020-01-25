//
//  ViewController.swift
//  MyPhotoJournal
//
//  Created by David Lin on 1/25/20.
//  Copyright © 2020 David Lin (Passion Proj). All rights reserved.
//

import UIKit

class MainVC: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var images = [UIImage]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    
    
    @IBAction func addImageButtonPressed(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func settingsButtonPressed(_ sender: UIBarButtonItem) {
        
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
        cell.imageView.image = image
        return cell
    }
}


