//
//  CreateReviewsCell.swift
//  ResepFinder
//
//  Created by William Huang on 26/11/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import Foundation

class CreateReviewsCell: RFBaseCollectionCell {
    
    fileprivate var imgView: UIImageView!
    fileprivate var subHeader: UILabel!
    var reviewBtn: RFPrimaryBtn!
    
    override func setUpViews() {
        super.setUpViews()
        prepareUI()
    }
    
}


//MARK: - Initialize & Prepare UI
extension CreateReviewsCell {
    
    fileprivate func prepareUI(){
        self.backgroundColor = .white
        self.imgView = getImageView()
        self.subHeader = getSubHeader()
        self.reviewBtn = getNoBtn()
        
        configureViews()
        layoutViews()
    }
    
    fileprivate func configureViews(){
        self.imgView.image = UIImage(named: "recipe1")
        self.subHeader.text = "Does it look good as it tastes?\nGive your thought about it!"
    }
    
    fileprivate func layoutViews(){
        
        addSubview(imgView)
        addSubview(subHeader)
        addSubview(reviewBtn)
        
        _ = self.imgView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, rightConstant: 0, heightConstant: 350)
        _ = self.subHeader.anchor(top: self.imgView.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor, topConstant: 16, leftConstant: 8, rightConstant: 8)
        _ = self.reviewBtn.anchor(top: self.subHeader.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor, topConstant: 16, leftConstant: 24, rightConstant: 24, heightConstant: 40)
        
        
    }
    
    fileprivate func getImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 5
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }
    
    fileprivate func getSubHeader() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.sizeToFit()
        label.font = RFFont.instance.subHead16
        label.textAlignment = .center
        return label
    }
    
    fileprivate func getNoBtn() -> RFPrimaryBtn {
        let button = RFPrimaryBtn()
        button.setTitle("Write a review!", for: .normal)
        button.setTitleColor(RFColor.instance.black, for: .normal)
        button.titleLabel?.font = RFFont.instance.subHead16
        button.backgroundColor = RFColor.instance.darkGreen1
        button.setTitleColor(UIColor.white, for: .normal)
        button.setCornerWith(radius: 5)
        button.isUserInteractionEnabled = false
        return button
    }
    
    
}

