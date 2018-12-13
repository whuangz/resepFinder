//
//  RFViewRecipeVM.swift
//  ResepFinder
//
//  Created by William Huang on 05/12/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import Foundation

class RFViewRecipeVM {
    var recipe: RFRecipe?
    var service = RFRecipeService()
    
    init(data: RFRecipe) {
        self.recipe = data
    }
}
