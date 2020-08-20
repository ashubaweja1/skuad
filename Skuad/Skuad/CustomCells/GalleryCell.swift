//
//  GalleryCell.swift
//  Skuad
//
//  Created by Ashu Baweja on 19/08/20.
//  Copyright © 2020 iOS Developer. All rights reserved.
//

import UIKit

class GalleryCell: UICollectionViewCell {
    
    @IBOutlet weak var galleryImageView: UIImageView!
    var galleryImage: Image?
    
    func configureGalleryCell(image: Image){
        self.galleryImage = image
        
        galleryImageView.image = UIImage(named: "placeHolder")
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
