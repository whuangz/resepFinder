//
//  RecommendVC.swift
//  ResepFinder
//
//  Created by William Huang on 18/12/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import UIKit

class RecommendVC: RFBaseController {

    let titleLbl: UILabel = {
        let title = UILabel()
        title.text = "Search By Ingredients"
        title.font = RFFont.instance.headBold18
        return title
    }()
    
    var collectionView: UICollectionView!
    
    let searchBarField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Type Ingredients here..."
        textField.borderStyle = .none
        textField.font = RFFont.instance.bodyMedium14
        textField.addLineToBottomView(color: RFColor.instance.primGray, width: 0.5)
        textField.autocorrectionType = .no
        
        return textField
    }()
    
    let plusBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .green
        btn.setImage(UIImage(named: "plus"), for: .normal)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        prepareUI()
        
    }
    
    func setupNavigationBar(){
        self.navigationController?.navigationBar.isHidden = true
    }

}

//MARK: - Initialize & prepare UI
extension RecommendVC {
    
    fileprivate func prepareUI(){
        self.view.backgroundColor = .white
        self.collectionView = getCollectionView()
        
        layoutViews()
    }
    
    
    fileprivate func layoutViews(){
        self.view.addSubview(titleLbl)
        self.view.addSubview(collectionView)
        self.view.addSubview(searchBarField)
        self.view.addSubview(plusBtn)
        
        _ = titleLbl.anchor(top: self.view.topAnchor, topConstant: 48)
        _ = titleLbl.centerConstraintWith(centerX: self.view.centerXAnchor)
        _ = searchBarField.anchor(top: self.titleLbl.bottomAnchor, topConstant: 32, widthConstant: 250, heightConstant: 35)
        _ = searchBarField.centerConstraintWith(centerX: self.titleLbl.centerXAnchor, xConstant: -20)
        _ = plusBtn.anchor(left: searchBarField.rightAnchor, leftConstant: 8, widthConstant: 35, heightConstant: 35)
        _ = plusBtn.centerConstraintWith(centerY: self.searchBarField.centerYAnchor)
        //_ = collectionView.anchor(top: self.searchBarField.bottomAnchor, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, topConstant: 24, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
    }
    
    fileprivate func getCollectionView() -> UICollectionView {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        //cv.delegate = self
        //cv.dataSource = self
        cv.backgroundColor = .white
        cv.showsHorizontalScrollIndicator = false
        cv.contentInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        cv.isScrollEnabled = false
        return cv
    }
   
}
