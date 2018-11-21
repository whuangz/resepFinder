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
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    
    //Conversation Outlet
    @IBOutlet weak var messageDetailView: UIView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var messageDetail: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    override func setupViews(){
        super.setupViews()
        self.profileImg.setCornerWith(radius: 20)
        self.profileImg.backgroundColor = .red
        
        self.messageDetailView.isHidden = true
        self.userName.isHidden = true
        self.checkButton.isHidden = true
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    
        let image = selected ? UIImage(named: "check") : UIImage(named: "uncheck")
        self.checkButton.setImage(image, for: .normal)
    }
    
}


//MARK: - Initialize & Prepare UI
extension UserMessageCell {
   
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
