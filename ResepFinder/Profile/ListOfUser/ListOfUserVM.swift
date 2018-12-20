//
//  ListOfUserVM.swift
//  ResepFinder
//
//  Created by William Huang on 19/12/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import Foundation

class ListOfUserVM {
    
    let service = RFRecipeService()
    var listOfUID: [String]?
    var title: String?
    
    init(uids: [String], title: String) {
        self.listOfUID = uids
        self.title = title
    }
    
    func getListOfUser(completion: @escaping (_ users: [RFUser])->()){
        self.service.getListOfUserByUid(uids: self.listOfUID ?? [String]()) { (listOfUsers) in
            completion(listOfUsers)
        }
    }
    
    
}
