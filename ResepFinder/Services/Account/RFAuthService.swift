//
//  RegisterService.swift
//  ResepFinder
//
//  Created by William Huang on 07/11/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import Foundation
import Firebase
import RxSwift

class RFAuthService: RFDataService {
    
    func logoutUser() -> Bool{
        do{
            if Auth.auth().currentUser != nil {
                try Auth.auth().signOut()
                print("Log out Successfully")
                return true
            }
        }catch {
            print(error.localizedDescription)
        }
        print("not user found")
        return false
    }
    
    func loginWith(email: String, pwd: String) -> Observable<((AuthDataResult?, Error?))> {
        return Observable.create({ (observer) in
            Auth.auth().signIn(withEmail: email, password: pwd, completion: { (user, error) in
                if error == nil {
                    observer.onNext((user, error))
                    observer.onCompleted()
                }else{
                    observer.onNext((nil,error))
                }
            })
            return Disposables.create()
        })
    }
    
    func registerWithParameters(username: String, email: String, pwd: String, location: String) -> Observable<((User?, Error?))>{
        
        return Observable.create({ (observer) in
            Auth.auth().createUser(withEmail: email, password: pwd, completion: { (data, error) in
                if error == nil {
                    guard let user = data?.user else {return}
                
                    let userData:[String : Any] = ["uid" : user.uid, "username" : username, "email": email, "location": location]

                    self.createUserDB(uid: user.uid, data: userData)

                    observer.onNext((user, error))
                    observer.onCompleted()
                }else{
                    observer.onNext((nil, error))
                }
            })
            return Disposables.create()
        })
    }
    
    func retrieveUserDetail(completion: @escaping UserCompletion){
        guard let user = Auth.auth().currentUser else {return }
        USER_REF.child(user.uid).observe(.value) { (snapshot) in
            if let data = snapshot.value as? Dictionary<String,AnyObject> {
                let uid = data["uid"] as? String ?? ""
                let username = data["username"] as? String ?? ""
                let email = data["email"] as? String ?? ""
                let location = data["location"] as? String ?? ""
                var followers = [String]()
                var followings = [String]()
                var recipes = [String]()
                
                if let dataFollowers = data["followers"] as? [String:AnyObject], let dataFollowings = data["followings"] as? [String:AnyObject] {
                    for (_, value) in dataFollowers {
                        followers.append(value as! String)
                    }
                    
                    for (_, value) in dataFollowings {
                        followings.append(value as! String)
                    }
                    
                }
                
                let returnedUser = RFUser(uid: uid, username: username, email: email, region: location, followers: followers, followings: followings)
                completion(returnedUser)
            }
        }
        
        Database.database().reference().removeAllObservers()
    }
    
    private func createUserDB(uid: String, data: Dictionary<String,Any>){
        //USER_REF.child(uid).updateChildValues(data)
        USER_REF.child(uid).setValue(data)
    }
    
    private func createRecipeDetail(uid: String){
        let key = RECIPE_REF.childByAutoId().key!
        let author:[String:Any] = ["userId" : uid , "recipeID" : key]
        
        let recipes = ["\(key)" : author]
        RECIPE_REF.updateChildValues(recipes)
    }
    
}
