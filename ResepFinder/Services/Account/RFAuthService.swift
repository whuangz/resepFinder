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
    
    func registerWithParameters(email: String, pwd: String) -> Observable<((User?, Error?))>{
        
        return Observable.create({ (observer) in
            Auth.auth().createUser(withEmail: email, password: pwd, completion: { (data, error) in
                if error == nil {
                    guard let user = data?.user else {return}
                    let userData = [
                        "provider" : user.providerID,
                        "email" : user.email
                    ]
                    
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
    
    private func createUserDB(uid: String, data: Dictionary<String,Any>){
        USER_REF.child(uid).updateChildValues(data)
    }
    
}
