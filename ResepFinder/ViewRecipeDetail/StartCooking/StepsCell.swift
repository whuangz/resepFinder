//
//  StepsCell.swift
//  ResepFinder
//
//  Created by William Huang on 26/11/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import Foundation

class StepsCell: RFBaseCollectionCell {
    
    fileprivate var imgView: UIImageView!
    fileprivate var stepSubHeadLbl: UILabel!
    var stepNo: RFPrimaryBtn!
    fileprivate var stepDescription: UILabel!
    
    override func setUpViews() {
        super.setUpViews()
        prepareUI()
    }
    
}


//MARK: - Initialize & Prepare UI
extension StepsCell {
    
    fileprivate func prepareUI(){
        self.backgroundColor = .white
        self.imgView = getImageView()
        self.stepNo = getNoBtn()
        self.stepSubHeadLbl = getSubHeader()
        self.stepDescription = getDescLbl()
        
        configureViews()
        layoutViews()
    }
    
    fileprivate func configureViews(){
        self.imgView.image = UIImage(named: "recipe1")
        self.stepDescription.text = "Fluffy sweet potatoes mixed with butter, sugar, and vanilla, and baked with a crunchy pecan streusel topping. This recipe was given to me by my brother-in-law."
    }
    
    fileprivate func layoutViews(){
        
        addSubview(imgView)
        addSubview(stepSubHeadLbl)
        addSubview(stepNo)
        addSubview(stepDescription)
        
        _ = self.imgView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, rightConstant: 0, heightConstant: 200)
        _ = self.stepSubHeadLbl.anchor(top: self.imgView.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor, topConstant: 16, leftConstant: 8, rightConstant: 8)
        _ = self.stepNo.anchor(top: self.stepSubHeadLbl.bottomAnchor, left: self.leftAnchor, topConstant: 16, leftConstant: 8)
        _ = self.stepDescription.anchor(top: stepNo.topAnchor, left: stepNo.rightAnchor, right: self.rightAnchor, leftConstant: 8, rightConstant: 8 )
        
    
        
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
        label.font = RFFont.instance.subHead18
        label.text = "Description"
        return label
    }
    
    fileprivate func getNoBtn() -> RFPrimaryBtn {
        let button = RFPrimaryBtn()
        button.setTitle("Follow", for: .normal)
        button.setTitleColor(RFColor.instance.black, for: .normal)
        button.titleLabel?.font = RFFont.instance.subHead16
        button.setBorderColor(UIColor.init(white: 0.9, alpha: 0.8), width: 1)
        button.setCornerWith(radius: 5)
        button.isUserInteractionEnabled = false
        return button
    }
    
    fileprivate func getDescLbl() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.sizeToFit()
        label.font = RFFont.instance.bodyMedium16
        return label
    }
    
    
}

