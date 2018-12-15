//
//  RFDataService.swift
//  ResepFinder
//
//  Created by William Huang on 07/11/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage

class RFDataService: NSObject {
    
    private let _BASE_DB_REF = Database.database().reference()
    private let _BASE_STORAGE_REF = Storage.storage().reference()
    static let instance = RFDataService()
    
    var USER_REF: DatabaseReference {
        return _BASE_DB_REF.child("users")
    }
    var RECIPE_REF: DatabaseReference {
        return _BASE_DB_REF.child("recipes")
    }
    var RECIPE_STORAGE_REF: StorageReference {
        return _BASE_STORAGE_REF.child("recipes")
    }
    var CONVERSATION_REF: DatabaseReference {
        return _BASE_DB_REF.child("conversation")
    }
    var USER_SHOPPING_LIST_REF: DatabaseReference {
        return _BASE_DB_REF.child("usershoppinglist")
    }
    var FOLLOW_RELATION_REF: DatabaseReference {
        return _BASE_DB_REF.child("followRelation")
    }
    var LOCATION_REF: DatabaseReference {
        return _BASE_DB_REF.child("Location")
    }
    
    func getListOfLocations(handler: @escaping (_ location: [RFLocation])->()){
        LOCATION_REF.observeSingleEvent(of: .value) { (dataSnapShot) in
            var arrOfLocations = [RFLocation]()
            guard let dataSnap = dataSnapShot.children.allObjects as? [DataSnapshot] else {return}
            for location in dataSnap{
                let l = RFLocation(id: location.key, name: location.value as! String)
                arrOfLocations.append(l)
            }
            handler(arrOfLocations)
        }
    }
    
    func getUserName(forUid uid: String, handler: @escaping (_ userName: String)->()){
        USER_REF.observeSingleEvent(of: .value) { (userSnapshot) in
            guard let usersSnapShot = userSnapshot.children.allObjects as? [DataSnapshot] else {return}
            for user in usersSnapShot {
                if user.key == uid {
                    handler(user.childSnapshot(forPath: "username").value as! String)
                }
            }
        }
    }
    
    func getUser(forUid uid: String, handler: @escaping (_ userName: RFUser)->()){
        USER_REF.observeSingleEvent(of: .value) { (userSnapshot) in
            guard let usersSnapShot = userSnapshot.children.allObjects as? [DataSnapshot] else {return}
            for user in usersSnapShot {
                if user.key == uid {
                    let userName = user.childSnapshot(forPath: "username").value as! String
                    let user = RFUser(uid: uid, username: userName)
                    handler(user)
                }
            }
        }
    }

    func getRecipes(forUid uid: String, completion: @escaping (_ recipe: [RFRecipe]) -> ()){
        RECIPE_REF.observe(.value) { (snapshot) in
            guard let recipeSnapShot = snapshot.children.allObjects as? [DataSnapshot] else {return}
            var recipes = [RFRecipe]()
            for recipe in recipeSnapShot {
                let userID = recipe.childSnapshot(forPath: "userId").value as! String
                if userID == uid {
                    if let data = recipe.value as? Dictionary<String,AnyObject> {
                        recipes.append(self.appendRecipes(data))
                    }
                }
            }
            
            completion(recipes)
        }
    }
    
    func getAllUsers(query: String, completion: @escaping (_ users: [RFUser]) -> ()){
        let currentUser = Auth.auth().currentUser?.uid
        var users = [RFUser]()
        USER_REF.observe(.value) { (snapshot) in
            guard let userSnapshot = snapshot.children.allObjects as? [DataSnapshot] else {return}
            
            for user in userSnapshot {
                let uid = user.childSnapshot(forPath: "uid").value as! String
                let name = user.childSnapshot(forPath: "username").value as! String
                
                if uid != currentUser {
                    if name.caseInsensitiveCompare(query) == .orderedSame || name.contains(query){
                        let user = RFUser(uid: uid, username: name)
                        users.append(user)
                    }
                }
                
            }
            completion(users)
        }
    }
    
