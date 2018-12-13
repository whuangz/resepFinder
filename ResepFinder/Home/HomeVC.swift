//
//  HomeVCViewController.swift
//  ResepFinder
//
//  Created by William Huang on 21/11/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import UIKit
import RxGesture

class HomeVC: RFBaseController {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var topViewTopConstraint: NSLayoutConstraint!
    
    private var headerView: HomeHeaderView!
    private var collectionView: UICollectionView!
    private var navigationBarHeight: CGFloat!
    private var viewModel: HomeVM?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeData()
        setupNavigationBar()
        prepareUI()
        registerCell()
        setupGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView.reloadData()
    }
    
    func initializeData(){
        self.viewModel = HomeVM(vc: self)
        self.viewModel?.retrieveRecipes()
    }
    
    private func setupNavigationBar(){
        self.navigationBarHeight = self.navigationController!.navigationBar.frame.size.height
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.view.backgroundColor = .clear
        self.navigationController?.navigationBar.backgroundColor = .clear
        
        self.navigationController?.navigationBar.isTranslucent = true
        self.setupCustomLeftBarItem(image: "location", action: #selector(doNothing))
    }
    
    private func registerCell(){
        collectionView.register(UINib(nibName: "HomeHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header")
        collectionView.register(UINib(nibName: "HomeCollectionCell", bundle: nil), forCellWithReuseIdentifier: "HomeCollectionCell")
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "nocell")
    }
    
    @objc func doNothing(){
        print("DO NOTHING")
    }

}


//MARK: - Initialize & Prepare UI
extension HomeVC {
    fileprivate func prepareUI(){
        self.headerView = getHeaderView()
        self.collectionView = getCollectionView()
        self.headerView.cameraBtn.addTarget(self, action: #selector(doNothing), for: .touchUpInside)
        layoutView()
    }

    private func layoutView(){
        self.topView.addSubview(headerView)
        self.bottomView.addSubview(collectionView)
        self.view.bringSubview(toFront: topView)
        
        _ = headerView.anchor(top: self.topView.topAnchor, left: self.topView.leftAnchor, bottom: self.topView.bottomAnchor, right: self.topView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
        _ = collectionView.anchor(top: self.bottomView.topAnchor, left: self.bottomView.leftAnchor, bottom: self.bottomView.bottomAnchor, right: self.bottomView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
    }
    
    
    private func getCollectionView() -> UICollectionView {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.delegate = self
        cv.dataSource = self
        cv.alwaysBounceVertical = false
        cv.backgroundColor = .clear
        cv.isScrollEnabled = true
        cv.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)
        cv.scrollIndicatorInsets = UIEdgeInsets(top: 180, left: 0, bottom: 0, right: 0)
        return cv

    }
    
    private func getHeaderView() -> HomeHeaderView{
        let headerView = Bundle.main.loadNibNamed("HomeHeaderView", owner: self, options: nil)?.first as! HomeHeaderView
        return headerView
    }
    
    private func setupGesture() {
        self.headerView.searchBar.rx.tapGesture().when(GestureRecognizerState.recognized).subscribe { (_) in
            self.navigateToAdvanceSearch()
        }.disposed(by: self.disposeBag)
    }
    
}


extension HomeVC: HomeInput {
    func setupData(vm: HomeVM) {
        self.viewModel = vm
        self.collectionView.reloadData()
    }
    
}


//MARK: - Table View Delegate & Datasource implementation
extension HomeVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return self.viewModel?.totalRecipes ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "nocell", for: indexPath) as! UICollectionViewCell
            cell.backgroundColor = .clear
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionCell", for: indexPath) as! HomeCollectionCell
            cell.delegate = self
            if self.viewModel?.totalRecipes != 0 {
                if let recipes = self.viewModel?.getRecipes(){
                    cell.bindData(data: recipes[indexPath.item])
                }
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0{
            return CGSize(width: self.view.frame.width, height: self.topView.frame.height - self.navigationBarHeight)
        }
        return CGSize(width: self.view.frame.width, height: 400)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        if scrollView.contentOffset.y > 0 {
            self.topViewTopConstraint.constant = -(scrollView.contentOffset.y)
        }else{
            self.topViewTopConstraint.constant = 0
        }
        
        var offset = scrollView.contentOffset.y / 150
        let color = UIColor(red: 1, green: 1, blue: 1, alpha: offset)
        if offset > 1 {
            offset = 1
            self.navigationController?.navigationBar.backgroundColor = color
            self.navigationController?.navigationBar.tintColor = UIColor(hue: 1, saturation: offset, brightness: 1, alpha: 1)
            self.setupRightBarItemWith(image: "camera_icon_snap", action: #selector(doNothing))
            self.setSearchBarAsNavigation()
            self.searchBar.rx.tapGesture().when(GestureRecognizerState.recognized).subscribe(onNext: { (_) in
                self.navigateToAdvanceSearch()
            }).disposed(by: self.disposeBag)
            UIApplication.shared.statusBarView?.backgroundColor = color
        }else{
            
            self.navigationController?.navigationBar.backgroundColor = color
            self.navigationController?.navigationBar.tintColor = UIColor(hue: 1, saturation: offset, brightness: 1, alpha: 1)
            self.navigationItem.rightBarButtonItem = nil
            self.navigationItem.titleView = nil
            UIApplication.shared.statusBarView?.backgroundColor = color
        }
        
        print(offset)
    }
    
}

extension HomeVC: NavigationControllerDelegate {
    func navigateController(_ vc: UIViewController) -> UINavigationController {
        return self.navigationController!
    }
}
