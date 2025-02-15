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
   
    func createRecipeWith(title: String, desc: String, difficulty: String, serving: String, time: String, ingredients: [String], steps: [[String:Any]], recipeImg: UIImage, userData: RFUser){
        self.showProgress()
        
        let uid = userData.uid
    
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
                    
                    var recipes:[String:Any] = ["title" : title, "description": desc, "difficulty": difficulty, "serving": serving, "time": time,"userId" : uid!, "pathToImage" : downloadUrl, "peopleWhoLikes" : [String:AnyObject](), "creator" : username, "recipeID" : key, "ingredients" : ingredients]
                    recipes["steps"] = steps
                    
                    let recipeFeed = ["\(key)" : recipes]
                
                    self.RECIPE_REF.child(userData.region!).updateChildValues(recipeFeed)
                    
                    
                })
            }
        }
        
        uploadTask.resume()
        self.dismissProgress()
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
    
    func removeRecipeBy(_ recipeID: String){
        let uid = Auth.auth().currentUser?.uid
        USER_SHOPPING_LIST_REF.child(uid!).child(recipeID).removeValue()
    }
    
    func addRecipeToLoved(recipeID: String, location: String){
        let keyToPost = RECIPE_REF.childByAutoId().key
        let uid = Auth.auth().currentUser?.uid
        let body: [String : Any] = [
            "peopleWhoLikes/\(keyToPost!)" : uid!
        ]
        
        RECIPE_REF.child(location).child(recipeID).updateChildValues(body)
        print("Successfully loved")
        
    }
    
    func removeLove(recipeID: String, location: String){
        let uid = Auth.auth().currentUser?.uid
        RECIPE_REF.child(location).child(recipeID).child("peopleWhoLikes").queryOrderedByKey().observeSingleEvent(of: .value) { (snapshot) in
            if let peopleWhoLikes = snapshot.value as? [String:AnyObject]{
                for (id, val) in peopleWhoLikes {
                    if val as? String == uid {
                        self.RECIPE_REF.child(location).child(recipeID).child("peopleWhoLikes").child(id).removeValue()
                    }
                }
            }
        }
    }
    
    private func createUserDB(uid: String, data: Dictionary<String,Any>){
        //USER_REF.child(uid).updateChildValues(data)
        USER_REF.child(uid).setValue(data)
    }

    
}

