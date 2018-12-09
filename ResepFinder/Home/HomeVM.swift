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
    var totalRecipes: Int = 0
    
    init(vc: HomeInput) {
        self.viewController = vc
    }
    
    func retrieveRecipes() {
        self.service.getAllRecipes(completion: { (arrOfRecipe) in
            self.totalRecipes = arrOfRecipe.count
            self.recipes = arrOfRecipe
            self.viewController?.setupData(vm: self)
        })
        
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

