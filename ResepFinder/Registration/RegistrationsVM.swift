//
//  RegistrationsVM.swift
//  ResepFinder
//
//  Created by William Huang on 08/11/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import Foundation
import FirebaseAuth
import RxSwift
import RxCocoa


class RegistrationsVM: NSObject{
    private let service = RFAuthService()
    private let disposeBag = DisposeBag()
    
    let username = Variable<String>("")
    let email = Variable<String>("")
    let pwd = Variable<String>("")
    let conPwd = Variable<String>("")
    let region = Variable<String>("")
    let isSuccess = Variable(false)
    let errMsg = Variable("")
    
    func validateRegister() -> Observable<Bool>{

        let validatedEmail = email.asDriver().map { (email) in
            return RFValidations.validatewith(email: (email))
        }
        
        let validatedPwd = pwd.asDriver().map {$0.count >= 6}
        
        let samePwd = Driver.combineLatest(conPwd.asDriver(), pwd.asDriver()) { $0 == $1 }
        
        let registerButtonEnabled = Driver.combineLatest(validatedEmail, validatedPwd, samePwd) { $0 && $1 && $2 }
        return registerButtonEnabled.asObservable()
        
    }
    
    func doRegister(){
        self.service.registerWithParameters(username: username.value ,email: email.value, pwd: pwd.value, location: region.value).bind { (tuple) in
            if (tuple.1 != nil){
                self.errMsg.value = tuple.1.debugDescription
            }else{
                print("Registration Success")
                //self.service.loginWith(email: self.email.value, pwd: self.pwd.value).bind(onNext: { (tuple) in
                    //print("Login Success")
                    self.isSuccess.value = true
//                }).disposed(by: self.disposeBag)
            }
        }.disposed(by: disposeBag)
    }
}


