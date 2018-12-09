//
//  ListOfIngredientsVM.swift
//  ResepFinder
//
//  Created by William Huang on 09/12/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import Foundation

class ListOfIngredientsVM {
    
    let service = RFRecipeService()
    
    func getSavedIngredients(completion: @escaping (_ recipes: [RFRecipe])->()){
        self.service.getListOfSavedIngredients { (recipes) in
            completion(recipes)
        }
    }
    
}
