//
//  Array+Ex.swift
//  ResepFinder
//
//  Created by William Huang on 22/12/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
    func containsData(_ array: [Element]) -> Bool {
        for item in array {
            if !self.contains(item) { return false }
        }
        return true
    }
}
