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
    fileprivate var timeLbl: UILabel!
    fileprivate var profileImg: UIImageView!
    
    override func setUpViews() {
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
        self.timeLbl = getTimeLbl()
        
        configureViews()
        layoutViews()
    }
    
    fileprivate func configureViews(){
        self.titleLbl.text = "Sate Padang Minangkabau Indonesia"
        self.recipeView.image = UIImage(named: "recipe1")
    }
    
    fileprivate func layoutViews(){
        
        addSubview(recipeView)
        recipeView.addSubview(timeLbl)
        addSubview(titleLbl)
        addSubview(profileImg)
        
        _ = self.recipeView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, rightConstant: 0, heightConstant: 135, eqWidth: widthAnchor)
        _ = self.timeLbl.anchor(bottom: recipeView.bottomAnchor, right: recipeView.rightAnchor, bottomConstant: 8, rightConstant: 8)
        
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
        return label
    }
    
    fileprivate func getTimeLbl() -> UILabel {
        let label = UILabel()
        label.text = "5 minutes"
        return label
    }

}
