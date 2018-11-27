//
//  RFRecipeCell.swift
//  ResepFinder
//
//  Created by William Huang on 17/11/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import UIKit

class RFRecipeCell: RFBaseCollectionCell {
    
    fileprivate var recipeView: UIImageView!
    fileprivate var titleLbl: UILabel!
    fileprivate var timeView: UIView!
    fileprivate var timeIcon: UIImageView!
    fileprivate var timeLbl: UILabel!
    fileprivate var profileImg: UIImageView!
    
    override func setUpViews() {
        super.setUpViews()
        prepareUI()
    }
    
}


//MARK: - Initialize & Prepare UI
extension RFRecipeCell {
    
    fileprivate func prepareUI(){
        self.backgroundColor = .white
        self.recipeView = getImageView()
        self.profileImg = getProfileView()
        self.titleLbl = getTitleLbl()
        self.timeView = getView()
        self.timeIcon = getImageView()
        self.timeLbl = getTimeLbl()
        
        configureViews()
        layoutViews()
    }
    
    fileprivate func configureViews(){
        self.titleLbl.text = "Sate Padang Minangkabau Indonesia"
        self.recipeView.image = UIImage(named: "recipe1")
        self.timeIcon.image = UIImage(named: "timer")
    }
    
    fileprivate func layoutViews(){
        
        addSubview(recipeView)
        recipeView.addSubview(timeView)
        timeView.addSubview(timeIcon)
        timeView.addSubview(timeLbl)
        addSubview(titleLbl)
        addSubview(profileImg)
        
        _ = self.recipeView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, rightConstant: 0, heightConstant: 135, eqWidth: widthAnchor)
        _ = self.timeView.anchor(bottom: recipeView.bottomAnchor, right: recipeView.rightAnchor, bottomConstant: 8, rightConstant: 8, eqWidth: self.timeLbl.widthAnchor, eqHeight: self.timeLbl.heightAnchor, widthMultiplier: 1.5)
        _ = self.timeLbl.anchor(bottom: timeView.bottomAnchor, right: timeView.rightAnchor, rightConstant: 4)
        _ = self.timeIcon.anchor(right: timeLbl.leftAnchor, rightConstant: 4)
        _ = self.timeIcon.centerConstraintWith(centerY: self.timeLbl.centerYAnchor)
        
        if profileImg.isHidden{
            _ = self.titleLbl.anchor(top: recipeView.bottomAnchor, left: recipeView.leftAnchor, right: recipeView.rightAnchor, topConstant: 8)
        }else{
            _ = self.profileImg.anchor(top: recipeView.bottomAnchor, left: recipeView.leftAnchor, topConstant: 8, widthConstant: 20, heightConstant: 20)
            _ = self.titleLbl.anchor(top: profileImg.bottomAnchor, left: recipeView.leftAnchor, right: recipeView.rightAnchor, topConstant: 8)
        }
        
        
    }
    
    fileprivate func getImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 5
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }
    
    fileprivate func getProfileView() -> UIImageView {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 10
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .red
        imageView.isHidden = true
        return imageView
    }
    
    fileprivate func getTitleLbl() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.sizeToFit()
        label.font = RFFont.instance.bodyMedium14
        return label
    }
    
    fileprivate func getTimeLbl() -> UILabel {
        let label = UILabel()
        label.text = "5 Mins"
        label.font = RFFont.instance.subHead12
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        return label
    }
    
    fileprivate func getView() -> UIView {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor(white: 0.9, alpha: 0.5)
        return view
    }

}

