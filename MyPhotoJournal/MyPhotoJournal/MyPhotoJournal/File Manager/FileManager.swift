//
//  FileManager.swift
//  MyPhotoJournal
//
//  Created by David Lin on 1/25/20.
//  Copyright © 2020 David Lin (Passion Proj). All rights reserved.
//

import Foundation

extension FileManager {
    // returns URL for document directory
    static func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    //documents/ filename = self
    static func pathToDocumentsDirectory(with filename: String) -> URL {
        return getDocumentsDirectory().appendingPathComponent(filename)
    }
}
