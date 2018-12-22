//
//  UserDefaults+Ext.swift
//  ResepFinder
//
//  Created by William Huang on 22/12/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import Foundation

extension UserDefaults{

    func setLocation(value: String){
        set(value, forKey: "Location")
        //synchronize()
    }
    
    //MARK: Retrieve User Data
    func getLocation() -> String{
        return string(forKey: "Location")!
    }
}
