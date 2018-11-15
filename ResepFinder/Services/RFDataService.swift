//
//  RFDataService.swift
//  ResepFinder
//
//  Created by William Huang on 07/11/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import Foundation
import Firebase


class RFDataService: NSObject {
    
    private let _BASE_REF = Database.database().reference()
        
    var USER_REF: DatabaseReference {
        return _BASE_REF.child("users")
    }
        
    
    func showProgress() {
        
    }
    
    func dismissProgress() {
        
    }
}
