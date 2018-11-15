//
//  RFBaseController.swift
//  ResepFinder
//
//  Created by William Huang on 09/11/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class RFBaseController {
    
    let disposeBag = DisposeBag()
    
    private func bind(textfield: UITextField, to variable: Variable<String>){
        variable.asObservable().bind(to: textfield.rx.text.orEmpty).disposed(by: disposeBag)
        //textfield.rx.text.orEmpty
    }
}
