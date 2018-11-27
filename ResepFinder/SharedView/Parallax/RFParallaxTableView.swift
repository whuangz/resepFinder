//
//  RFParallaxTableView.swift
//  ResepFinder
//
//  Created by William Huang on 25/11/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import UIKit

class RFParallaxTableView: UITableView {

    
    // these are public so we can change them in controller when needed
    var kTableHeaderHeight: CGFloat = 300
    var kTableHeaderCutAway: CGFloat = 65.0
    var kOverlapRatio: CGFloat = 3
    
    private var headerView: UIView?
    private var headerMaskLayer: CAShapeLayer?
    
    func constructParallaxHeader() {
        if self.tableHeaderView !== nil {
            // get the original table header
            headerView = self.tableHeaderView
            // remove the header from table view
            self.tableHeaderView = nil
            
            // add the header back to table view as a subview
            self.addSubview(headerView!)
            let effectiveHeight = kTableHeaderHeight - kTableHeaderCutAway / kOverlapRatio
            self.contentInset = UIEdgeInsets(top: effectiveHeight, left: 0, bottom: 0, right: 0)
            self.contentOffset = CGPoint(x: 0, y: -effectiveHeight)
            
            // construct cut away
            headerMaskLayer = CAShapeLayer()
            headerMaskLayer!.fillColor = UIColor.black.cgColor
            headerView!.layer.mask = headerMaskLayer
            // call the update to calculate header size and cut away
            updateHeaderView()
        }
    }
    
    func updateHeaderView() {
        let effectiveHeight = kTableHeaderHeight - kTableHeaderCutAway / kOverlapRatio
        var headerRect = CGRect(x: 0, y: -effectiveHeight, width: self.bounds.width, height: kTableHeaderHeight)
        if self.contentOffset.y < -effectiveHeight {
            headerRect.origin.y = self.contentOffset.y
            headerRect.size.height = -self.contentOffset.y + kTableHeaderCutAway / kOverlapRatio
        }
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: headerRect.width, y: 0))
        path.addLine(to: CGPoint(x: headerRect.width, y: headerRect.height))
        path.addLine(to: CGPoint(x: 0, y: headerRect.height - kTableHeaderCutAway))
        headerMaskLayer?.path = path.cgPath
        
        headerView?.frame = headerRect
    }
    

}
//
////
////  RFParallaxTableView.swift
////  ResepFinder
////
////  Created by William Huang on 25/11/18.
////  Copyright © 2018 William Huang. All rights reserved.
////
//
//import UIKit
//
//class RFParallaxTableView: UITableView {
//    
//    // these are public so we can change them in controller when needed
//    var kTableHeaderHeight: CGFloat = 250.0
//    var kTableHeaderCutAway: CGFloat = 80.0
//    var kOverlapRatio: CGFloat = 3
//    
//    private var headerView: UIView?
//    
//    func constructParallaxHeader() {
//        if self.tableHeaderView !== nil {
//            // get the original table header
//            headerView = self.tableHeaderView
//            headerView?.backgroundColor = .green
//            // remove the header from table view
//            self.tableHeaderView = nil
//            
//            // add the header back to table view as a subview
//            self.addSubview(headerView!)
//            let effectiveHeight = kTableHeaderHeight - kTableHeaderCutAway / kOverlapRatio
//            self.contentInset = UIEdgeInsets(top: effectiveHeight, left: 0, bottom: 0, right: 0)
//            self.contentOffset = CGPoint(x: 0, y: -effectiveHeight)
//            
//            
//            // call the update to calculate header size and cut away
//            updateHeaderView()
//        }
//    }
//    
//    func updateHeaderView() {
//        let effectiveHeight = kTableHeaderHeight - kTableHeaderCutAway / kOverlapRatio
//        var headerRect = CGRect(x: 0, y: -effectiveHeight, width: self.bounds.width, height: kTableHeaderHeight)
//        if self.contentOffset.y < -effectiveHeight {
//            headerRect.origin.y = self.contentOffset.y
//            headerRect.size.height = -self.contentOffset.y + kTableHeaderCutAway / kOverlapRatio
//        }
//        
//        
//        headerView?.frame = headerRect
//    }
//    
//    
//}
