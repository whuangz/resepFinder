//
//  RFConversation.swift
//  ResepFinder
//
//  Created by William Huang on 08/12/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import Foundation

class RFConversation {
    
    private var _roomID: String
    private var _roomMembers: [String]
    private var service = RFDataService()
    
    var roomID: String {
        return _roomID
    }
    
    var roomMembers: [String] {
        return _roomMembers
    }
    
    init(key: String, members: [String]) {
        self._roomID = key
        self._roomMembers = members
    }
    
    func getMembersName(conversation: RFConversation, completion: @escaping (_ name: [String])->()){
        self.service.getConversationUsername(conversation: conversation) { (usernames) in
            completion(usernames)
        }
    }

}
