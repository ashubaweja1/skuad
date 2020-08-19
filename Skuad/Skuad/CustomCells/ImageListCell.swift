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
    
    
    func configureImageCell(image: Image){
        downloadsLabel.text = String(image.downloads ?? 0)
        likesLabel.text = String(image.likes ?? 0)
        favouritesLabel.text = String(image.favorites ?? 0)
        
         if let imageUrl = image.userImageURL, let url = URL(string: imageUrl) {
             weak var weakSelf = self
             DispatchQueue.global(qos: .userInitiated).async {
                 do {
                     let data = try Data(contentsOf: url)
                     DispatchQueue.main.async {
                         weakSelf?.coverImageView.image = UIImage(data: data)
                     }
                 } catch {
                     print(error.localizedDescription)
                 }
             }
         }
    }
}
