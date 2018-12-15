//
//  SearchUserCell.swift
//  ResepFinder
//
//  Created by William Huang on 19/11/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import UIKit

class UserMessageCell: RFBaseTableCell {

    //Recent Message Outlet
    @IBOutlet weak var profileImg: RFImageView!
    fileprivate var userProfileInitialName: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    
    //Conversation Outlet
    @IBOutlet weak var messageDetailView: UIView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var messageDetail: UILabel!
    
    var user: RFUser?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    override func setupViews(){
        super.setupViews()
        configureView()
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    
        let image = selected ? UIImage(named: "check") : UIImage(named: "uncheck")
        self.checkButton.setImage(image, for: .normal)
    }
    
    func bindData(data: RFUser){
        self.user = data
        self.userName.text = data.username
        self.userProfileInitialName.text = "\(RFFunction.getInitialname(name: data.username!))"
    }
    
    func bindConversationData(data: RFConversation){
        data.getMembersName(conversation: data) { (members) in
            self.profileName.text = members.joined(separator: ", ")
            self.messageDetail.text = ""
            self.userProfileInitialName.text = "\(RFFunction.getInitialname(name: members.first!))"
        }
    }
    
}


//MARK: - Initialize & Prepare UI
extension UserMessageCell {
    
    func configureView(){
        self.userProfileInitialName = getUserProfileText()
        self.profileImg.addSubview(self.userProfileInitialName)
        _ = userProfileInitialName.centerConstraintWith(centerX: profileImg.centerXAnchor, centerY: profileImg.centerYAnchor)
        
        self.profileImg.setCornerWith(radius: 20)
        self.profileImg.backgroundColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1)
        self.messageDetailView.isHidden = true
        self.userName.isHidden = true
        self.checkButton.isHidden = true
        
        
        //custom font
        self.profileName.font = RFFont.instance.subHead14
        self.messageDetail.font = RFFont.instance.bodyLight12
        self.userName.font = RFFont.instance.bodyMedium14
    }
    
    fileprivate func getUserProfileText() -> UILabel {
        let label = UILabel()
        label.text = "D"
        label.font = RFFont.instance.headBold18
        return label
    }
   
    func conversationCell(){
        self.messageDetailView.isHidden = false
        self.profileName.text = "Username100"
        self.messageDetail.text = "hahahahahah"
    }
    
    func searchUserCell(){
        self.userName.isHidden = false
        self.checkButton.isHidden = false
        self.userName.text = "Username100"
    }
    
}
