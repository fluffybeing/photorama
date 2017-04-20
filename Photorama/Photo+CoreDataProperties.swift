//
//  Photo+CoreDataProperties.swift
//  Photorama
//
//  Created by Rahul Ranjan on 4/18/17.
//  Copyright © 2017 Rahul Ranjan. All rights reserved.
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }

    @NSManaged public var dateTaken: NSDate
    @NSManaged public var photoID: String
    @NSManaged public var photoKey: String
    @NSManaged public var remoteURL: NSURL
    @NSManaged public var title: String
    @NSManaged public var tags: Set<NSManagedObject>

}
