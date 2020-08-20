//
//  SearchHandler.swift
//  Skuad
//
//  Created by Ashu Baweja on 19/08/20.
//  Copyright © 2020 iOS Developer. All rights reserved.
//

import Foundation

/// SearchHandler class is used to manage business logic of Search VC
class SearchHandler {
    
    /// This method will fetch image list from server
    /// - Parameters:
    ///   - searchedText: search keyword
    ///   - page: page num for pagination
    ///   - completionHandler: return image list & error
    class func fetchImages(searchedText: String, page: Int, completionHandler: ((ImageList?, _ error : Error?) -> Void)? = nil) {
        let url = "\(kBaseUrl)?\(kKey)=\(kApiKey)&\(kQuery)=\(searchedText)&\(kImageType)=\(kPhoto)&\(kPage)=\(String(describing: page))"
        NetworkManager.sendRequest(requestUrl: url, type: .Get, params: nil) { (json, error) in
            
            let imageList = parseImageList(json: json)
            completionHandler?(imageList, error)
        }
    }
    
    /// This method is used to fill ImageList model using json received from server
    /// - Parameter json: json received from server
    class func parseImageList(json: Any?) -> ImageList?{
        var imageList: ImageList?
        
        if let listJson = json as? [String: Any]{
            imageList = ImageList(json: listJson)
        }
        return imageList
    }
}

