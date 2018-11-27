//
//  DescriptionCell.swift
//  ResepFinder
//
//  Created by William Huang on 25/11/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import Foundation

class DescriptionCell: RFBaseTableCell {
    
    fileprivate var descriptionLbl: UILabel!
    
    override func setupViews() {
        super.setupViews()
        prepareUI()
    }
    
}


//MARK: - Initialize & Prepare UI
extension DescriptionCell {
    
    
    fileprivate func prepareUI(){
        self.descriptionLbl = getHeaderLbl()
        
        configureViews()
        layoutViews()
    }
    
    fileprivate func configureViews(){
        self.descriptionLbl.text = "Fluffy sweet potatoes mixed with butter, sugar, and vanilla, and baked with a crunchy pecan streusel topping. This recipe was given to me by my brother-in-law."
    }
    
    fileprivate func layoutViews(){
        
        addSubview(descriptionLbl)
        
        _ = self.descriptionLbl.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, leftConstant: 16, rightConstant: 16)
    }
    
    fileprivate func getHeaderLbl() -> UILabel {
        let label = UILabel()
        label.font = RFFont.instance.bodyMedium12
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }

}
