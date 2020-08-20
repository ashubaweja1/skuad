//
//  ImageListCell.swift
//  Skuad
//
//  Created by Ashu Baweja on 19/08/20.
//  Copyright © 2020 iOS Developer. All rights reserved.
//

import UIKit

class ImageListCell: UITableViewCell {
    
    @IBOutlet weak var downloadsLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var favouritesLabel: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    
    var galleryImage: Image?
    
    
    func configureImageCell(image: Image){
        self.galleryImage = image
        
        downloadsLabel.text = String(image.downloads ?? 0)
        likesLabel.text = String(image.likes ?? 0)
        favouritesLabel.text = String(image.favorites ?? 0)
        
        coverImageView.image = UIImage(named: "placeHolder")
        weak var weakSelf = self
        if let imageUrl = image.userImageURL {
            coverImageView.downloadImage(url: imageUrl) { (url, image) in
                DispatchQueue.main.async {
                    if self.galleryImage?.userImageURL == url {
                        weakSelf?.coverImageView.image = image
                    }
                }
            }
        }
    }
}
