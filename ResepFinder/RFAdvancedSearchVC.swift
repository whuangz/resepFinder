//
//  AdvancedSearchVC.swift
//  ResepFinder
//
//  Created by William Huang on 24/11/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import UIKit

class RFAdvancedSearchVC: RFBaseController {

    var searchTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
        registerCell()
        setupNavigationBar()
        self.searchBar.becomeFirstResponder()
    }
    
    private func registerCell(){
        self.searchTableView.register(UITableViewCell.self, forCellReuseIdentifier: "searchCell")
    }
    
    fileprivate func setupNavigationBar(){
        self.setupCustomLeftBarItem(image: "back", action: #selector(self.navigateToPreviouseScreen))
        self.setSearchBarAsNavigation()
        self.navigationController?.navigationBar.backgroundColor = .white
    }

}

//MARK: - Tableview delegate & extension
extension RFAdvancedSearchVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell")
        return cell!
    }
    
}


//MARK: - Initialize & prepare UI
extension RFAdvancedSearchVC {
    
    fileprivate func prepareUI(){
        self.view.backgroundColor = .white
        self.searchTableView = getTableView()
        layoutViews()
    }
    
    
    fileprivate func layoutViews(){
        self.view.addSubview(searchTableView)
        
        _ = searchTableView.anchor(top: self.view.topAnchor, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
    }
    
    private func getSearchBarView() -> SearchBar {
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
        tableView.separatorStyle = .singleLine
        tableView.tableFooterView = UIView(frame: .zero)
        
        return tableView
    }
}
