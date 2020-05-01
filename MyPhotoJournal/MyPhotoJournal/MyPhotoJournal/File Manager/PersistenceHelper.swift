//
//  PersistenceHelper.swift
//  MyPhotoJournal
//
//  Created by David Lin on 1/25/20.
//  Copyright © 2020 David Lin (Passion Proj). All rights reserved.
//

import Foundation

enum dataPersistenceError: Error { // conforming to the Error protocol
  case savingError(Error) // associative value
  case fileDoesNotExist(String)
  case noData
  case decodingError(Error)
  case deletingError(Error)
}


class PersistenceHelper {
   
   // CRUD - CREATE READ UPDATE DELETE
    
    
  // An Array of photos in PhotoJournal
  private var photos = [PhotoJournal]()
  
  private var filename: String
  
  init(filename: String) {
    self.filename = filename
  }
  
    // CREATE - save item to document directory
    public func save(photo: PhotoJournal) throws {
        // STEP 2
        // append new photo to the photos array
        photos.append(photo)
        
        do {
            try save()
        } catch {
            throw dataPersistenceError.savingError(error)
        }
    }

    
  private func save() throws {
    // STEP 1
    // get url to path to the file that the photo will be saved to
     let url = FileManager.pathToDocumentsDirectory(with: filename)
    
    
    // photos arrray will be object being converted to Data
    // we will use the Data object to and write (save) it to documents
    do {
      // STEP 3
      // convert (serialize) the events array to data
      let data = try PropertyListEncoder().encode(photos)
      
     //STEP 4
     // writes, saves, persists the data to the documentsdirectory
      try data.write(to: url, options: .atomic)
    } catch {
      // STEP 5
      throw dataPersistenceError.savingError(error)
    }
  }
    
  public func create(photo: PhotoJournal) throws {
    do {
     photos = try loadPhotos()
    } catch {
        print(error)
    }
//    print(photos.count)
    photos.append(photo)
    do {
      try save()
    } catch {
      throw dataPersistenceError.savingError(error)
    }
  }

    
    
    
    
    
  // READ - load (retrieve) items from documents directory
  public func loadPhotos() throws -> [PhotoJournal] {
    // getting access to the filename URL that wea reading from
    let url = FileManager.pathToDocumentsDirectory(with: filename)
    
    // check if file exists
    // to convert URL to string, we use .path on the URL
    if FileManager.default.fileExists(atPath: url.path) {
      if let data = FileManager.default.contents(atPath: url.path) {
        do {
          photos = try PropertyListDecoder().decode([PhotoJournal].self, from: data)
        } catch {
          throw dataPersistenceError.decodingError(error)
        }
      } else {
        throw dataPersistenceError.noData
      }
    }
    else {
      throw dataPersistenceError.fileDoesNotExist(filename)
    }
    return photos
  }
    
    
    
    
    //UPDATE - Update photo in document directory
    @discardableResult
    public func updateItems(_ oldPhoto: PhotoJournal, _ newPhoto: PhotoJournal) -> Bool {
        if let index = photos.firstIndex(of: oldPhoto) {
            let result = updateWithIndex(newPhoto, at: index)
            return result
        }
        return false
    }
    
    // update phote based on index in document directory
    @discardableResult
    public func updateWithIndex(_ item: PhotoJournal, at index: Int) -> Bool {
        photos[index] = item
        do {
           try save()
            return true
        } catch {
            return false
        }
    }
    
  // DELETE - remove item from documents directory
  public func delete(photo index: Int) throws {
    photos.remove(at: index)
    
    do {
      try save()
    } catch {
      throw dataPersistenceError.deletingError(error)
    }
  }
}
