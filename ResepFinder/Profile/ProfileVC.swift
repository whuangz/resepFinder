//
//  ProfileVC.swift
//  ResepFinder
//
//  Created by William Huang on 10/11/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import UIKit

class ProfileVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavBarItem()
    }
    
    private func setupTableView(){
        self.tableView.separatorStyle = .none
        registerCell()
    }
    
    private func registerCell(){
        tableView.register(ProfileDescriptionCellTableViewCell.self, forCellReuseIdentifier: ("ProfileDescriptionCellTableViewCell"))
        tableView.register(ProfileDetailsCell.self, forCellReuseIdentifier: ("ProfileDetailsCell"))
        tableView.register(ProfileRecipeCollection.self, forCellReuseIdentifier: ("ProfileRecipeList"))
        
    }
    
    deinit {
        print("AAA")
    }
}


//MARK: - TableView Delege & Data Source Implementation
extension ProfileVC {

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let profileSection = RFProfileSection(rawValue: (indexPath.section))
        
        switch profileSection! {
        case .description:
            return 150
        case .details:
            return 80
        case .recipes:
            return recipesListHeight()
        }
        
    }
    
    func recipesListHeight() -> CGFloat{
        let numberOfItem = ceil(CGFloat(10/2))
        let horizontalPadding: CGFloat = 32 + 32
        let paddingRow: CGFloat = 32 + 64
        let cellWidth: CGFloat = self.view.frame.width / 2 + 50 - 32
        return numberOfItem * cellWidth + paddingRow
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let profileSection = RFProfileSection(rawValue: (indexPath.section))
        
        switch profileSection! {
        case .description:
            return createProfileDescription()
        case .details:
            return createProfileDetails()
        case .recipes:
            return createRecipesList()
        }
        
    }
    
    private func createProfileDescription() -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ("ProfileDescriptionCellTableViewCell")) as! ProfileDescriptionCellTableViewCell
        cell.selectionStyle = .none
        return cell
    }
    
    private func createProfileDetails() -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ("ProfileDetailsCell")) as! ProfileDetailsCell
        cell.selectionStyle = .none
        return cell
    }
    
    private func createRecipesList() -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ("ProfileRecipeList")) as! ProfileRecipeCollection
        cell.selectionStyle = .none
        return cell
    }
}


//MARK: - Initialize Navigation Bar
extension ProfileVC {
    private func setupNavBarItem(){
//        /setupLeftBarItem()
        setupRightBarItem()
    }
    
    private func setupLeftBarItem(){
        let userNameLbl = UILabel()
        userNameLbl.text = "Username"
        userNameLbl.textColor = RFColor.instance.black
        userNameLbl.sizeToFit()
        
        let userNameItem = UIBarButtonItem(customView: userNameLbl)
        self.navigationItem.leftBarButtonItem = userNameItem
    }
    
    private func setupRightBarItem(){
        let settingImg = UIImage(named: "setting")?.withRenderingMode(.alwaysOriginal)
        let settingBtn = UIBarButtonItem(image: settingImg, style: .plain, target: self, action: #selector(navigateToSetting))
        
        self.navigationItem.rightBarButtonItems = [settingBtn]
    }
    
    @objc func navigateToSetting(){
        let settingVC = SettingVC()
        self.navigationController?.pushViewController(settingVC, animated: true)
    }
    
}
