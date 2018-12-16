//
//  RFReviewListCell.swift
//  ResepFinder
//
//  Created by William Huang on 16/12/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import UIKit
import HCSStarRatingView

class RFReviewListCell: UITableViewCell {

    @IBOutlet weak var profileImg: UIView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var rating: HCSStarRatingView!
    @IBOutlet weak var comment: UILabel!
    fileprivate var userProfileInitialName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureView()
    }
    
    func bindData(_ review:RFReview){
        self.rating.value = CGFloat(review.rating!)
        self.comment.text = review.comment
        review.getReviewerName { (username) in
            self.userProfileInitialName.text = "\(RFFunction.getInitialname(name: username))"
            self.userName.text = username
        }
    }
    
    fileprivate func configureView(){
        self.userProfileInitialName = getUserProfileText()
        self.profileImg.addSubview(self.userProfileInitialName)
        _ = userProfileInitialName.centerConstraintWith(centerX: profileImg.centerXAnchor, centerY: profileImg.centerYAnchor)
        self.profileImg.layer.cornerRadius = 20
        self.profileImg.backgroundColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1)
        
        self.userName.font = RFFont.instance.subHead16
        self.userProfileInitialName.font = RFFont.instance.subHead14
        self.comment.font = RFFont.instance.bodyMedium14
        
    }
    
    fileprivate func getUserProfileText() -> UILabel {
        let label = UILabel()
        label.text = "D"
        label.font = RFFont.instance.headBold18
        return label
    }
    
}
