//
//  RFLocationVM.swift
//  ResepFinder
//
//  Created by William Huang on 14/12/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import Foundation

class RFLocationVM {
    private var service = RFDataService()
    var locations = [RFLocation]()
    
    func getLocations(completion: @escaping (_ locations: [RFLocation])->()){
        self.service.getListOfLocations { (locations) in
            completion(locations)
        }
    }
}
