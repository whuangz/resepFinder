//
//  ProfileDescriptionCellTableViewCell.swift
//  ResepFinder
//
//  Created by William Huang on 12/11/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import UIKit

class ProfileDescriptionCellTableViewCell: RFBaseCell {
    
    fileprivate var userProfileImageView: UIImageView!
    fileprivate var userName: UILabel!
    fileprivate var locationIcon: UIImageView!
    fileprivate var locationLabel: UILabel!
    fileprivate var descriptionLabel: UILabel!
    
    override func setUpViews() {
        prepareUI()
    }
    
}


//MARK: - Initialize & Prepare UI
extension ProfileDescriptionCellTableViewCell {
    
    
    fileprivate func prepareUI(){
        self.userProfileImageView = getUserProfileImageView()
        self.userName = getUsername()
        self.locationIcon = getLocationIcon()
        self.locationLabel = getLocationLabel()
        self.descriptionLabel = getDescriptionLabel()
        layoutViews()
    }
    
    fileprivate func layoutViews(){
        addSubview(userProfileImageView)
        addSubview(userName)
        addSubview(locationLabel)
        addSubview(locationIcon)
        addSubview(descriptionLabel)

        _ = userProfileImageView.anchor(top: self.topAnchor, left: self.leftAnchor, topConstant: 16, leftConstant: 16, widthConstant: 60, heightConstant: 60)
        
        
        _ = userName.anchor(top: userProfileImageView.topAnchor, left: userProfileImageView.rightAnchor, right: self.rightAnchor, leftConstant: 8, rightConstant: 16)
        
        _ = locationIcon.anchor(top: userName.bottomAnchor, left: userName.leftAnchor, topConstant: 8, widthConstant: 12, heightConstant: 12)
        _ = locationLabel.anchor(left: locationIcon.rightAnchor, right: userName.rightAnchor, leftConstant: 8)
        _ = locationLabel.centerConstraintWith(centerY: locationIcon.centerYAnchor)
        _ = descriptionLabel.anchor(top: userProfileImageView.bottomAnchor, left: userProfileImageView.leftAnchor, right: self.rightAnchor, topConstant: 8, rightConstant: 16)
        
        
        
    }
    
    fileprivate func getUserProfileImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.backgroundColor = .red
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }
    
    fileprivate func getUsername() -> UILabel {
        let label = UILabel()
        label.text = "Username"
        return label
    }
    
    fileprivate func getLocationIcon() -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "location")
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }
    
    fileprivate func getLocationLabel() -> UILabel {
        let label = UILabel()
        label.text = "Sumatera"
        return label
    }
    
    fileprivate func getDescriptionLabel() -> UILabel {
        let label = UILabel()
        label.text = "Professional Chef"
        label.numberOfLines = 0
        return label
    }
}