    func getAllRecipes(completion: @escaping (_ recipe: [RFRecipe]) -> ()){
        RECIPE_REF.queryOrderedByKey().observe(.value) { (snapshot) in
            guard let recipeSnapShot = snapshot.children.allObjects as? [DataSnapshot] else {return}
            var recipes = [RFRecipe]()
            for recipe in recipeSnapShot {
                if let data = recipe.value as? Dictionary<String,AnyObject> {
                    recipes.append(self.appendRecipes(data))
                }
            }
            
            completion(recipes)
        }
    }
    
    func getConversationUsername(conversation: RFConversation, handler: @escaping (_ username: [String])->()) {
        var usernames = [String]()
        let uid = Auth.auth().currentUser?.uid
        USER_REF.observe(.value) { (userSnapShot) in
            guard let userSnapShot = userSnapShot.children.allObjects as? [DataSnapshot] else {return}
            for user in userSnapShot{
                if user.key != uid {
                    if conversation.roomMembers.contains(user.key){
                        let username = user.childSnapshot(forPath: "username").value as! String
                        
                        usernames.append(username)
                    }
                }
            }
            handler(usernames)
        }
    }
    
    
    private func appendRecipes(_ data: Dictionary<String,AnyObject>) -> RFRecipe{
        
            let recipeID = data["recipeID"] as? String ?? ""
            let creator = data["creator"] as? String ?? ""
            let uid = data["userId"] as? String ?? ""
            let title = data["title"] as? String ?? ""
            let desc = data["description"] as? String ?? ""
            let difficulty = data["difficulty"] as? String ?? ""
            let serving = data["serving"] as? String ?? ""
            let time = data["time"] as? String ?? ""
            let pathToImg = data["pathToImage"] as? String ?? ""
            let likes = data["likes"] as? Int ?? 0
            var ingredients = [RFIngredient]()
            var steps = [RFStep]()
            
        if let dataIngredients = data["ingredients"] as? [String], let dataSteps = data["steps"] as? [[String:Any]] {
                
                for(idx, value) in dataIngredients.enumerated() {
                    ingredients.append(RFIngredient(id: NSNumber(value: Int(idx) + 1) , description: value ))
                }

                for(idx, value) in dataSteps.enumerated() {
                    let idx = idx
                    let step = RFStep(id: idx, description: value["desc"] as? String ?? "", imgPath: value["imgPath"] as? String ?? "")
                    steps.append(step)
                }
            }

            let recipe = RFRecipe(id: recipeID, path: pathToImg, title: title, desc: desc, difficulty: difficulty, num: serving, time: time, ingredients: ingredients, steps: steps, userID: uid, like: likes, creator: creator)
            return recipe
        
    }
    
    func getListOfSavedIngredients(completion: @escaping (_ recipe: [RFRecipe]) -> ()){
        let uid = Auth.auth().currentUser?.uid
        USER_SHOPPING_LIST_REF.observeSingleEvent(of: .value) { (snapshot) in
            guard let dataSnapshot = snapshot.children.allObjects as? [DataSnapshot] else {return}
            var returnedRecipes = [RFRecipe]()
            
            for dataKey in dataSnapshot {
                if dataKey.key == uid {
                    if let recipes = dataKey.children.allObjects as? [DataSnapshot] {
                        
                        for rcp in recipes {
                            var ingredients = [RFIngredient]()
                            
                            let id =  rcp.key
                            let title = rcp.childSnapshot(forPath: "title").value as! String
                            let path = rcp.childSnapshot(forPath: "path").value as! String
                            if let dataIngredients = rcp.childSnapshot(forPath: "ingredients").value as? [String] {
                                
                                for(idx, value) in dataIngredients.enumerated() {
                                    ingredients.append(RFIngredient(id: NSNumber(value: Int(idx) + 1) , description: value ))
                                }
                                
                            }
                            returnedRecipes.append(RFRecipe(id: id, path: path, title: title, ingredients: ingredients))
                        }
                    }
                }
            }
            
            completion(returnedRecipes)
        }
    }
    
