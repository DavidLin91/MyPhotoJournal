//
//  CollectionViewCell.swift
//  MyPhotoJournal
//
//  Created by David Lin on 1/25/20.
//  Copyright © 2020 David Lin (Passion Proj). All rights reserved.
//

import UIKit


protocol CVCellDelegate: AnyObject {
    func didSelect(cell: PhotoJournal)
}

class CollectionViewCell: UICollectionViewCell {
    
    weak var delegate: CVCellDelegate?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionText: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    public func configureCell(cell: PhotoJournal) {
        
        guard let image = UIImage(data: cell.imageData) else {
            return
        }
        
        imageView.image = image
        descriptionText.text = cell.description
        dateLabel.text = cell.dateCreated.description
    }
    
    @IBAction func settingsButtonClicked(_ sender: UIButton) {
    }
    
}


