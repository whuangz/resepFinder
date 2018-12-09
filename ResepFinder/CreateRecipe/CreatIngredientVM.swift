//
//  CreatingIngredientVM.swift
//  ResepFinder
//
//  Created by William Huang on 02/12/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import Foundation
import RxSwift

class CreateIngredientVM {
    var servingTxt = Variable<String>("")
    var ingredientTxt: [Int:String]?

    init() {
        ingredientTxt = [Int:String]()
    }
}