    func checkAddedIngredientToUser(recipeID: String, completion: @escaping (_ status: Bool) -> ()){
        let uid = Auth.auth().currentUser?.uid
        USER_SHOPPING_LIST_REF.child(uid!).observeSingleEvent(of: .value) { (snapshot) in
            guard let dataSnapshot = snapshot.children.allObjects as? [DataSnapshot] else {return}
            
            if dataSnapshot.count == 0 {
                completion(false)
            }
            
            for dataKey in dataSnapshot {
                if dataKey.key == recipeID {
                    completion(true)
                    break
                }else{
                    completion(false)
                }
            }
        }
    }
    
    func checkLovedRecipe(recipeID: String, completion: @escaping (_ status: Bool) -> ()){
        let uid = Auth.auth().currentUser?.uid
        RECIPE_REF.child(recipeID).observeSingleEvent(of: .value) { (snapshot) in
            guard let dataSnap = snapshot.value as? [String:AnyObject] else {return}
            if let peopleWhoLikes = dataSnap["peopleWhoLikes"] as? [String:AnyObject] {
                for (id, person) in peopleWhoLikes {
                    if person as? String == uid {
                        completion(true)
                        break
                    }else{
                        completion(false)
                    }
                }
            }else{
                completion(false)
            }
        }
    }
    
    func checkFollowRelation(userID: String, completion: @escaping (_ status: Bool) -> ()){
        let uid = Auth.auth().currentUser?.uid
        FOLLOW_RELATION_REF.child(uid!).child("followings").queryOrderedByKey().observeSingleEvent(of: .value) { (snapshot) in
            
            if let followings = snapshot.value as? [String:AnyObject]  {
                for (id, val) in followings {
                    if val as? String == userID {
                        completion(true)
                        break
                    }else{
                        completion(false)
                    }
                }
            }else{
                completion(false)
            }
        }
    }
    
    func getNumberOfFollowings(completion: @escaping (_ data: [Int:[String]]) -> ()) {
        let uid = Auth.auth().currentUser?.uid
        FOLLOW_RELATION_REF.child(uid!).observeSingleEvent(of: .value) { (snapshot) in
            guard let dataSnap = snapshot.value as? [String:Any] else {return}
            var followings = [String]()
            var followers = [String]()
            
            
            if let followingsData = dataSnap["followings"] as? [String:AnyObject]  {
                for (_,v) in followingsData {
                    followings.append((v as? String)!)
                }
            }
            
            if let followersData = dataSnap["followers"] as? [String:AnyObject] {
                for (_,v) in followersData {
                    followers.append((v as? String)!)
                }
            }
            
            let followTable = [ 0: followings, 1: followers ]
            completion(followTable)
        }
    }
    
    //Following Relation
    func addFollowing(userID: String){
        let uid = Auth.auth().currentUser?.uid
        if userID != uid {
            let key = FOLLOW_RELATION_REF.childByAutoId().key
            let followingData: [String:Any] = ["followings/\(key!)" : userID]
            let followerData: [String:Any] = ["followers/\(key!)" : uid!]
            FOLLOW_RELATION_REF.child(uid!).updateChildValues(followingData)
            FOLLOW_RELATION_REF.child(userID).updateChildValues(followerData)
        }
    }
    
    func removeFollowing(userID: String){
        let uid = Auth.auth().currentUser?.uid
        if userID != uid {
            FOLLOW_RELATION_REF.child(uid!).child("followings").queryOrderedByKey().observeSingleEvent(of: .value) { (snapShot) in
                if let followings = snapShot.value as? [String:AnyObject]{
                    for (id, val) in followings {
                        if val as? String == userID {
                            self.FOLLOW_RELATION_REF.child(uid!).child("followings/\(id)").removeValue()
                            self.FOLLOW_RELATION_REF.child(userID).child("followers/\(id)").removeValue()
                        }
                    }
                }
            }
        }
    }
    
    
    func showProgress() {
        
    }
    
    func dismissProgress() {
        
    }
}
