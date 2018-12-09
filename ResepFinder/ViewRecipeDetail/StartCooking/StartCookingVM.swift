//
//  StartCookingVM.swift
//  ResepFinder
//
//  Created by William Huang on 07/12/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import Foundation

class StartCookingVM {
    var steps: [RFStep]?
    var recipeImg: String?
    
    init(data: [RFStep], recipeImg: String) {
        self.steps = data
        self.recipeImg = recipeImg
    }
}
