//
//  CreateRecipeVM.swift
//  ResepFinder
//
//  Created by William Huang on 15/12/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import Foundation
import FirebaseAuth
import RxSwift
import RxCocoa


class CreateRecipeVM: NSObject{
    private let disposeBag = DisposeBag()
    
    let rating = Variable<String>("")
    let comment = Variable<String>("")
    
    let isSuccess = Variable(false)
    let errMsg = Variable("")
    
    func validateReviewed() -> Observable<Bool>{
  
        let commentV = self.comment.asDriver().map {$0.count > 0}

        return commentV.asObservable()
        
    }
}

