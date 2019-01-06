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
        if let arrOfTxt = stepsTxt, var arrOfImg = stepsImg {
            
            let sortedTextData = Array(arrOfTxt).sorted(by: <)
            
            
            for key in 0..<sortedTextData.count {
                if arrOfImg.count != 0 {
                    for (key1, val) in arrOfImg {
                        if arrOfImg[key] != nil && key1 == key {
                            arrOfImg[key] = val
                        }else{
                            arrOfImg[key] = ""
                        }
                    }
                }else{
                    arrOfImg[key] = ""
                }
                
            }
            
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
