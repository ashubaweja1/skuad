//
//  GalleryCell.swift
//  Skuad
//
//  Created by Ashu Baweja on 19/08/20.
//  Copyright © 2020 iOS Developer. All rights reserved.
//

import UIKit

/// GalleryCell class is used to display gallery image on Gallery VC
class GalleryCell: UICollectionViewCell {
    // MARK: IBOutlets
    @IBOutlet weak var galleryImageView: UIImageView!
    
     // MARK: Variables
    var galleryImage: Image?
    
    // MARK:  Methods
    /// This method will configure Gallery Cell
    /// - Parameter image: Image model object
    func configureGalleryCell(image: Image){
        self.galleryImage = image
        
        galleryImageView.image = UIImage(named: kPlaceHolderImage)
        weak var weakSelf = self
        if let imageUrl = image.userImageURL {
            galleryImageView.downloadImage(url: imageUrl) { (url, image) in
                DispatchQueue.main.async {
                    if self.galleryImage?.userImageURL == url {
                        weakSelf?.galleryImageView.image = image
                    }
                }
            }
        }
    }
}
