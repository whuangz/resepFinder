//
//  MessageCell.swift
//  ResepFinder
//
//  Created by William Huang on 20/11/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    
    let messageLbl = UILabel()
    let bubbleRadiusView = UIView()
    
    var chatMessages: Message! {
        didSet{
            if chatMessages.incoming == true {
                bubbleRadiusView.backgroundColor = UIColor.white
                messageLbl.textColor = UIColor.darkGray
                leadingMsgLbl.isActive = true
                trailingMsgLbl.isActive = false
            }else {
                bubbleRadiusView.backgroundColor = UIColor.darkGray
                messageLbl.textColor = UIColor.white
                leadingMsgLbl.isActive = false
                trailingMsgLbl.isActive = true
            }
            
            messageLbl.text = chatMessages.content
        }
    }
    
    var leadingMsgLbl: NSLayoutConstraint!
    var trailingMsgLbl: NSLayoutConstraint!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(bubbleRadiusView)
        
        self.backgroundColor = .clear
        bubbleRadiusView.layer.cornerRadius = 15
        bubbleRadiusView.backgroundColor = UIColor.yellow
        bubbleRadiusView.translatesAutoresizingMaskIntoConstraints = false
        
        bubbleRadiusView.addSubview(messageLbl)
        //messageLbl.text = "HAHAHHA"
        messageLbl.translatesAutoresizingMaskIntoConstraints = false
        messageLbl.numberOfLines = 0
        let constraint = [
            messageLbl.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            messageLbl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32),
            messageLbl.widthAnchor.constraint(lessThanOrEqualToConstant: 250),
            
            bubbleRadiusView.topAnchor.constraint(equalTo: messageLbl.topAnchor, constant: -16),
            bubbleRadiusView.leadingAnchor.constraint(equalTo: messageLbl.leadingAnchor, constant: -16),
            bubbleRadiusView.bottomAnchor.constraint(equalTo: messageLbl.bottomAnchor, constant: 16),
            bubbleRadiusView.trailingAnchor.constraint(equalTo: messageLbl.trailingAnchor, constant: 16)
        ]
        
        leadingMsgLbl = messageLbl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32)
        trailingMsgLbl = messageLbl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32)
        
        NSLayoutConstraint.activate(constraint)
        
        self.messageLbl.font = RFFont.instance.bodyMedium14
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class Message {
    var content: String!
    var incoming: Bool!
    var sender_id: String!
    //var date: Date!
    
    init(content: String, sender_id: String, incoming: Bool) {
        self.content = content
        self.sender_id = sender_id
        self.incoming = incoming
    }
}

extension Date {
    static func dateFormatString(date: String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyy"
        return dateFormatter.date(from: date) ?? Date()
    }
}

