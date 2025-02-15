//
//  ProfileVC.swift
//  ResepFinder
//
//  Created by William Huang on 10/11/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import UIKit
import Firebase

class ProfileVC: UITableViewController {

    private var viewModel: ProfileVM?
    private var descriptionCell: ProfileDescriptionCellTableViewCell?
    private var detailCell: ProfileDetailsCell?
    private var recipeCollectionCell: ProfileRecipeCollection?
    private var uid: String?
    
    convenience init(uid: String){
        self.init()
        self.uid = uid
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupNavBarItem()
        setupViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //setupViewModel()
        UIApplication.shared.statusBarView?.backgroundColor = .white
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        self.tableView.reloadData()
        super.viewWillAppear(animated)
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
    
    func setupViewModel(){
        self.viewModel = ProfileVM(vc: self)
        self.viewModel?.retrieveUserDetail(uid: self.uid ?? "")
        self.tableView.reloadData()
        
        if self.uid != nil {
            let backButton = UIImage(named: "back")
            let leftMenuButton = UIBarButtonItem(image: backButton?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), style: UIBarButtonItemStyle.plain, target: self, action: #selector(navigateBack))
            self.navigationItem.leftBarButtonItem = leftMenuButton
        }
    }
    
    @objc func navigateBack(){
        self.navigationController?.popViewController(animated: true)
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
            if (self.viewModel?.hasRecipes())! {
                return self.viewModel!.recipesListHeight()
            }else{
                return 0
            }
        }
        
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
        descriptionCell = tableView.dequeueReusableCell(withIdentifier: ("ProfileDescriptionCellTableViewCell")) as? ProfileDescriptionCellTableViewCell
        self.descriptionCell?.selectionStyle = .none
        return self.descriptionCell!
    }
    
    private func createProfileDetails() -> UITableViewCell {
        detailCell = tableView.dequeueReusableCell(withIdentifier: ("ProfileDetailsCell")) as? ProfileDetailsCell
        self.detailCell?.selectionStyle = .none
        self.detailCell?.delegate = self
        return self.detailCell!
    }
    
    private func createRecipesList() -> UITableViewCell {
        recipeCollectionCell = tableView.dequeueReusableCell(withIdentifier: ("ProfileRecipeList")) as? ProfileRecipeCollection
        self.recipeCollectionCell?.selectionStyle = .none
        self.recipeCollectionCell?.delegate = self
        return self.recipeCollectionCell!
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
        let ingredientSavedImg = UIImage(named: "book")?.withRenderingMode(.alwaysOriginal)
        let ingredientSavedBtn = UIBarButtonItem(image: ingredientSavedImg, style: .plain, target: self, action: #selector(navigateToSavedIngredients))
        
        let settingImg = UIImage(named: "setting")?.withRenderingMode(.alwaysOriginal)
        let settingBtn = UIBarButtonItem(image: settingImg, style: .plain, target: self, action: #selector(navigateToSetting))
        
        self.navigationItem.rightBarButtonItems = [settingBtn, ingredientSavedBtn]
    }
    
    @objc func navigateToSavedIngredients(){
        let savedIngredientVC = ListOfIngredientsVC()
        savedIngredientVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(savedIngredientVC, animated: true)
    }
    
    @objc func navigateToSetting(){
        let settingVC = SettingVC()
        settingVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(settingVC, animated: true)
    }
    
}


protocol ProfileInput: class {
    func setupDescriptionCell(user: RFUser, recipeVM: ProfileRecipeCollectionVM)
}

extension ProfileVC: ProfileInput {
    func setupDescriptionCell(user: RFUser, recipeVM: ProfileRecipeCollectionVM) {
        //self.tableView.beginUpdates()
        self.descriptionCell?.bindModel(user)
        self.detailCell?.bindModel(user)
        self.viewModel?.totalRecipes = (user.recipes?.count)!
        self.recipeCollectionCell?.setupViewModel(vm: recipeVM)
        //self.tableView.endUpdates()
        self.tableView.reloadData()
    }
    
    
}

extension ProfileVC: NavigationControllerDelegate {
    func navigateController(_ vc: UIViewController) -> UIViewController {
        return self
    }
    
    
}
