//
//  MessageHeaderView.swift
//  ResepFinder
//
//  Created by William Huang on 20/11/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import UIKit

class MessageHeaderView: UIView {

    private var contentView: UIView!
    @IBOutlet weak var profileImage: RFImageView!
    fileprivate var userProfileInitialName: UILabel!
    @IBOutlet weak var profileName: UILabel!
 
    override func awakeFromNib() {
        super.awakeFromNib()
        setupLabel()
    }

    
    private func setupLabel(){
        self.profileImage.backgroundColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1)
        self.profileImage.setCornerWith(radius: 18)
        self.profileName.text = "Usernaem100"
        self.profileName.font = RFFont.instance.subHead12
        
        self.userProfileInitialName = getUserProfileText()
        self.profileImage.addSubview(self.userProfileInitialName)
        _ = userProfileInitialName.centerConstraintWith(centerX: profileImage.centerXAnchor, centerY: profileImage.centerYAnchor)
    }

    func bindData(user: RFUser){
        self.profileName.text = user.username
        self.userProfileInitialName.text = "\(RFFunction.getInitialname(name: user.username!))"
    }
    
    fileprivate func getUserProfileText() -> UILabel {
        let label = UILabel()
        label.text = "D"
        label.font = RFFont.instance.headBold18
        return label
    }
    
}
