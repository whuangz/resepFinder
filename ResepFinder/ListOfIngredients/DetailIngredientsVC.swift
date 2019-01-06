//
//  DetailIngredientsVC.swift
//  ResepFinder
//
//  Created by William Huang on 10/12/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import UIKit

class DetailIngredientsVC: RFBaseController {

    private var ingredientsTableView: UITableView!
    private var listOfIngredientsItem: [String]?
    private var viewModel: DetailIngredientsVM?
    
    convenience init(vm: DetailIngredientsVM) {
        self.init()
        self.viewModel = vm
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        prepareUI()
        registerCell()
    }
    
    func setupNavigationBar(){
        if viewModel != nil {
            self.navigationItem.title = self.viewModel?.recipe?.title
        }
        self.navigationController?.navigationBar.isTranslucent = false
        
        self.setupCustomLeftBarItem(image: "back", action: #selector(self.navigateToPreviouseScreen))
    }
    
    func registerCell(){
        self.ingredientsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

}

//MARK: - Initialize & Prepare UI
extension DetailIngredientsVC{
    
    fileprivate func prepareUI(){
        self.view.backgroundColor = .white
        self.ingredientsTableView = getTableView()
        
        layoutViews()
    }
    
    fileprivate func layoutViews(){
        self.view.addSubview(self.ingredientsTableView)
        
        _ = self.ingredientsTableView.anchor(top: self.view.topAnchor, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor)
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


extension DetailIngredientsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.getIngredients().count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! UITableViewCell
        if let ingredients = self.viewModel?.getIngredients() {
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.text = "\(ingredients[indexPath.row])"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
}
