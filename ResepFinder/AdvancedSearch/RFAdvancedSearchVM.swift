//
//  RFAdvancedSearchVM.swift
//  ResepFinder
//
//  Created by William Huang on 17/12/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import Foundation

class RFAdvancedSearchVM {
    private let service = RFDataService()
    private var locationName: String?
    
    init(locID: String) {
        self.locationName = RegionLoc(rawValue: locID)?.rawValue
    }
    
    func getRecipesBy(query: String, completion: @escaping (_ queriedRecipes: [RFRecipe]) ->()){
        self.service.getQueryRecipes(query: query, byLocation: self.locationName ?? "") { (queriedRecipes) in
            completion(queriedRecipes)
        }
    }
    
    func getLocation() -> String {
        return self.locationName ?? ""
    }
}
