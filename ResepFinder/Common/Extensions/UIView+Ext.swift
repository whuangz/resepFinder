//
//  UIView+Ext.swift
//  ResepFinder
//
//  Created by William Huang on 11/11/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import Foundation

extension UIView {
    func centerConstraintWith(centerX: NSLayoutXAxisAnchor? = nil, centerY: NSLayoutYAxisAnchor? = nil , xConstant: CGFloat = 0, yConstant: CGFloat = 0) -> [NSLayoutConstraint]{
        translatesAutoresizingMaskIntoConstraints = false
        var anchors = [NSLayoutConstraint]()
        
        if let centerX = centerX {
            anchors.append(centerXAnchor.constraint(equalTo: centerX, constant: xConstant))
        }
        
        if let centerY = centerY {
            anchors.append(centerYAnchor.constraint(equalTo: centerY, constant: yConstant))
        }
        
        anchors.forEach({ $0.isActive = true})
        return anchors
    }

    func anchor(top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, topConstant: CGFloat = 0, leftConstant: CGFloat = 0, bottomConstant: CGFloat = 0, rightConstant: CGFloat = 0, widthConstant: CGFloat = 0, heightConstant: CGFloat = 0, eqWidth: NSLayoutDimension? = nil, eqHeight: NSLayoutDimension? = nil, multiplier: CGFloat = 1) -> [NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false
        
        var anchors = [NSLayoutConstraint]()
        
        if let top = top {
            anchors.append(topAnchor.constraint(equalTo: top, constant: topConstant))
        }
        
        if let left = left {
            anchors.append(leftAnchor.constraint(equalTo: left, constant: leftConstant))
        }
        
        if let bottom = bottom {
            anchors.append(bottomAnchor.constraint(equalTo: bottom, constant: -bottomConstant))
        }
        
        if let right = right {
            anchors.append(rightAnchor.constraint(equalTo: right, constant: -rightConstant))
        }
        
        if widthConstant > 0 {
            anchors.append(widthAnchor.constraint(equalToConstant: widthConstant))
        }
        
        if heightConstant > 0 {
            anchors.append(heightAnchor.constraint(equalToConstant: heightConstant))
        }
        
        if let width = eqWidth {
            anchors.append(widthAnchor.constraint(equalTo: width, multiplier: multiplier))
        }
        
        if let height = eqHeight {
            anchors.append(heightAnchor.constraint(equalTo: height, multiplier: multiplier))
        }
        
        anchors.forEach({$0.isActive = true})
        
        return anchors
    }
}
