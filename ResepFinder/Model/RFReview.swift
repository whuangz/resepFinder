//
//  RFREview.swift
//  ResepFinder
//
//  Created by William Huang on 16/12/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import Foundation

class RFReview {
    var comment: String?
    var rating: NSNumber?
    var reviewer: String?
    private var service = RFDataService()
    
    init(comment: String, rating: NSNumber) {
        self.comment = comment
        self.rating = rating
    }
    
    init(comment: String, rating: NSNumber, reviewer: String) {
        self.comment = comment
        self.rating = rating
        self.reviewer = reviewer
    }
    
    func getReviewerName(completion: @escaping (_ name: String)->()){
        if let uid = reviewer {
            self.service.getUserName(forUid: uid) { (userName) in
                completion(userName)
            }
        }
    }
}
