//
//  CollectionViewCell.swift
//  MyPhotoJournal
//
//  Created by David Lin on 1/25/20.
//  Copyright © 2020 David Lin (Passion Proj). All rights reserved.
//

import UIKit


protocol CVCellDelegate: AnyObject {
       func didSelect(for cell: CollectionViewCell)
   }

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var descriptionText: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    func configureCell() {
        imageView.image =
        textlabel.text = 
    }
    
    
    
    
    
    
    
    @IBAction func settingsButtonClicked(_ sender: UIButton) {
    }
    
}


