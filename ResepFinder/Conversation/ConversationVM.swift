//
//  ConversationVM.swift
//  ResepFinder
//
//  Created by William Huang on 08/12/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import Foundation

class ConversationVM {
    
    private let service = RFConversationService()
    
    init() {
        
    }
    
    func getConversations(completion: @escaping (_ data: [RFConversation])->()){
        self.service.getAllConversations { (conversations) in
            completion(conversations)
        }
    }
}
