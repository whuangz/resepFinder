//
//  RecipeDetailVM.swift
//  ResepFinder
//
//  Created by William Huang on 02/12/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class RecipeDetailVM: NSObject {
    var title = Variable<String>("")
    var desc = Variable<String>("")
    var difficulty = Variable<String>("")
    var disposeBag = DisposeBag()
    
    func insertDetail(){
        print(title.value, desc.value, difficulty.value)
    }

}
