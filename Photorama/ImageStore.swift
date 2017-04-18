//
//  ImageStore.swift
//  Homepwner
//
//  Created by Rahul Ranjan on 3/9/17.
//  Copyright © 2017 Rahul Ranjan. All rights reserved.
//

import UIKit

class ImageStore: NSObject {
    let cache = NSCache<NSString, UIImage>()
    
    func setImage(image: UIImage, forKey key: NSString) {
        cache.setObject(image, forKey: key)
        
        let imageURL = imageURLForKey(key: key as String)
        if let data = UIImageJPEGRepresentation(image, 0.5) {
            try? data.write(to: imageURL as URL, options: .atomicWrite)
        }
    }
    
    func imageForKey(key: NSString) -> UIImage? {
        
        if let existingImage = cache.object(forKey: key) {
            return existingImage
        }
        
        let imageURL = imageURLForKey(key: key as String)
        guard let imageFromDisk = UIImage(contentsOfFile: imageURL.path!) else {
            return nil
        }
        
        cache.setObject(imageFromDisk, forKey: key)
        return imageFromDisk
    }

    func deleteImageForKey(key: NSString) {
        cache.removeObject(forKey: key)
        
        let imageURL = imageURLForKey(key: key as String)
        do {
            try FileManager.default.removeItem(at: imageURL as URL)
        } catch let deleteError {
            print(deleteError)
        }
    }
    func imageURLForKey(key: String) -> NSURL {
        let documentDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentDirectories.first!
        
        return documentDirectory.appendingPathComponent(key) as NSURL
    }
}
