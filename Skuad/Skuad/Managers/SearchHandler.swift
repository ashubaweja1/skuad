//
//  SearchHandler.swift
//  Skuad
//
//  Created by Ashu Baweja on 19/08/20.
//  Copyright © 2020 iOS Developer. All rights reserved.
//

import Foundation

class SearchHandler {
    
    class func fetchImages(searchedText: String, page: Int, completionHandler: ((ImageList?, _ error : Error?) -> Void)? = nil) {
        let url = "\(kBaseUrl)?\(kKey)=\(kApiKey)&\(kImageType)=\(kPhoto)&\(kPage)=\(String(describing: page))"
        NetworkManager.sendRequest(requestUrl: url, type: .Get, params: nil) { (json, error) in
            
            let imageList = parseImageList(json: json)
            completionHandler?(imageList, error)
        }
    }
    
    class func parseImageList(json: Any?) -> ImageList?{
        var imageList: ImageList?
        
        if let listJson = json as? [String: Any]{
            imageList = ImageList(json: listJson)
        }
        return imageList
    }
}
