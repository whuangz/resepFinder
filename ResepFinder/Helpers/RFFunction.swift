//
//  RFFunction.swift
//  ResepFinder
//
//  Created by William Huang on 15/12/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import Foundation

class RFFunction: NSObject {
    static func getInitialname(name: String) -> Character {
        let initialName = (name.uppercased().characters.first)
        return initialName!
    }
}
