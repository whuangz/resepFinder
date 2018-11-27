//
//  ConversationVC.swift
//  ResepFinder
//
//  Created by William Huang on 18/11/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import UIKit

class ConversationVC: RFBaseController {

    private var searchBarView: UIView!
    private var recentConversationTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
        setupNavigationBar()
        registerCell()
    }
    
    func registerCell(){
        recentConversationTable.register(UINib(nibName: "UserMessageCell", bundle: nil), forCellReuseIdentifier: "UserMessageDetailCell")
    }
    
    func setupNavigationBar(){
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationItem.title = "Conversation"
        self.setupRightBarItemWith(image: "newmessage", action: #selector(navigateToCreateMessage))
    }
    
    @objc func navigateToCreateMessage(){
        let searchUserVC = SearchUserVC()
        self.navigationController?.pushViewController(searchUserVC, animated: true)
    }
    
}


//MARK: - Initialize & Prepare UI
extension ConversationVC{
    
    fileprivate func prepareUI(){
        self.view.backgroundColor = .white
        self.searchBarView = getSearchBarView()
        self.recentConversationTable = getTableView()
        layoutViews()
    }
    
    fileprivate func layoutViews(){
        self.view.addSubview(searchBarView)
        self.view.addSubview(recentConversationTable)
        
        _ = searchBarView.anchor(top: self.topLayoutGuide.bottomAnchor, left: self.view.leftAnchor, right: self.view.rightAnchor, leftConstant: 0, rightConstant: 0, heightConstant: 50)
        _ = recentConversationTable.anchor(top: searchBarView.bottomAnchor, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
    }
    
    private func getSearchBarView() -> UISearchBar {
        let searchBar = SearchBar(frame: .zero)
        searchBar.placeholder = "Find Conversation ..."
        searchBar.textFieldInsideSearchBar.font = RFFont.instance.bodyMedium12

        return searchBar
    }
  
    private func getTableView() -> UITableView {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none
        
        return tableView
    }
    
}

//MARK: - UITableView Delegate & Implementation
extension ConversationVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserMessageDetailCell") as! UserMessageCell
        cell.conversationCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigateToMessage()
    }
    
    func navigateToMessage(){
        let messageVC = MessageVC()
        messageVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(messageVC, animated: true)
    }
    
}
