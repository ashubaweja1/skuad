//
//  NetworkManager.swift
//  Skuad
//
//  Created by Ashu Baweja on 19/08/20.
//  Copyright © 2020 iOS Developer. All rights reserved.
//

import Foundation
import UIKit

enum RequestType: String {
    case Post = "POST"
    case Get = "GET"
    case Put = "PUT"
}

class NetworkManager: NSObject {
    
    /// This method will send request to server
    /// - Parameter requestUrl: request url
    /// - Parameter type: type of request
    /// - Parameter params: params that need to be send
    /// - Parameter completionHandler: json response or error received from server
    
    class func sendRequest(requestUrl: String, type: RequestType, params: [String: Any]? = nil, completionHandler : ((_ json : Any?, _ error: Error?) -> Void)? = nil) {
        
        let url: URL = URL(string: requestUrl)!
        var request: URLRequest = URLRequest(url: url)
        let timeout: TimeInterval = 30.0
        request.timeoutInterval = timeout
        request.httpMethod = type.rawValue
        
        if type != .Get {
            let postData = try? JSONSerialization.data(withJSONObject: params ?? [], options: JSONSerialization.WritingOptions.prettyPrinted)
            request.httpBody = postData
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let sessionConfiguration = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfiguration, delegate: nil, delegateQueue: nil)
        
        let sessionTask = session.dataTask(with: request) { (data, response, error) in
            
            if error == nil {
                let httpResponse = response as! HTTPURLResponse
                
                let jsonResult: AnyObject?
                do {
                    jsonResult = try JSONSerialization.jsonObject(with: data!,
                                                                  options: JSONSerialization.ReadingOptions.allowFragments) as AnyObject
                } catch _ as NSError {
                    jsonResult = nil
                }

                if httpResponse.statusCode == 200 {
                    completionHandler?(jsonResult, nil)
                }
                else {
                    completionHandler?(nil, nil)
                }
            }
            else{
                completionHandler?(nil, error)
            }
            
        }
        sessionTask.resume()
    }
}

extension UIImageView {
    func downloadImage(url: String, completionHandler: @escaping (String, UIImage?) -> Void) -> Void {
        
        guard let imageUrl = URL(string: url) else {
            return
        }
        
        let cache = URLCache.shared
        let request = URLRequest(url: imageUrl)
        
        DispatchQueue.global(qos: .userInitiated).async {
            if let data = cache.cachedResponse(for: request)?.data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completionHandler(url, image)
                }
            } else {
                URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                    
                    if let data = data, let response = response, ((response as? HTTPURLResponse)?.statusCode ?? 500) < 300, let image = UIImage(data: data) {
                        let cachedData = CachedURLResponse(response: response, data: data)
                        cache.storeCachedResponse(cachedData, for: request)
                        DispatchQueue.main.async {
                            completionHandler(url, image)
                        }
                    }
                }).resume()
            }
        }
    }
}

