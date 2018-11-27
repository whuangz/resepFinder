//
//  ProfileDetailsCell.swift
//  ResepFinder
//
//  Created by William Huang on 14/11/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import UIKit

class ProfileDetailsCell: RFBaseTableCell {
    
    fileprivate var followingView: UIView!
    fileprivate var followingCount: UILabel!
    fileprivate var followingLbl: UILabel!
    fileprivate var totalRecipesView: UIView!
    fileprivate var totalRecipesCount: UILabel!
    fileprivate var totalRecipesLbl: UILabel!
    fileprivate var followerView: UIView!
    fileprivate var followerCount: UILabel!
    fileprivate var followerLbl: UILabel!

    
    override func setupViews() {
        super.setupViews()
        prepareUI()
    }
    
}


//MARK: - Initialize & Prepare UI
extension ProfileDetailsCell {
    
    
    fileprivate func prepareUI(){
        self.backgroundColor = UIColor(white: 0.9, alpha: 0.5)
        self.followingView = getView()
        self.followingLbl = getHeaderLbl()
        self.followingCount = getCountLbl()
        self.totalRecipesView = getView()
        self.totalRecipesLbl = getHeaderLbl()
        self.totalRecipesCount = getCountLbl()
        self.followerView = getView()
        self.followerLbl = getHeaderLbl()
        self.followerCount = getCountLbl()
        
        configureViews()
        layoutViews()
    }
    
    fileprivate func configureViews(){
        self.followingLbl.text = "Following"
        self.totalRecipesLbl.text = "Recipes"
        self.followerLbl.text = "Followers"
    }
    
    fileprivate func layoutViews(){
        
        addSubview(followingView)
        addSubview(totalRecipesView)
        addSubview(followerView)
        followingView.addSubview(followingLbl)
        followingView.addSubview(followingCount)
        totalRecipesView.addSubview(totalRecipesLbl)
        totalRecipesView.addSubview(totalRecipesCount)
        followerView.addSubview(followerLbl)
        followerView.addSubview(followerCount)
        
        let screenWidth = UIScreen.main.bounds.width / 3
        
        _ = self.followingView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, widthConstant: screenWidth, heightConstant: 80)
        
        _ = self.totalRecipesView.anchor(top: topAnchor, left: followingView.rightAnchor, bottom: bottomAnchor, eqWidth: self.followingView.widthAnchor, eqHeight: self.followingView.heightAnchor)
        
        _ = self.followerView.anchor(top: topAnchor, left: totalRecipesView.rightAnchor, bottom: bottomAnchor, eqWidth: self.followingView.widthAnchor, eqHeight: self.followingView.heightAnchor)
        
        _ = self.followingCount.centerConstraintWith(centerX: followingView.centerXAnchor, centerY: followingView.centerYAnchor, yConstant: -16)
        _ = self.followingLbl.anchor(top: followingCount.bottomAnchor, topConstant: 8)
        _ = self.followingLbl.centerConstraintWith(centerX: followingCount.centerXAnchor)

        _ = self.totalRecipesCount.centerConstraintWith(centerX: totalRecipesView.centerXAnchor, centerY: totalRecipesView.centerYAnchor, yConstant: -16)
        _ = self.totalRecipesLbl.anchor(top: totalRecipesCount.bottomAnchor, topConstant: 8)
        _ = self.totalRecipesLbl.centerConstraintWith(centerX: totalRecipesCount.centerXAnchor)
        
        _ = self.followerCount.centerConstraintWith(centerX: followerView.centerXAnchor, centerY: followerView.centerYAnchor, yConstant: -16)
        _ = self.followerLbl.anchor(top: followerCount.bottomAnchor, topConstant: 8)
        _ = self.followerLbl.centerConstraintWith(centerX: followerCount.centerXAnchor)
        
        
    }
    
    fileprivate func getView() -> UIView {
        let view = UIView()
        return view
    }
    
    fileprivate func getHeaderLbl() -> UILabel {
        let label = UILabel()
        label.font = RFFont.instance.bodyMedium12
        return label
    }

    fileprivate func getCountLbl() -> UILabel {
        let label = UILabel()
        label.text = "0"
        label.font = RFFont.instance.bodyMedium14
        return label
    }
}
