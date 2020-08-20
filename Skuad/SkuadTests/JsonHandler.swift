//
//  JsonHandler.swift
//  SkuadTests
//
//  Created by Ashu Baweja on 20/08/20.
//  Copyright © 2020 iOS Developer. All rights reserved.
//

import Foundation

class JsonHandler{
    
    class func readJson(fileName: String) -> [String: Any] {
        var response = [String: Any]()
        do {
            if let file = Bundle(for: SkuadTests.self).url(forResource: fileName, withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let jsonDict = json as? [String: Any] {
                    response = jsonDict
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        return response
    }
}

