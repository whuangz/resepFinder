//
//  DetailIngredientsVM.swift
//  ResepFinder
//
//  Created by William Huang on 10/12/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import Foundation

class DetailIngredientsVM {
    var recipe: RFRecipe?
    
    init(data: RFRecipe) {
        self.recipe = data
    }
    
    func getIngredients() -> [String] {
        guard let recipe = self.recipe else {return [String]()}
        return recipe.getRecipesDescription() ?? [String]()
    }
}
