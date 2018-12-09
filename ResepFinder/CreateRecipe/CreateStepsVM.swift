//
//  CreateStepsVM.swift
//  ResepFinder
//
//  Created by William Huang on 03/12/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import Foundation
import RxSwift

class CreateStepVM {
    var timeTxt = Variable<String>("")
    var stepsTxt: [Int:String]?
    var stepsImg: [Int: String]?
    
    init() {
        stepsTxt = [Int:String]()
        stepsImg = [Int:String]()
    }
    
    func getSteps() -> [[String:Any]]{
        var arryOfSteps = [[String:Any]]()
        if let arrOfTxt = stepsTxt, let arrOfImg = stepsImg {
            
            let sortedTextData = Array(arrOfTxt).sorted(by: <)
            let sortedImgData = Array(arrOfImg).sorted(by: { $0.key < $1.key })
            
            if sortedImgData.count == sortedImgData.count {
                for i in 0..<sortedImgData.count {
                    if sortedTextData[i].key == sortedImgData[i].key {
                        let step:[String:Any] = ["desc": sortedTextData[i].value, "imgPath": sortedImgData[i].value]
                        arryOfSteps.append(step)
                    }
                }
            }
        }
        return arryOfSteps
    }
    
}
