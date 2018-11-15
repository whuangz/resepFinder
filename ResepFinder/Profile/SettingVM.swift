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
        self.service.logoutUser()
    }
}
