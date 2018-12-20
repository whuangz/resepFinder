//
//  User.swift
//  ResepFinder
//
//  Created by William Huang on 30/11/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import Foundation

class RFUser: NSObject {
    var uid: String?
    var username: String?
    var email: String?
    var region: String?
    var follower: [String]?
    var following: [String]?
    var recipes: [RFRecipe]?

    init(uid: String, username: String, location: String = "") {
        self.uid = uid
        self.username = username
        self.region = location
    }
    
    init(uid: String, username: String, email: String, region: String, followers: [String] = [], followings: [String] = []) {
        self.uid = uid
        self.username = username
        self.email = email
        self.region = region
        self.follower = followers
        self.following = followings
    }
}
