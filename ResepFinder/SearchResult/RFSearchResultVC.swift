//
//  RFSearchResultVC.swift
//  ResepFinder
//
//  Created by William Huang on 17/12/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxGesture

class RFSearchResultVC: RFBaseController {
    
    fileprivate var collectionView: UICollectionView!
    private var viewModel: RFSearchResultVM!
    private var listOfRecipes: [RFRecipe]?
    
    convenience init(vm: RFSearchResultVM){
        self.init()
        self.viewModel = vm
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        prepareUI()
        registerCell()
        getRecipes()
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.endEditing(true)
    }
    
    private func getRecipes(){
        if let recipes = self.viewModel.listOfRecipes {
            self.listOfRecipes = recipes
            self.searchBar.placeholder = "Type Ingredients Here"
            
            if self.listOfRecipes == nil || (self.listOfRecipes?.isEmpty)!  {
                setBlankState()
            }
        }else{
            self.viewModel.getListOfQueriedRecipes { (listOfRecipes) in
                if !listOfRecipes.isEmpty {
                    self.listOfRecipes = listOfRecipes
                    self.collectionView.reloadData()
                }else{
                    self.setBlankState()
                }
            }
        }
    }
    
    fileprivate func setBlankState(){
        let blankState = RFBlankStateView(frame: self.collectionView.frame)
        self.view.addSubview(blankState)
        blankState.setBlankStateWith(title: "Recipe not found", image: UIImage(named: "not-found")!)
        _ = blankState.anchor(top: self.view.topAnchor, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
    }
    
    fileprivate func setupNavigationBar(){
        self.setupCustomLeftBarItem(image: "back", action: #selector(self.dismissToRoot))
        self.setSearchBarAsNavigation()
        self.navigationController?.navigationBar.backgroundColor = .white
    }
    
    func registerCell(){
        self.collectionView.register(RFRecipeCell.self, forCellWithReuseIdentifier: "RECIPES")
    }
    
    private func navigateToViewRecipe(recipe: RFRecipe){
        let viewRecipeVM = RFViewRecipeVM(data: recipe)
        let viewRecipe = RFViewRecipeVC(vm: viewRecipeVM)
        viewRecipe.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewRecipe, animated: true)
    }
    
    
}

//MARK: - Tableview delegate & extension
extension RFSearchResultVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RECIPES", for: indexPath) as! RFRecipeCell
        if let recipes = self.listOfRecipes{
            cell.bindViewModel(model: recipes[indexPath.item])
        }
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listOfRecipes?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = self.view.frame.width / 2 - 32
        return CGSize(width: cellWidth , height: cellWidth + 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let recipes = self.listOfRecipes{
            navigateToViewRecipe(recipe: recipes[indexPath.item])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16    }
}




//MARK: - Initialize & prepare UI
extension RFSearchResultVC {
    
    fileprivate func prepareUI(){
        self.view.backgroundColor = .white
        self.collectionView = getCollectionView()
        self.searchBar.text = self.viewModel.titleName ?? ""
        
        configureView()
        layoutViews()
    }
    
    fileprivate func configureView(){
        self.searchBar.rx.tapGesture().when(GestureRecognizerState.recognized).subscribe(onNext: { (_) in
            self.navigationController?.popViewController(animated: true)
        }).disposed(by: self.disposeBag)
    }
    
    
    fileprivate func layoutViews(){
        self.view.addSubview(collectionView)
        
        _ = collectionView.anchor(top: self.view.topAnchor, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
    }
    
    fileprivate func getCollectionView() -> UICollectionView {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .white
        cv.showsHorizontalScrollIndicator = false
        cv.contentInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        cv.isScrollEnabled = false
        return cv
    }
}
