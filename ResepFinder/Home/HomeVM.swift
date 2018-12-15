//
//  HomeVM.swift
//  ResepFinder
//
//  Created by William Huang on 05/12/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import Foundation
import FirebaseAuth

class HomeVM: NSObject {
    private let service = RFAuthService()
    private weak var viewController: HomeInput?
    private var recipes: [RFRecipe]?
    var location: String?
    var totalRecipes: Int = 0
    
    init(vc: HomeInput) {
        self.viewController = vc
        
        self.service.getReviews(recipeID: "-LTlpUUsa04x6cO7GL4w") { (reviews) in
            print(reviews)
        }
    }
    
    func retrieveRecipesWith(defaultLocationID: String) {
        self.service.getLocationBy(defaultLocationID) { (location) in
            self.service.getAllRecipesWith(from: location, completion: { (arrOfRecipe) in
                self.totalRecipes = arrOfRecipe.count
                self.location = location.name!
                self.recipes = arrOfRecipe.reversed()
                self.viewController?.setupData(vm: self)
            })
        }
    }
    
    func getRecipes() -> [RFRecipe]{
        guard let recipes = self.recipes else {return [RFRecipe]()}
        return recipes
    }
    
    func hasRecipes() -> Bool{
        return totalRecipes == 0 ? false : true
    }
    
}

protocol HomeInput: class {
    func setupData(vm: HomeVM)
}

