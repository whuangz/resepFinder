//
//  ProfileDetailsCell.swift
//  ResepFinder
//
//  Created by William Huang on 14/11/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import UIKit

class ProfileDetailsCell: RFBaseCell {
    
    fileprivate var followingView: UIView!
    fileprivate var followingCount: UILabel!
    fileprivate var followingLbl: UILabel!
    fileprivate var totalRecipesView: UIView!
    fileprivate var totalRecipesCount: UILabel!
    fileprivate var totalRecipesLbl: UILabel!
    fileprivate var followerView: UIView!
    fileprivate var followerCount: UILabel!
    fileprivate var followerLbl: UILabel!

    
    override func setUpViews() {
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
        
        configureView()
        layoutViews()
    }
    
    fileprivate func configureView(){
        self.followingLbl.text = "My Following"
        self.totalRecipesLbl.text = "My Recipes"
        self.followerLbl.text = "My Followers"
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
        
        _ = self.followingLbl.centerConstraintWith(centerX: followingView.centerXAnchor, centerY: followingView.centerYAnchor, yConstant: -16)
        _ = self.followingCount.anchor(top: followingLbl.bottomAnchor, topConstant: 8)
        _ = self.followingCount.centerConstraintWith(centerX: followingLbl.centerXAnchor)

        _ = self.totalRecipesLbl.centerConstraintWith(centerX: totalRecipesView.centerXAnchor, centerY: totalRecipesView.centerYAnchor, yConstant: -16)
        _ = self.totalRecipesCount.anchor(top: totalRecipesLbl.bottomAnchor, topConstant: 8)
        _ = self.totalRecipesCount.centerConstraintWith(centerX: totalRecipesLbl.centerXAnchor)
        
        _ = self.followerLbl.centerConstraintWith(centerX: followerView.centerXAnchor, centerY: followerView.centerYAnchor, yConstant: -16)
        _ = self.followerCount.anchor(top: followerLbl.bottomAnchor, topConstant: 8)
        _ = self.followerCount.centerConstraintWith(centerX: followerLbl.centerXAnchor)
        
        
    }
    
    fileprivate func getView() -> UIView {
        let view = UIView()
        return view
    }
    
    fileprivate func getHeaderLbl() -> UILabel {
        let label = UILabel()
        return label
    }

    fileprivate func getCountLbl() -> UILabel {
        let label = UILabel()
        label.text = "0"
        return label
    }
}
