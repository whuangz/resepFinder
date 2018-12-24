//
//  RFBlankStateVC.swift
//  ResepFinder
//
//  Created by William Huang on 24/12/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import UIKit

class RFBlankStateView: UIView {

    var imageView: UIImageView!
    var errorLbl: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        prepareUI()
    }
}

extension RFBlankStateView {
    func prepareUI(){
        self.backgroundColor = UIColor.white
        self.imageView = getImgView()
        self.errorLbl = getLabel()
        
        layoutViews()
    }
    
    func layoutViews(){
        self.addSubview(self.imageView)
        self.addSubview(self.errorLbl)
        
        _ = self.imageView.anchor(widthConstant: 123, heightConstant: 175)
        _ = self.imageView.centerConstraintWith(centerX: self.centerXAnchor, centerY: self.centerYAnchor, yConstant: -20)
        _ = self.errorLbl.anchor(top: self.imageView.bottomAnchor, topConstant: 8)
        _ = self.errorLbl.centerConstraintWith(centerX: self.imageView.centerXAnchor)
    }
    
    func setBlankStateWith(title: String, image: UIImage){
        self.imageView.image = image
        self.errorLbl.text = title
    }
    
    func getLabel() -> UILabel{
        let label = UILabel()
        label.font = RFFont.instance.subHead14
        label.textColor = RFColor.instance.primGray
        return label
    }
    
    func getImgView() -> UIImageView{
        let imgView = UIImageView()
        return imgView
    }
}
