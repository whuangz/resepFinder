//
//  RFButton.swift
//  ResepFinder
//
//  Created by William Huang on 04/11/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import UIKit

class RFPrimaryBtn: UIButton {

    private var activeImg: UIImage!
    private var inActiveImg: UIImage!
    
    
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
    
    func setCornerWith(radius: CGFloat){
        self.layer.cornerRadius = radius
    }
    
    func setBorderColor(_ color: UIColor, width: CGFloat) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = width
    }
    
    func setContentImageFor(active: String = "", inactive: String = ""){
        self.activeImg = UIImage(named: active)
        self.inActiveImg = UIImage(named: inactive)
        self.setImage(self.inActiveImg, for: .normal)
    }
    
    func selected(_ status: Bool){
        if status == true {
            self.setImage(self.activeImg, for: .normal)
        }else {
            self.setImage(self.inActiveImg, for: .normal)
        }
    }
    
    func setTitle(_ title: String){
        self.setTitle(title, for: .normal)
    }

}
