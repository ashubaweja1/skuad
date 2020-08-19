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
    
    func configureGalleryCell(image: Image){
        if let imageUrl = image.userImageURL, let url = URL(string: imageUrl) {
            weak var weakSelf = self
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    let data = try Data(contentsOf: url)
                    DispatchQueue.main.async {
                        weakSelf?.galleryImageView.image = UIImage(data: data)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
