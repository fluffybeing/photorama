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
        collectionView.delegate = self
        
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


extension PhotosViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let photo = photoDataSource.photos[indexPath.row]
        
        store.fetchImageForPhoto(photo: photo) { (result) -> Void in
            OperationQueue.main.addOperation() {
                
                // Why to check?
                // The index path for image might have changed in due request
                // process
                let photoIndex = self.photoDataSource.photos.index(where: { $0.photoID == $0.photoID })
                let photoIndexPath = NSIndexPath(row: photoIndex!, section: 0) as IndexPath
                
                if let cell = self.collectionView.cellForItem(at: photoIndexPath) as? PhotoCollectionViewCell {
                    cell.updateWithImage(image: photo.image)
                }
            }
        }
    }
}
