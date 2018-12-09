//
//  RFIngredient.swift
//  ResepFinder
//
//  Created by William Huang on 02/12/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import Foundation

class RFIngredient{
    var id: NSNumber?
    var description: String?
    
    init(id: NSNumber, description: String) {
        self.id = id
        self.description = description
    }
}

class RFStep {
    var id: Int?
    var description: String?
    var imgPath: String?
    var img: UIImage?
    
    init(id: Int, description: String, imgPath: String) {
        self.id = id
        self.description = description
        self.imgPath = imgPath
    }
    
    init(id: Int, description: String, img: UIImage) {
        self.id = id
        self.description = description
        self.img = img
    }
}
