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
    
    override func setupViews() {
        super.setupViews()
        prepareUI()
        registerCell()
    }
    
    func registerCell(){
        self.collectionView.register(RFRecipeCell.self, forCellWithReuseIdentifier: "RECIPES")
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
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = self.frame.width / 2 - 32
        return CGSize(width: cellWidth , height: cellWidth + 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16    }
}

