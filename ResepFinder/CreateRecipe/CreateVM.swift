//
//  CreateVM.swift
//  ResepFinder
//
//  Created by William Huang on 02/12/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import Foundation

class CreateVM: NSObject {
    private let service = RFRecipeService()
    var recipeImg: UIImage?
    var recipeDetailVM: RecipeDetailVM!
    var createIngredientVM: CreateIngredientVM!
    var createStepVM: CreateStepVM!
    
    
    override init() {
        self.recipeDetailVM = RecipeDetailVM()
        self.createIngredientVM = CreateIngredientVM()
        self.createStepVM = CreateStepVM()
    }
    
    func sendData() -> Bool {
        
        guard let detailData = self.recipeDetailVM, let ingredientData = createIngredientVM, let stepData = createStepVM  else {return false}
        
        guard let recipeImg = self.recipeImg else {return false}
        
        let title = detailData.title.value
        let desc = detailData.desc.value
        let difficulty = detailData.difficulty.value
        
        let serving = ingredientData.servingTxt.value
        var ingredients = [String]()
        let sortedIngredient = Array((ingredientData.ingredientTxt)!).sorted(by: <)
        for (_,item) in sortedIngredient {
            ingredients.append(item)
        }
        
        let time = stepData.timeTxt.value
        let steps = stepData.getSteps()
        
        
        self.service.createRecipeWith(title: title, desc: desc, difficulty: difficulty, serving: serving, time: time, ingredients: ingredients, steps: steps, recipeImg: recipeImg)
        
        return true
        
    }
    
}



