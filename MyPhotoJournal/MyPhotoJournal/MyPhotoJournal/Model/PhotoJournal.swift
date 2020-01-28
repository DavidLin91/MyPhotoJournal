//
//  PhotoJournal.swift
//  MyPhotoJournal
//
//  Created by David Lin on 1/26/20.
//  Copyright © 2020 David Lin (Passion Proj). All rights reserved.
//

import Foundation

struct PhotoJournal: Codable & Equatable {
    let imageData: Data
    let dateCreated: Date
    let description: String
}
