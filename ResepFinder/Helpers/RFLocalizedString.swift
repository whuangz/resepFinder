//
//  RFLocalizedString.swift
//  ResepFinder
//
//  Created by William Huang on 30/10/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import Foundation


class RFLocalizedString : NSObject{
    
    func forKey(_ key: String) -> String {
        let text = NSLocalizedString(key, tableName: "eng", value: key, comment: key)
        return text
    }
}
