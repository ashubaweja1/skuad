//
//  ImageList.swift
//  Skuad
//
//  Created by Ashu Baweja on 19/08/20.
//  Copyright © 2020 iOS Developer. All rights reserved.
//

import Foundation

/// ImageList is the model class used to diplay image list
class ImageList: NSObject {
    
    // MARK: Variables
    var totalImages: Int?
    var images = [Image]()
    
    
    // MARK:  Initialization Methods
    override init() {
    }
    
    /// This method will initialize the image list model
    /// - Parameter json: json object received from server
    init(json: [String: Any]) {
        totalImages = json[kTotalHits] as? Int
        
        if let imageArray = json[kHits] as? [[String: Any]] {
            for imageJson in imageArray {
                let image = Image(json: imageJson)
                images.append(image)
            }
        }
    }
}

/// Image is the model class used to diplay single image
class Image: NSObject {
    
    // MARK: Variables
    var id: Int?
    var downloads: Int?
    var likes: Int?
    var favorites: Int?
    var userImageURL: String?
    
    
    // MARK:  Initialization Methods
    override init() {
    }
    
    /// This method will initialize the image model
    /// - Parameter json: json object received from server
    init(json: [String: Any]) {

        id = json[kId] as? Int
        downloads = json[kDownloads] as? Int
        likes = json[kLikes] as? Int
        favorites = json[kFavorites] as? Int
        userImageURL = json[kUserImageURL] as? String
    }
}
