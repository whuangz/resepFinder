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
        self.service.showProgress()
        self.service.loginWith(email: email.value, pwd: pwd.value).bind { (tuple) in
            if (tuple.1 != nil){
                self.errMsg.value = tuple.1.debugDescription
            }else{
                if let user = Auth.auth().currentUser {
                    self.service.getUser(forUid: (user.uid)) { (user) in
                        UserDefaults.standard.setLocation(value: user.region!)
                    }
                }
                self.isSuccess.value = true
            }
            self.service.dismissProgress()
        }.disposed(by: disposeBag)
    }
}
