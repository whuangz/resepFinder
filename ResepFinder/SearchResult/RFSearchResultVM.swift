//
//  RFSearchResultVM.swift
//  ResepFinder
//
//  Created by William Huang on 17/12/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import Foundation

class RFSearchResultVM {
    
    var titleName: String?
    private var service = RFDataService()
    private var location: String?
    var listOfRecipes: [RFRecipe]?
    
    init(title: String, location:String) {
        self.titleName = title
        self.location = location
    }
    
    init(listOfRecipes: [RFRecipe]) {
        self.listOfRecipes = listOfRecipes
    }
    
    func getListOfQueriedRecipes(completion: @escaping (_ recipe: [RFRecipe])->()){
        self.service.getRecipesBy(location: self.location ?? "", withTitle: self.titleName ?? "") { (listOfRecipes) in
            completion(listOfRecipes)
        }
    }
    
}
