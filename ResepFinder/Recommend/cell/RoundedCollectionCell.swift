//
//  RoundedCollectionCell.swift
//  ResepFinder
//
//  Created by William Huang on 20/12/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import UIKit

class RoundedCollectionCell: UICollectionViewCell {
    
    let textLbl: UILabel = {
        let title = UILabel()
        title.text = ""
        title.font = RFFont.instance.subHead14
        return title
    }()
    
    let removeQueried: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "remove"), for: .normal)
        return btn
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareUI()
        observeData()
    }
    
    var delegate: RemoveQueriedProtocol?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bindData(_ text: String) {
        self.textLbl.text = text
    }
    
    func observeData(){
        self.removeQueried.addTarget(self, action: #selector(removeData), for: .touchUpInside)
    }
    
    @objc func removeData(){
        self.delegate?.didRemove(data: self.textLbl.text ?? "")
    }
    
    static func sizeWithText(_ text: String) -> CGSize {
        var size = text.size(width:300, font:RFFont.instance.subHead14!)
        size.width = size.width + 65
        size.height = 36
        return size
    }
    
    func prepareUI(){
        self.backgroundColor = UIColor.white
        self.layer.borderWidth = 2
        self.layer.cornerRadius = 18
        self.layer.borderColor = RFColor.instance.darkGreen1.cgColor
        
        addSubview(textLbl)
        addSubview(removeQueried)
        
        _ = textLbl.centerConstraintWith(centerX: self.centerXAnchor, centerY: self.centerYAnchor)
        _ = removeQueried.anchor(left: textLbl.rightAnchor, right: self.rightAnchor, leftConstant: 8, rightConstant: 8, widthConstant:15, heightConstant: 15)
        _ = removeQueried.centerConstraintWith(centerY: textLbl.centerYAnchor)
    }
    
}

protocol RemoveQueriedProtocol {
    func didRemove(data: String)
}
