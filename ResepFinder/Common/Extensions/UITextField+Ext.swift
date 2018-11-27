//
//  UITextField+Ext.swift
//  ResepFinder
//
//  Created by William Huang on 26/11/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import Foundation

extension UITextField {
   
    func addLineToBottomView(color: UIColor, width: Double) {
        let lineView = UIView()
        lineView.backgroundColor = color
        self.addSubview(lineView)
        
        let metrics = ["width" : NSNumber(value: width)]
        
        self.constraintWithVisual(format: "H:|[v0]|", options: NSLayoutFormatOptions(rawValue: 0) , metrics: metrics ,views: lineView)
        
        self.constraintWithVisual(format: "V:[v0(\(width))]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics ,views: lineView)
        
    }
}
