//
//  ProfileVM.swift
//  ResepFinder
//
//  Created by William Huang on 30/11/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import Foundation
import FirebaseAuth

class ProfileVM: NSObject {
    private let service = RFAuthService()
    private weak var viewController: ProfileInput?
    var recipeCollectionVM: ProfileRecipeCollectionVM?
    
    var totalRecipes: Int = 0
    
    init(vc: ProfileInput) {
        self.viewController = vc
        self.recipeCollectionVM = ProfileRecipeCollectionVM()
    }
    
    func retrieveUserDetail() {
        self.service.retrieveUserDetail { (user) in
            self.service.getRecipes(forUid: user.uid!) { (arrOfRecipe) in
                user.recipes = arrOfRecipe
                self.recipeCollectionVM?.recipes = arrOfRecipe
                self.viewController?.setupDescriptionCell(user: user, recipeVM: self.recipeCollectionVM ?? ProfileRecipeCollectionVM())
            }
        }
    }
    
    func hasRecipes() -> Bool{
        return totalRecipes == 0 ? false : true
    }
    
    func recipesListHeight() -> CGFloat{
        let numberOfItem = ceil(CGFloat(totalRecipes)/2)
        let itemWidth = RFScreenHelper.screenWidth() / 2 - 32
        let paddingRow: CGFloat = 32 + 32
        let cellWidth: CGFloat = (itemWidth + paddingRow) * numberOfItem
        return cellWidth + paddingRow - 24
      
    }

}
