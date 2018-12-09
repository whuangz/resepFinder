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
    @IBOutlet weak var profileName: UILabel!
 
    override func awakeFromNib() {
        super.awakeFromNib()
        setupLabel()
    }

    
    private func setupLabel(){
        self.profileImage.backgroundColor = .red
        self.profileImage.setCornerWith(radius: 18)
        self.profileName.text = "Usernaem100"
        self.profileName.font = RFFont.instance.subHead12
    }

    func bindData(user: RFUser){
        self.profileName.text = user.username
    }
    
}
