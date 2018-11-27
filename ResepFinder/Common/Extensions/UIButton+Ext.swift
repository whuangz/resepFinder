//
//  UIButton+Ext.swift
//  ResepFinder
//
//  Created by William Huang on 22/11/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import UIKit

extension UIButton {
    func animateTouch(duration: Double){
        let animate = CASpringAnimation(keyPath: "transform.scale")
        animate.duration = duration
        animate.fromValue = 0.8
        animate.toValue = 1.0
        animate.autoreverses = false
        animate.repeatCount = 1
        animate.initialVelocity = 0.5
        animate.damping = 0
        layer.add(animate, forKey: nil)
    }
}
