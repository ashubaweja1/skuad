//
//  NetworkManager.swift
//  Skuad
//
//  Created by Ashu Baweja on 19/08/20.
//  Copyright © 2020 iOS Developer. All rights reserved.
//

import Foundation

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

