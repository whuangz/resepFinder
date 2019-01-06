//
//  Array+Ex.swift
//  ResepFinder
//
//  Created by William Huang on 22/12/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import Foundation

extension Array where Element: NSString {
    func containsData(_ array: [String]) -> Bool {
        var flagged = 0
        let lowerIngredientsData = self.map {($0 as! String).lowercased()}
        for item in array {
            for listItem in lowerIngredientsData {
                if listItem.contains(item) {
                    flagged += 1
                    break
                }
            }
        }
        
        if flagged >= 3 {
            return true
        }else{
            return false
        }
    }
}
