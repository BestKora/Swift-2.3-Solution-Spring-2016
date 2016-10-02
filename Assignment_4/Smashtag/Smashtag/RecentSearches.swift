//
//  RecentSearches.swift
//  Smashtag
//
//  Created by Tatiana Kornilova on 7/9/15.
//  Copyright (c) 2015 Stanford University. All rights reserved.
//

import Foundation

struct RecentSearches {
    private static let defaults = NSUserDefaults.standardUserDefaults()
    private static let key = "RecentSearces"
    private static let limit = 100
    
    static var searches: [String] {
        return (defaults.objectForKey(key) as? [String]) ?? []
    }
    
    static func add(term: String) {
        var newArray = searches.filter({ term.caseInsensitiveCompare($0) != .OrderedSame })
        newArray.insert(term, atIndex: 0)
        while newArray.count > limit {
            newArray.removeLast()
        }
        defaults.setObject(newArray, forKey:key)
    }
    
    static func removeAtIndex(index: Int) {
        var currentSearches = (defaults.objectForKey(key) as? [String]) ?? []
        currentSearches.removeAtIndex(index)
        defaults.setObject(currentSearches, forKey:key)
    }
}