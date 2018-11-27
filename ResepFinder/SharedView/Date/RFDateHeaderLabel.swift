//
//  RFDateHeaderLabel.swift
//  ResepFinder
//
//  Created by William Huang on 23/11/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import Foundation

class DateHeaderLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        translatesAutoresizingMaskIntoConstraints = false
        textColor = UIColor.white
        textAlignment = .center
        font = RFFont.instance.subHead12
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        let originalContentSize = super.intrinsicContentSize
        let height = originalContentSize.height + 12
        layer.cornerRadius = height / 2
        layer.masksToBounds = true
        return CGSize(width: originalContentSize.width + 16, height: height)
    }
}
