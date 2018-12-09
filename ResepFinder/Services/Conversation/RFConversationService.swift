//
//  RFConversationService.swift
//  ResepFinder
//
//  Created by William Huang on 08/12/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage
import RxSwift

class RFConversationService: RFDataService {
    
    func uploadText(withMsg msg: String, forUID uid: String, withGroupKey groupKey: String?, sendComplete: @escaping (_ status: Bool)->()){
        if groupKey != nil {
            let body = [
                "content": msg,
                "sender_id": uid
            ]
            CONVERSATION_REF.child(groupKey!).child("messages").childByAutoId().updateChildValues(body)
        }
    }
    
    func getAllMessagesForConversation(conversation: RFConversation, handler: @escaping (_ messages: [Message])->()){
        var messages = [Message]()
        CONVERSATION_REF.child(conversation.roomID).child("messages").observeSingleEvent(of: .value) { (groupFeedSnapShot) in
            guard let groupFeedSnapShot = groupFeedSnapShot.children.allObjects as? [DataSnapshot] else {return}
            for msg in groupFeedSnapShot {
                let content = msg.childSnapshot(forPath: "content").value as! String
                let sender_id = msg.childSnapshot(forPath: "sender_id").value as! String
                let message: Message?
                if sender_id == Auth.auth().currentUser?.uid {
                    message = Message(content: content, sender_id: sender_id, incoming: false)
                }else{
                    message = Message(content: content, sender_id: sender_id, incoming: true)
                }
                messages.append(message!)
            }
            handler(messages)
        }
    }
    
    func getAllConversations(completion: @escaping (_ conversations: [RFConversation])->()){
        let uid = Auth.auth().currentUser?.uid
        var conversations = [RFConversation]()
        CONVERSATION_REF.observeSingleEvent(of: .value) { (dataSnapshot) in
            guard let conversationData = dataSnapshot.children.allObjects as? [DataSnapshot] else {return}
            for cnv in conversationData {
                let members = cnv.childSnapshot(forPath: "members").value as! [String]
                if members.contains(uid!) {
                    let conversation = RFConversation(key: cnv.key, members: members)
                    conversations.append(conversation)
                }
                
            }
            completion(conversations)
        }
    }
    
    func createRoomWith(ids: [String], completion: @escaping (_ status: Bool)-> ()){
        let body = [
            "members": ids
            ] as [String : Any]
        CONVERSATION_REF.childByAutoId().updateChildValues(body)
        completion(true)
    }
    
}

