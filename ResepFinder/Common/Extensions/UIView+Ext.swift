//
//  UIView+Ext.swift
//  ResepFinder
//
//  Created by William Huang on 11/11/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import Foundation

extension UIView {
    
    func safeAreaBottomHeight() -> CGFloat
    {
        if #available(iOS 11.0, *) {
            return self.safeAreaInsets.bottom
        }
        else {
            return 0
        }
    }
    
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

    func anchor(top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, topConstant: CGFloat = 0, leftConstant: CGFloat = 0, bottomConstant: CGFloat = 0, rightConstant: CGFloat = 0, widthConstant: CGFloat = 0, heightConstant: CGFloat = 0, eqWidth: NSLayoutDimension? = nil, eqHeight: NSLayoutDimension? = nil, widthMultiplier: CGFloat = 1, heightMultiplier: CGFloat = 1) -> [NSLayoutConstraint] {
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
            anchors.append(widthAnchor.constraint(equalTo: width, multiplier: widthMultiplier))
        }
        
        if let height = eqHeight {
            anchors.append(heightAnchor.constraint(equalTo: height, multiplier: heightMultiplier))
        }
        
        anchors.forEach({$0.isActive = true})
        
        return anchors
    }
    
    func constraintWithVisual(format: String, options: NSLayoutFormatOptions = NSLayoutFormatOptions() , metrics: [String:Any]? = nil, views: UIView...){
        var dictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            dictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: options, metrics: metrics, views: dictionary))
        
    }
    
    func addAttributedString(text: String, lineSpacing: CGFloat = 1, font: UIFont) -> NSMutableAttributedString{
        let attributedString = NSMutableAttributedString(string: text)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        attributedString.addAttributes([NSAttributedStringKey.paragraphStyle: paragraphStyle, NSAttributedStringKey.font: font], range:NSMakeRange(0, attributedString.length))
        
        return attributedString
    }
    
    
    func addSeperatorLine(left: CGFloat = 0 , right: CGFloat = 0){
        let seperatorLine = UIView()
        seperatorLine.backgroundColor = RFColor.instance.gray3
        addSubview(seperatorLine)
        _ = seperatorLine.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, leftConstant: left, bottomConstant: 0, rightConstant: right, heightConstant: 2)
    }
}
