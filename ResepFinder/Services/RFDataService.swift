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
        RECIPE_REF.observe(.value) { (snapshot) in
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
    
    func showProgress() {
        
    }
    
    func dismissProgress() {
        
    }
}
