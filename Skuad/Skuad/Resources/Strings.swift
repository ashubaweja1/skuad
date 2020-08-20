//
//  Strings.swift
//  Skuad
//
//  Created by Ashu Baweja on 20/08/20.
//  Copyright © 2020 iOS Developer. All rights reserved.
//

import Foundation

extension String {
    
    // This method will trim the string
    func trim() -> String {
        let trimmedString = self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return trimmedString
    }
    
    // This method will encode string
    func encode() -> String {
        let encodedString = self.trim().addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        return encodedString ?? ""
    }
}
