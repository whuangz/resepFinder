//
//  RFRecipe.swift
//  ResepFinder
//
//  Created by William Huang on 02/12/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import Foundation

class RFRecipe: NSObject {
    
    var id: String?
    var recipePathToImg: String?
    var title: String?
    var desc: String?
    var difficulty: String?
    var numberOfServing: String?
    var time: String?
    var ingredients: [RFIngredient]?
    var steps: [RFStep]?
    var uid: String?
    var like: Int?
    var creator: String?
    
    override init(){
        
    }
    
    init(id: String, path: String, title: String, desc: String, difficulty: String, num: String, time: String, ingredients: [RFIngredient], steps: [RFStep], userID: String, like: Int, creator: String?){
        self.id = id
        self.recipePathToImg = path
        self.title = title
        self.desc = desc
        self.difficulty = difficulty
        self.numberOfServing = num
        self.time = time
        self.ingredients = ingredients
        self.steps = steps
        self.uid = userID
        self.like = like
        self.creator = creator
    }
    
    func getRecipesDescription() -> [String]?{
        var ingDesc = [String]()
        for item in self.ingredients! {
            ingDesc.append(item.description!)
        }
        
        return ingDesc
    }
}

