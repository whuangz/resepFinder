//
//  UploadCell.swift
//  ResepFinder
//
//  Created by William Huang on 26/11/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import Foundation

class UploadCell: RFBaseTableCell {
    
    fileprivate var uploadView: UIImageView!
    
    override func setupViews() {
        super.setupViews()
        prepareUI()
    }
    
}


//MARK: - Initialize & Prepare UI
extension UploadCell {
    
    
    fileprivate func prepareUI(){
        self.uploadView = getImageView()
        
        configureViews()
        layoutViews()
    }
    
    fileprivate func configureViews(){
        
    }
    
    fileprivate func layoutViews(){
        
        addSubview(uploadView)
        
        _ = self.uploadView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
    }
    
    fileprivate func getImageView() -> UIImageView {
        let imgView = UIImageView()
        imgView.backgroundColor = .red
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        imgView.image = UIImage(named: "uploadPhoto1")
        return imgView
    }
    
}

