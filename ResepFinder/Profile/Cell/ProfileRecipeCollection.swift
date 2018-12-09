//
//  ProfileRecipesCell.swift
//  ResepFinder
//
//  Created by William Huang on 14/11/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import UIKit

class ProfileRecipeCollection: RFBaseTableCell {
    
    fileprivate var collectionView: UICollectionView!
    private var viewModel: ProfileRecipeCollectionVM?
    var delegate: NavigationControllerDelegate?
    
    override func setupViews() {
        super.setupViews()
        prepareUI()
        registerCell()
    }
    
    func registerCell(){
        self.collectionView.register(RFRecipeCell.self, forCellWithReuseIdentifier: "RECIPES")
    }
    
    func setupViewModel(vm: ProfileRecipeCollectionVM){
        self.viewModel = vm
        self.collectionView.reloadData()
    }
    
    private func navigateToViewRecipe(recipe: RFRecipe){
        let viewRecipeVM = RFViewRecipeVM(data: recipe)
        let viewRecipe = RFViewRecipeVC(vm: viewRecipeVM)
        viewRecipe.hidesBottomBarWhenPushed = true
        navigateTo(viewRecipe)
    }
    
    private func navigateTo(_ vc: UIViewController) {
        guard let delegate = self.delegate else {return}
        guard let navigationController = delegate.navigateController(vc) as? UINavigationController else {return}
        navigationController.pushViewController(vc, animated: true)
    }
    
}


//MARK: - Initialize & Prepare UI
extension ProfileRecipeCollection {
    
    fileprivate func prepareUI(){
        self.collectionView = getCollectionView()
        
        layoutViews()
    }

    fileprivate func layoutViews(){
        addSubview(collectionView)
        
        _ = collectionView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
      
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

extension ProfileRecipeCollection: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RECIPES", for: indexPath) as! RFRecipeCell
        if let recipes = self.viewModel?.recipes{
            cell.bindViewModel(model: recipes[indexPath.item])
        }
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel?.recipes?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = self.frame.width / 2 - 32
        return CGSize(width: cellWidth , height: cellWidth + 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let recipes = self.viewModel?.recipes{
            navigateToViewRecipe(recipe: recipes[indexPath.item])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16    }
}

