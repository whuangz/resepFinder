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
    private var viewModel: ListOfIngredientsVM?
    private var listOfRecipes: [RFRecipe]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupViewModel()
        prepareUI()
        registerCell()
    }
    
    func setupViewModel(){
        self.viewModel = ListOfIngredientsVM()
        self.viewModel?.getSavedIngredients { (recipes) in
            self.listOfRecipes = recipes
            self.listOfIngredientsTableView.reloadData()
        }
    }
    
    func setupNavigationBar(){
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationItem.title = "Your Shopping List"
        self.setupCustomLeftBarItem(image: "back", action: #selector(self.navigateToPreviouseScreen))
    }
    
    func registerCell(){
        listOfIngredientsTableView.register(RecipeListCell.self, forCellReuseIdentifier: "cell")
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
        return (self.listOfRecipes?.count) ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! RecipeListCell
        if let recipes = self.listOfRecipes {
            cell.bindModel(recipes[indexPath.row])
        }
        return cell
    }
    
    
}
