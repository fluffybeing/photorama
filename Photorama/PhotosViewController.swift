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
            
            let sortByDateTaken = NSSortDescriptor(key: "dateTaken", ascending: true)
            let allPhotos = try! self.store.fetchMainQueuePhotos(predicate: nil, sortDescriptors: [sortByDateTaken])
            
            OperationQueue.main.addOperation() {
                self.photoDataSource.photos = allPhotos
                self.collectionView.reloadSections(NSIndexSet(index: 0) as IndexSet)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowPhoto" {
            if let selectedIndexPath = collectionView.indexPathsForSelectedItems?.first {
                let photo = photoDataSource.photos[selectedIndexPath.row]
                
                let destinationVC = segue.destination as! PhotoInfoViewController
                destinationVC.photo = photo
                destinationVC.store = store
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
                let photoIndex = self.photoDataSource.photos.index(where: { $0.photoID == photo.photoID })
                let photoIndexPath = IndexPath(row: photoIndex!, section: 0)
                
                if let cell = self.collectionView.cellForItem(at: photoIndexPath) as? PhotoCollectionViewCell {
                    cell.updateWithImage(image: photo.image)
                }
            }
        }
    }
}
