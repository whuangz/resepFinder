//
//  RecommendVC.swift
//  ResepFinder
//
//  Created by William Huang on 18/12/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxGesture

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
        btn.setImage(UIImage(named: "plus"), for: .normal)
        return btn
    }()
    
    var inputtedIngredients = [String]()
    private var viewModel: RecommendVM?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        prepareUI()
        registerCell()
        observeData()
        setViewModel()
    }
    
    func setViewModel(){
        self.viewModel = RecommendVM()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.searchBarField.text = ""
        self.inputtedIngredients = [String]()
        self.collectionView.reloadData()
        self.view.endEditing(true)
    }
    
    func setupNavigationBar(){
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.view.backgroundColor = .clear
        self.navigationController?.navigationBar.backgroundColor = .clear
        self.setupRightBarItemWith(title: "FIND", action: #selector(navigateToFindRecipe))
    }

    @objc func navigateToFindRecipe(){
        if inputtedIngredients.count == 0 {
            RFAlertHelper.instance.showFailureAlert("Cannot recommend zero ingredients")
        }else if(inputtedIngredients.count < 3){
            RFAlertHelper.instance.showFailureAlert("Ingredients must be minimum 3 to be recommended")
        }else{
            let location = UserDefaults.standard.getLocation()
            if let vm = self.viewModel {
                vm.findRecipeBasedOn(self.inputtedIngredients, withLocation: location) { (listOfRecipes) in
                    self.navigateToSearchResult(recipes: listOfRecipes)
                }
            }
        }
    }
    
    func navigateToSearchResult(recipes: [RFRecipe]){
        let vm = RFSearchResultVM(listOfRecipes: recipes)
        let vc = RFSearchResultVC(vm: vm)
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func registerCell(){
        self.collectionView.register(RoundedCollectionCell.self, forCellWithReuseIdentifier: "roundedCell")
    }
    
    func observeData(){
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didDismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        searchBarField.rx.controlEvent([.editingDidEnd])
            .asObservable()
            .subscribe(onNext: { _ in
                print("editing state changed")
            }).disposed(by: self.disposeBag)
        
        self.plusBtn.rx.tapGesture().when(GestureRecognizerState.ended).subscribe(onNext: { (_) in
            
            if !self.inputtedIngredients.contains(self.searchBarField.text!) && self.searchBarField.text != ""{
                self.inputtedIngredients.append(self.searchBarField.text! )
                self.searchBarField.text = ""
                self.collectionView.reloadData()
            }
        }).disposed(by: self.disposeBag)
       
    }
    
    @objc func didDismissKeyboard(){
        self.view.endEditing(true)
    }
    
}

extension RecommendVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "roundedCell", for: indexPath) as! RoundedCollectionCell
        cell.bindData(self.inputtedIngredients[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
        let size = RoundedCollectionCell.sizeWithText(self.inputtedIngredients[indexPath.row])
        if size.width >= (RFScreenHelper.screenWidth() - 64) {
            return CGSize(width: RFScreenHelper.screenWidth() - 64, height: size.height)
        }else{
            return size
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return inputtedIngredients.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

extension RecommendVC: RemoveQueriedProtocol {
    func didRemove(data: String) {
        self.inputtedIngredients = inputtedIngredients.filter({ $0 != data})
        self.collectionView.reloadData()
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
        
        _ = titleLbl.anchor(top: self.topLayoutGuide.topAnchor, topConstant: 80)
        _ = titleLbl.centerConstraintWith(centerX: self.view.centerXAnchor)
        _ = searchBarField.anchor(top: self.titleLbl.bottomAnchor, left: self.view.leftAnchor, topConstant: 32, leftConstant: 32,  heightConstant: 35)
        _ = searchBarField.centerConstraintWith(centerX: self.titleLbl.centerXAnchor, xConstant: -20)
        _ = plusBtn.anchor(left: searchBarField.rightAnchor, leftConstant: 8, widthConstant: 30, heightConstant: 30)
        _ = plusBtn.centerConstraintWith(centerY: self.searchBarField.centerYAnchor)
        _ = collectionView.anchor(top: self.searchBarField.bottomAnchor, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, topConstant: 24, leftConstant: 32, bottomConstant: 0, rightConstant: 32)
    }
    
    fileprivate func getCollectionView() -> UICollectionView {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .white
        cv.showsHorizontalScrollIndicator = false
        cv.showsVerticalScrollIndicator = false
        //cv.contentInset = UIEdgeInsets(top: 16, left: 32, bottom: 16, right: 32)
        cv.isScrollEnabled = true
        return cv
    }
   
}
