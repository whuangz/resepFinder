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
    var recipeID: String?
    private var service = RFDataService()
    
    init(data: [RFStep], recipeImg: String, recipeID: String) {
        self.steps = data
        self.recipeImg = recipeImg
        self.recipeID = recipeID
    }
    
    func submitReview(_ data: RFReview){
        self.service.reviewRecipe(data: data, recipeID: self.recipeID!)
    }
}
