//
//  ReviewCell.swift
//  ResepFinder
//
//  Created by William Huang on 25/11/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import Foundation

class ReviewCell: RFBaseTableCell {
    
    fileprivate var topView: UIView!
    fileprivate var reviewHeader: UILabel!
    fileprivate var totalReviewer: UILabel!
    var readMoreBtn: RFPrimaryBtn!
    var delegate: NavigationControllerDelegate?
    var recipeID: String?
    
    override func setupViews() {
        super.setupViews()
        prepareUI()
    }
    
}


//MARK: - Initialize & Prepare UI
extension ReviewCell {
    
    
    fileprivate func prepareUI(){
        self.topView = self.getView()
        self.reviewHeader = self.getHeaderLbl()
        self.totalReviewer = self.getLbl()
        self.readMoreBtn = self.getBtn()
        
        layoutViews()
    }
    
    fileprivate func layoutViews(){
        
        addSubview(topView)
        topView.addSubview(reviewHeader)
        topView.addSubview(totalReviewer)
        topView.addSubview(readMoreBtn)
        
        _ = self.topView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        _ = self.reviewHeader.anchor(left: topView.leftAnchor, right: topView.rightAnchor, leftConstant: 16)
        _ = self.reviewHeader.centerConstraintWith(centerY: topView.centerYAnchor)
        _ = self.totalReviewer.anchor(top: reviewHeader.bottomAnchor, left: topView.leftAnchor, leftConstant: 16)
        _ = self.readMoreBtn.anchor(left: reviewHeader.rightAnchor, right: topView.rightAnchor, leftConstant: 8, rightConstant: 16, widthConstant: 70)
        _ = self.readMoreBtn.centerConstraintWith(centerY: reviewHeader.centerYAnchor)
    }
    
    fileprivate func getView() -> UIView {
        let view = UIView()
        view.layer.masksToBounds = true
        return view
    }
    
    fileprivate func getHeaderLbl() -> UILabel {
        let label = UILabel()
        label.font = RFFont.instance.subHead14
        label.text = "Reviews"
        return label
    }
    
    fileprivate func getLbl() -> UILabel {
        let label = UILabel()
        label.font = RFFont.instance.bodyMedium12
        label.text = "0 Reviewer"
        return label
    }
    
    fileprivate func getBtn() -> RFPrimaryBtn {
        let button = RFPrimaryBtn()
        button.setTitle("Reads More", for: .normal)
        button.setTitleColor(RFColor.instance.black, for: .normal)
        button.backgroundColor = UIColor.init(white: 0.9, alpha: 0.8)
        button.titleLabel?.font = RFFont.instance.bodyMedium10
        button.setCornerWith(radius: 5)
        return button
    }
    
}
