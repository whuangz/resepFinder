//
//  RecommendVM.swift
//  ResepFinder
//
//  Created by William Huang on 20/12/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import Foundation

class RecommendVM {
    
    private var service = RFDataService()
    
    init() {
        
    }
    
    func findRecipeBasedOn(_ ingredients: [String], withLocation loc: String, completion: @escaping (_ listOfRecipes: [RFRecipe])->()){
        self.service.getRecipesBy(ingredients, withLocation: loc) { (listOfrecipes) in
            completion(listOfrecipes)
        }
    }
}
