//
//  FlickrAPI.swift
//  Photorama
//
//  Created by Rahul Ranjan on 3/21/17.
//  Copyright © 2017 Rahul Ranjan. All rights reserved.
//

import Foundation
import CoreData

enum Method: String {
    case RecentPhotos = "flickr.photos.getRecent"
}

enum PhotoResult {
    case Success([Photo])
    case Failure(Error)
}

enum FlickrError: Error {
    case InvalidJSONData
}

struct FlickrAPI {

    private static let baseURLString = "https://api.flickr.com/services/rest"
    private static let APIKey = "93baa9976d2753bce6d1817453da74af"

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }()

    private static func flickrURL(method: Method, parameter: [String: String]?) -> URL {

        var components = URLComponents(string: baseURLString)!
        var queryItems = [URLQueryItem]()

        let baseParams = [
            "method": method.rawValue,
            "format": "json",
            "nojsoncallback": "1",
            "api_key": APIKey

        ]

        for (key, value) in baseParams {
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        }

        if let additionalParams = parameter {
            for (key, value) in additionalParams {
                let item = URLQueryItem(name: key, value: value)
                queryItems.append(item)
            }
        }
        components.queryItems = queryItems
        return components.url!
    }

    static func recentPhotoURL() -> URL {
        return flickrURL(method: .RecentPhotos, parameter: ["extras": "url_h,date_taken"])
    }

    static func photoFromJSONData(data: Data, inContext context: NSManagedObjectContext) -> PhotoResult {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])

            guard let
                jsonDictionary = jsonObject as? [String: AnyObject],
                let photos = jsonDictionary["photos"] as? [String: AnyObject],
                let photoArray = photos["photo"] as? [[String: AnyObject]] else {
                    return .Failure(FlickrError.InvalidJSONData)
            }


            // Create an array of Photo
            var finalPhotos = [Photo]()
            for photoJSON in photoArray {
                if let photo = photoFromJSONObject(json: photoJSON, inContext: context) {
                    finalPhotos.append(photo)
                }
            }


            if finalPhotos.count == 0 && photoArray.count > 0 {
                // not able to parse the json
                return .Failure(FlickrError.InvalidJSONData)
            }

            // return enum with associated value
            return .Success(finalPhotos)

        } catch let error {
            return .Failure(error)
        }
    }

    private static func photoFromJSONObject(json: [String: AnyObject], inContext context: NSManagedObjectContext) -> Photo? {
        
        guard let photoID = json["id"] as? String,
            let title = json["title"] as? String,
            let dateString = json["datetaken"] as? String,
            let photoURLString = json["url_h"] as? String,
            let url = URL(string: photoURLString),
            let dateTaken = dateFormatter.date(from: dateString) else {
                return nil
            }
        
        var photo: Photo!
        context.performAndWait() {
            photo = NSEntityDescription.insertNewObject(forEntityName: "Photo", into: context) as! Photo
            
            photo.title = title
            photo.photoID = photoID
            photo.remoteURL = url as NSURL
            photo.dateTaken = dateTaken as NSDate
        }
        
        return photo
    }
}
