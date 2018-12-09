//
//  SettingVM.swift
//  ResepFinder
//
//  Created by William Huang on 15/11/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import Foundation
import RxSwift

class SettingVM: NSObject {
    private let service = RFAuthService()
    private let disposeBag = DisposeBag()
    
    func doLogout(){
        _ = self.service.logoutUser()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.redirectoHomeMenu()
    }
}
