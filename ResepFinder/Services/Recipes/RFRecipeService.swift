//
//  RFRecipeService.swift
//  ResepFinder
//
//  Created by William Huang on 02/12/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage
import RxSwift

class RFRecipeService: RFDataService {
   
    func createRecipeWith(title: String, desc: String, difficulty: String, serving: String, time: String, ingredients: [String], steps: [[String:Any]], recipeImg: UIImage){
        
        let uid = Auth.auth().currentUser?.uid
    
        let key = RECIPE_REF.childByAutoId().key!
        let imgStorage = RECIPE_STORAGE_REF.child(uid!).child("\(key).jpg")
        
        let data = UIImageJPEGRepresentation(recipeImg, 0.6)
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        var username = ""
        self.getUserName(forUid: uid!) { (data) in
            username = data
        }
  
        let uploadTask = imgStorage.putData(data!, metadata: metaData) { (metadata,err) in
            if err != nil {
                print(err?.localizedDescription as Any)
                return
            }else {
                print("uploaded")
                
                imgStorage.downloadURL(completion: { (url, err) in
                    guard let downloadUrl = url?.absoluteString else {return}
                    
                    var recipes:[String:Any] = ["title" : title, "description": desc, "difficulty": difficulty, "serving": serving, "time": time,"userId" : uid!, "pathToImage" : downloadUrl, "likes" : 0, "creator" : username, "recipeID" : key, "ingredients" : ingredients]
                    recipes["steps"] = steps
                    
                    let recipeFeed = ["\(key)" : recipes]
                
                    self.RECIPE_REF.updateChildValues(recipeFeed)
                    
                    
                })
            }
        }
        
        uploadTask.resume()
    }
    
    func addRecipeToMyList(recipeID: String, recipeTitle: String, recipeImgPath: String, ingredients: [String]){
        let uid = Auth.auth().currentUser?.uid
	        let body: [String : Any] = [
            "title" : recipeTitle,
            "path" : recipeImgPath,
            "ingredients": ingredients,
        ]
        USER_SHOPPING_LIST_REF.child(uid!).child(recipeID).updateChildValues(body)
        print("Added to my shopping list")
        
    }
    
    func validateAddedIngredient(recipeID: String, completion: @escaping (_ completion: Bool)->()) {
        self.checkAddedIngredientToUser(recipeID: recipeID) { (status) in
            completion(status)
        }
        
    }
    
    private func createUserDB(uid: String, data: Dictionary<String,Any>){
        //USER_REF.child(uid).updateChildValues(data)
        USER_REF.child(uid).setValue(data)
    }

    
}

