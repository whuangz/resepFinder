//
//  AddStepsCell.swift
//  ResepFinder
//
//  Created by William Huang on 27/11/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import Foundation

class AddStepsCell: RFBaseTableCell {
    
    var uploadImg: RFImageView!
    var stepNo: RFPrimaryBtn!
    var stepDescription: UITextField!
    var deleteBtn: RFPrimaryBtn!
    
    override func setupViews() {
        super.setupViews()
        prepareUI()
    }
    
}

//MARK: - Initialize & Prepare UI
extension AddStepsCell {
    
    
    fileprivate func prepareUI(){
        self.uploadImg = getImageView()
        self.stepNo = getNoBtn()
        self.stepDescription = getTextField()
        self.deleteBtn = getBtn()
        
        layoutViews()
    }
    
    fileprivate func layoutViews(){
        
        addSubview(uploadImg)
        addSubview(stepNo)
        addSubview(stepDescription)
        addSubview(deleteBtn)
        
        _ = self.stepNo.anchor(top: topAnchor, left: leftAnchor, topConstant: 0, leftConstant: 16, widthConstant: 30)
            stepNo.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .horizontal)
        _ = self.uploadImg.anchor(top: stepNo.topAnchor, left: stepNo.rightAnchor, leftConstant: 8, heightConstant: 100)
        _ = self.deleteBtn.anchor(left: self.uploadImg.rightAnchor, right: rightAnchor, rightConstant: 0, widthConstant: 60)
        _ = self.deleteBtn.centerConstraintWith(centerY: self.uploadImg.centerYAnchor)
        _ = self.stepDescription.anchor(top: uploadImg.bottomAnchor, left: uploadImg.leftAnchor, right: uploadImg.rightAnchor, topConstant: 8, heightConstant: 30)
        
        
    }
    
    fileprivate func getImageView() -> RFImageView {
        let imgView = RFImageView(frame: .zero)
        imgView.setCornerWith(radius: 5)
        imgView.contentMode = .scaleAspectFill
        imgView.image = UIImage(named: "uploadPhoto1")
        return imgView
    }
    
    fileprivate func getNoBtn() -> RFPrimaryBtn {
        let button = RFPrimaryBtn()
        button.setTitleColor(RFColor.instance.black, for: .normal)
        button.titleLabel?.font = RFFont.instance.subHead16
        button.setBorderColor(UIColor.init(white: 0.9, alpha: 0.8), width: 1)
        button.setCornerWith(radius: 5)
        button.isUserInteractionEnabled = false
        return button
    }
    
    fileprivate func getTextField() -> UITextField {
        let textField = UITextField()
        textField.placeholder = "Step Description"
        textField.borderStyle = .none
        textField.font = RFFont.instance.bodyMedium14
        textField.addLineToBottomView(color: RFColor.instance.primGray, width: 0.5)
        
        return textField
    }
    
    fileprivate func getBtn() -> RFPrimaryBtn{
        let button = RFPrimaryBtn()
        
        button.setContentImageFor(active: "camera", inactive: "camera")
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 8)
        return button
    }
    
}

