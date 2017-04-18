//
//  PhotoInfoViewController.swift
//  Photorama
//
//  Created by Rahul Ranjan on 4/18/17.
//  Copyright © 2017 Rahul Ranjan. All rights reserved.
//

import UIKit

class PhotoInfoViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    
    var photo: Photo! {
        didSet {
            navigationItem.title = photo.title
        }
    }
    var store: PhotoStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        store.fetchImageForPhoto(photo: photo) { (result) -> Void in
            switch result {
            case .Success(let image):
                OperationQueue.main.addOperation() {
                    self.imageView.image = image
                }
            case .Failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}
