//
//  RFBaseCollectionCell.swift
//  ResepFinder
//
//  Created by William Huang on 17/11/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import UIKit

class RFBaseCollectionCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    func setUpViews(){
        fatalError("Subclasses must implement this function")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
