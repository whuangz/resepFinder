//
//  ListOfIngredientsVC.swift
//  ResepFinder
//
//  Created by William Huang on 09/12/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import UIKit

class ListOfIngredientsVC: RFBaseController {

    private var listOfIngredientsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        prepareUI()
        registerCell()
    }
    
    func setupNavigationBar(){
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationItem.title = "Your Ingredients"
        self.setupCustomLeftBarItem(image: "back", action: #selector(self.navigateToPreviouseScreen))
    }
    
    func registerCell(){
        listOfIngredientsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

}

//MARK: - Initialize & Prepare UI
extension ListOfIngredientsVC{
    
    fileprivate func prepareUI(){
        self.view.backgroundColor = .white
        self.listOfIngredientsTableView = getTableView()
        layoutViews()
    }
    
    fileprivate func layoutViews(){
        self.view.addSubview(listOfIngredientsTableView)
        
       _ = self.listOfIngredientsTableView.anchor(top: self.view.topAnchor, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor)
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


extension ListOfIngredientsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if indexPath.row % 2 == 0 {
            cell?.backgroundColor = .red
        }
        return cell!
    }
    
    
}
