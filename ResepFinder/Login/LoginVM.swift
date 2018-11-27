//
//  LoginVM.Swift
//  ResepFinder
//
//  Created by William Huang on 08/11/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import Foundation
import FirebaseAuth
import RxSwift


class LoginVM: NSObject{
    private let service = RFAuthService()
    private let disposeBag = DisposeBag()
    
    let email = Variable<String>("")
    let pwd = Variable<String>("")
    
    let isSuccess = Variable(false)
    let errMsg = Variable("")

    override init() {
        super.init()
        print(email.asObservable())
    }
    
    func validateLogin() -> Observable<Bool>{
        
        let validatedEmail = email.asObservable().map { (email) in
            return RFValidations.validatewith(email: (email))
        }
        
        let validatedPwd = pwd.asObservable().map {$0.count >= 6}
        
        let loginButtonEnabled = Observable.combineLatest(validatedEmail, validatedPwd) { $0 && $1 }
        return loginButtonEnabled
        
    }
    
    func doLogin(){
        self.service.loginWith(email: email.value, pwd: pwd.value).bind { (tuple) in
            if (tuple.1 != nil){
                self.errMsg.value = tuple.1.debugDescription
            }else{
                self.isSuccess.value = true
            }
        }.disposed(by: disposeBag)
    }
}
