//
//  SearchUserVM.swift
//  ResepFinder
//
//  Created by William Huang on 08/12/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import Foundation

class SearchUserVM {
    var selectedUsers: [String]?
    private let service = RFConversationService()
    
    init() {
        self.selectedUsers = [String]()
    }
    
    func getUsers(query: String, completion: @escaping (_ users: [RFUser]) ->()){
        service.getAllUsers(query: query) { (listOfUsers) in
            completion(listOfUsers)
        }
    }
    
    func validateSelectedUsers(data: String){
        
        if selectedUsers != nil {
            if !(selectedUsers?.contains(data))! {
                selectedUsers?.append(data)
            }else{
                selectedUsers = selectedUsers?.filter({ $0 != data})
            }
        }
    }
    
    func createRoomBy(uid: String){
        if var users = self.selectedUsers{
            users.append(uid)
            service.createRoomWith(ids: users) { (status) in
                if status {
                    print("Room Created")
                }
            }
        }
    }
}
