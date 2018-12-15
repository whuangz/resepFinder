//
//  MessageVM.swift
//  ResepFinder
//
//  Created by William Huang on 08/12/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import Foundation
import Firebase

class MessageVM {
    var conversation: RFConversation?
    private let service = RFConversationService()
    
    init(data: RFConversation) {
        self.conversation = data
    }
    
    func getUsers(completion: @escaping (_ user: RFUser)->()){
        //only take 1 user
        let uid = Auth.auth().currentUser?.uid
        if let members = conversation?.roomMembers {
            for mmb in members {
                if mmb != uid {
                    service.getUser(forUid: mmb) { (user) in
                        completion(user)
                    }
                }
            }
        }
    }
    
    func getMessages(completion: @escaping (_ messages: [Message])->()){
        if let conversation = self.conversation {
            service.getAllMessagesForConversation(conversation: conversation) { (messages) in
                completion(messages)
            }
        }
    }
    
    func uploadMessage(msg: String, groupID: String){
        let userID = Auth.auth().currentUser?.uid
        self.service.uploadText(withMsg: msg, forUID: userID!, withGroupKey: groupID) { (status) in
            if status {
                print("Uploaded")
            }
        }
    }
}
