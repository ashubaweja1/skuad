//
//  ImageList.swift
//  Skuad
//
//  Created by Ashu Baweja on 19/08/20.
//  Copyright © 2020 iOS Developer. All rights reserved.
//

import Foundation

class ImageList: NSObject {
    
    var totalImages: Int?
    var images = [Image]()
    
    override init() {
    }
    
    /// This method will initialize the image detail model
    /// - Parameter json: json object received from server
    init(json: [String: Any]) {
        totalImages = json["totalHits"] as? Int
        
        if let imageArray = json["hits"] as? [[String: Any]] {
            for imageJson in imageArray {
                let image = Image(json: imageJson)
                images.append(image)
            }
        }
    }
}

class Image: NSObject {
    
    var id: Int?
    var downloads: Int?
    var likes: Int?
    var favorites: Int?
    var userImageURL: String?
    
    override init() {
    }
    
    /// This method will initialize the image model
    /// - Parameter json: json object received from server
    init(json: [String: Any]) {

        id = json["id"] as? Int
        downloads = json["downloads"] as? Int
        likes = json["likes"] as? Int
        favorites = json["favorites"] as? Int
        userImageURL = json["userImageURL"] as? String
    }
}
