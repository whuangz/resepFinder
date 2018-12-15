//
//  ProfileDescriptionCellTableViewCell.swift
//  ResepFinder
//
//  Created by William Huang on 12/11/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import UIKit

class ProfileDescriptionCellTableViewCell: RFBaseTableCell, RFBaseProtocol {
    
    fileprivate var userProfileImageView: UIView!
    fileprivate var userProfileInitialName: UILabel!
    fileprivate var userName: UILabel!
    fileprivate var locationIcon: UIImageView!
    fileprivate var locationLabel: UILabel!
    fileprivate var descriptionLabel: UILabel!
    
    override func setupViews() {
        super.setupViews()
        prepareUI()
    }
    
    func bindModel(_ model: AnyObject) {
        if let user = model as? RFUser {
            self.userName.text = user.username
            self.userProfileInitialName.text = "\(RFFunction.getInitialname(name: user.username!))"
            self.locationLabel.text = user.region
            self.descriptionLabel.text = "Hi I am a new user"
        }
    }
}


//MARK: - Initialize & Prepare UI
extension ProfileDescriptionCellTableViewCell {
    
    
    fileprivate func prepareUI(){
        self.userProfileImageView = getUserProfileImageView()
        self.userName = getUsername()
        self.userProfileInitialName = getUserProfileText()
        self.locationIcon = getLocationIcon()
        self.locationLabel = getLocationLabel()
        self.descriptionLabel = getDescriptionLabel()
        layoutViews()
    }
    
    fileprivate func layoutViews(){
        addSubview(userProfileImageView)
        userProfileImageView.addSubview(userProfileInitialName)
        addSubview(userName)
        addSubview(locationLabel)
        addSubview(locationIcon)
        addSubview(descriptionLabel)

        _ = userProfileImageView.anchor(top: self.topAnchor, left: self.leftAnchor, topConstant: 16, leftConstant: 16, widthConstant: 60, heightConstant: 60)
        _ = userProfileInitialName.centerConstraintWith(centerX: userProfileImageView.centerXAnchor, centerY: userProfileImageView.centerYAnchor)
        
        _ = userName.anchor(top: userProfileImageView.topAnchor, left: userProfileImageView.rightAnchor, right: self.rightAnchor, leftConstant: 8, rightConstant: 16)
        
        _ = locationIcon.anchor(top: userName.bottomAnchor, left: userName.leftAnchor, topConstant: 8, widthConstant: 12, heightConstant: 12)
        _ = locationLabel.anchor(left: locationIcon.rightAnchor, right: userName.rightAnchor, leftConstant: 8)
        _ = locationLabel.centerConstraintWith(centerY: locationIcon.centerYAnchor)
        _ = descriptionLabel.anchor(top: userProfileImageView.bottomAnchor, left: userProfileImageView.leftAnchor, right: self.rightAnchor, topConstant: 8, rightConstant: 16)
        
        
        
    }
    
    fileprivate func getUserProfileImageView() -> UIView {
        let imageView = UIView()
        imageView.backgroundColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1)
        imageView.layer.cornerRadius = 10
//        imageView.layer.masksToBounds = true
//        imageView.clipsToBounds = true
//        imageView.contentMode = .scaleAspectFill
        return imageView
    }
    
    fileprivate func getUserProfileText() -> UILabel {
        let label = UILabel()
        label.text = "D"
        label.font = RFFont.instance.headBold18
        return label
    }
    
    fileprivate func getUsername() -> UILabel {
        let label = UILabel()
        label.text = "Username"
        label.font = RFFont.instance.subHead14
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
        label.font = RFFont.instance.bodyLight14
        return label
    }
    
    fileprivate func getDescriptionLabel() -> UILabel {
        let label = UILabel()
        label.text = "Professional Chef"
        label.font = RFFont.instance.bodyMedium14
        label.numberOfLines = 0
        return label
    }
}
