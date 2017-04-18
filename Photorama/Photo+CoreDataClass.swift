//
//  Photo+CoreDataClass.swift
//  Photorama
//
//  Created by Rahul Ranjan on 4/18/17.
//  Copyright © 2017 Rahul Ranjan. All rights reserved.
//

import UIKit
import CoreData

@objc(Photo)
public class Photo: NSManagedObject {
    
    var image: UIImage?
    
    
    public override func awakeFromNib() {
        title = ""
        photoID = ""
        remoteURL = NSURL()
        photoKey = UUID().uuidString
        dateTaken = NSDate()
    }

}
