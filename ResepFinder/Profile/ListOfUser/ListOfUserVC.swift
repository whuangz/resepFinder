//
//  ListOfUserVC.swift
//  ResepFinder
//
//  Created by William Huang on 19/12/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import UIKit

class ListOfUserVC: RFBaseController {

    var userTableView: UITableView!
    var listOfUser: [RFUser]?
    private var vm: ListOfUserVM?
    
    convenience init (vm: ListOfUserVM) {
        self.init()
        self.vm = vm
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        prepareUI()
        registerCell()
        getListOfUserData()
    }
    
    func setupNavigationBar(){
        self.navigationController?.navigationBar.isTranslucent = false
        self.setupCustomLeftBarItem(image: "back", action: #selector(self.navigateToPreviouseScreen))
        self.navigationItem.title = self.vm?.title ?? "List of Users"
    }
    
    func registerCell(){
        userTableView.register(UINib(nibName: "UserMessageCell", bundle: nil), forCellReuseIdentifier: "UserMessageCell")
    }
    
    func getListOfUserData(){
        self.vm?.getListOfUser(completion: { (users) in
            self.listOfUser = users
            self.userTableView.reloadData()
        })
    }

}

//MARK: - Initialize & Prepare UI
extension ListOfUserVC{
    
    fileprivate func prepareUI(){
        self.view.backgroundColor = .white
        self.userTableView = getTableView()
        layoutViews()
    }
    
    fileprivate func layoutViews(){
        self.view.addSubview(userTableView)
        
        _ = userTableView.anchor(top: self.view.topAnchor, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor)
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
extension ListOfUserVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listOfUser?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserMessageCell") as! UserMessageCell
        cell.searchUserCell()
        cell.checkButton.isHidden = true
        if let users = listOfUser {
            cell.bindData(data: users[indexPath.row])
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let users = listOfUser {
            let usr = users[indexPath.row]
            self.navigateToProfileVC(uid: usr.uid ?? "")
        }
    }
    
    func navigateToProfileVC(uid: String){
        let vc = ProfileVC(uid: uid)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
