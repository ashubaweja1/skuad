//
//  UserDefaultHelper.swift
//  Skuad
//
//  Created by Ashu Baweja on 20/08/20.
//  Copyright © 2020 iOS Developer. All rights reserved.
//

import Foundation

private let kSuggestionList = "SuggestionList"

class UserDefaultHelper {
    
    class func set(_ value : Any?, forkey key : String) {
        if let value = value {
            UserDefaults.standard.set(value, forKey: key)
        } else {
            UserDefaults.standard.removeObject(forKey: key)
        }
        UserDefaults.standard.synchronize()
    }
    
    class func get(_ key : String) -> Any? {
        return UserDefaults.standard.object(forKey: key)
    }
    
    class func addSuggestion(suggestion: String) {
        var suggestions = [String]()
        if let suggestionList = UserDefaultHelper.get(kSuggestionList) as? [String] {
            suggestions = suggestionList
            
            if let index = suggestionList.firstIndex(of: suggestion) {
                suggestions.remove(at: index)
            }
            
            if suggestions.count == 10 {
                suggestions.removeLast()
            }
        }
        
        suggestions.insert(suggestion, at: 0)
        UserDefaultHelper.set(suggestions, forkey: kSuggestionList)
    }
    
    class func getSuggestionList() -> [String] {
        var suggestions = [String]()
        if let suggestionList = UserDefaultHelper.get(kSuggestionList) as? [String] {
            suggestions = suggestionList
        }
        return suggestions
    }
}
