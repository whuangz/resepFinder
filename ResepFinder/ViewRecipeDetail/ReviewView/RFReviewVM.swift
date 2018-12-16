//
//  RFReviewVM.swift
//  ResepFinder
//
//  Created by William Huang on 16/12/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import Foundation

class RFReviewVM {
    private var recipeID: String?
    private var service = RFDataService()
    
    init(recipeID: String) {
        self.recipeID = recipeID
    }
    
    func getListOfReviews(compeltion: @escaping (_ listOfReviews: [RFReview])->()) {
        self.service.getReviews(recipeID: self.recipeID ?? "") { (reviews) in
            compeltion(reviews)
        }
    }
}
