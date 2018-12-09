//
//  RFImageView.swift
//  ResepFinder
//
//  Created by William Huang on 19/11/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import UIKit

class RFImageView: CachedImageView {
    
    func setCornerWith(radius: CGFloat){
        self.layer.cornerRadius = radius
    }
}
