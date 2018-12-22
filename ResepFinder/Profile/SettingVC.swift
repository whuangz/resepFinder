//
//  SettingVC.swift
//  ResepFinder
//
//  Created by William Huang on 14/11/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import UIKit

class SettingVC: UITableViewController {

    private var viewModel: SettingVM!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        intializer()
        setupTableView()
        setupNavigationBar()
        registerCell()
    }
    
    private func intializer(){
        self.viewModel = SettingVM()
    }
    
    private func setupTableView(){
        //self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    private func setupNavigationBar(){
        self.navigationItem.title = "Setting"
        self.navigationItem.hidesBackButton = true
        let backButton = UIImage(named: "back")
        let leftMenuButton = UIBarButtonItem(image: backButton?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), style: UIBarButtonItemStyle.plain, target: self, action: #selector(navigateBack))
        
        self.navigationItem.leftBarButtonItem = leftMenuButton

    }
    
    @objc func navigateBack(){
        self.navigationController?.popViewController(animated: true)
    }
    
    private func registerCell(){
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: ("logoutCell"))
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let settingCell = RFSettingCell(rawValue: indexPath.item)
        switch settingCell! {
        case .logout:
            return createLogoutCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let settingCell = RFSettingCell(rawValue: indexPath.item)
        switch settingCell! {
        case .logout:
            showLogoutDialog()
        }
    }
    
    //MARK: - CREATE CELL
    
    func createLogoutCell() -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "logoutCell")
    
        cell?.textLabel?.text = RFLocalizedString().forKey("log_out_label")
        cell?.textLabel?.font = RFFont.instance.bodyMedium14
        
        return cell!
    }

    
    //MARK: - REDIRECT
    func showLogoutDialog(){
        let dialog = RFDialogView.instance
        dialog.showDialogWith(title: "Logout", content: "Are you sure want to log out?", leftBtn: "No", rightBtn: "Logout") {
            RFAlertHelper.instance.showSuccessAlert("Successfully Log out", tapCompletion: { (_) in
            })
            self.viewModel.doLogout()
        }
    }
}
