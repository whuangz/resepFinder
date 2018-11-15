//
//  RFButton.swift
//  ResepFinder
//
//  Created by William Huang on 04/11/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import UIKit

class RFButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func makeDisabled(){
        self.backgroundColor = RFColor.instance.gray3
        self.isEnabled = false
    }
    
    func makeEnabled(){
        self.backgroundColor = RFColor.instance.primaryGreen
        self.isEnabled = true
    }
    
}
