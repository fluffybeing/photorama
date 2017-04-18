//
//  PhotosViewController.swift
//  Photorama
//
//  Created by Rahul Ranjan on 3/21/17.
//  Copyright © 2017 Rahul Ranjan. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    
    var store: PhotoStore!
    let photoDataSource = PhotoDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = photoDataSource
        
        store.fetchRecentPhotos() {
            (photosResult) -> Void in
            
            OperationQueue.main.addOperation() {
                switch photosResult {
                case .Success(let photos):
                    print("Found Photos: \(photos.count)")
                    self.photoDataSource.photos = photos
                case .Failure(let error):
                    self.photoDataSource.photos.removeAll()
                    print(error.localizedDescription)
                }
                
                self.collectionView.reloadSections(NSIndexSet(index: 0) as IndexSet)
            }
            
        }
    }
}
