//
//  RFScreenHelper.swift
//  ResepFinder
//
//  Created by William Huang on 22/11/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import Foundation

class RFScreenHelper {
    static func statusBarHeight() -> CGFloat {
        return (UIApplication.shared.statusBarView?.frame.height)!
    }
    
    static func screenWidth() -> CGFloat {
        return UIScreen.main.bounds.size.width;
    }
    
    static func isLessThanIPhone6() -> Bool {
        return UIScreen.main.bounds.size.height < 667;
    }

}
