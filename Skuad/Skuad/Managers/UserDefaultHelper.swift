//
//  UserDefaultHelper.swift
//  Skuad
//
//  Created by Ashu Baweja on 20/08/20.
//  Copyright © 2020 iOS Developer. All rights reserved.
//

import Foundation

// MARK: Constants
private let kSuggestionList = "SuggestionList"

/// UserDefaultHelper class is used to manage User Default System for managing data
class UserDefaultHelper {
    
    /// This method will set data in User Default System
    /// - Parameters:
    ///   - value: value that need to be saved
    ///   - key: key for which data need to be saved
    class func set(_ value : Any?, forkey key : String) {
        if let value = value {
            UserDefaults.standard.set(value, forKey: key)
        } else {
            UserDefaults.standard.removeObject(forKey: key)
        }
        UserDefaults.standard.synchronize()
    }
    
    /// This method is used to get data from User Default System
    /// - Parameter key: key for which data need to be fetched
    class func get(_ key : String) -> Any? {
        return UserDefaults.standard.object(forKey: key)
    }
    
    /// This method will save suggestion in User Defaults
    /// - Parameter suggestion: suggestion that need to be saved
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
    
    /// This method will return suggestion list available in User Default System
    class func getSuggestionList() -> [String] {
        var suggestions = [String]()
        if let suggestionList = UserDefaultHelper.get(kSuggestionList) as? [String] {
            suggestions = suggestionList
        }
        return suggestions
    }
}
