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
    private var tableView: UITableView!
    private var navigationBarHeight: CGFloat!
    private var defaultLocationKey = "KA"
    private var viewModel: HomeVM?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeData()
        setupNavigationBar()
        prepareUI()
        registerCell()
        setupGesture()
        setupLocation()
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        initializeData()
        self.tableView.reloadData()
        self.view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.endEditing(true)
    }
    
    func initializeData(){
        self.viewModel = HomeVM(vc: self)
        self.viewModel?.retrieveRecipesWith(defaultLocationID: defaultLocationKey)
    }
    
    private func setupLocation(){
        let locationName = RegionLoc(rawValue: self.defaultLocationKey)?.rawValue ?? ""
        UserDefaults.standard.setLocation(value: locationName)
    }
    
    private func setupNavigationBar(){
        self.navigationBarHeight = self.navigationController!.navigationBar.frame.size.height
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.view.backgroundColor = .clear
        self.navigationController?.navigationBar.backgroundColor = .clear
        
        self.navigationController?.navigationBar.isTranslucent = true
        self.setupCustomLeftBarItem(image: "location", action: #selector(self.navigateToChangeLocation))
    }
    
    private func registerCell(){
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "nocell")
        tableView.register(UINib(nibName: "HomeCollectionCell", bundle: nil), forCellReuseIdentifier: "HomeCollectionCell")
    }
    
    
    @objc func navigateToChangeLocation(){
        let locationVM = RFLocationVM()
        let locationVC = RFLocationVC(vm: locationVM, delegate: self)
        locationVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(locationVC, animated: true)
    }
    
    @objc func navigateToCamera(){
        let cameraVC = CameraVC()
        self.present(cameraVC, animated: true, completion: nil)
    }

}


//MARK: - Initialize & Prepare UI
extension HomeVC {
    fileprivate func prepareUI(){
        self.headerView = getHeaderView()
        self.tableView = getTableView()
        self.headerView.cameraBtn.addTarget(self, action: #selector(navigateToCamera), for: .touchUpInside)
        layoutView()
    }

    private func layoutView(){
        self.topView.addSubview(headerView)
        self.bottomView.addSubview(tableView)
        self.view.bringSubview(toFront: topView)
        
        _ = headerView.anchor(top: self.topView.topAnchor, left: self.topView.leftAnchor, bottom: self.topView.bottomAnchor, right: self.topView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
        _ = tableView.anchor(top: self.bottomView.topAnchor, left: self.bottomView.leftAnchor, bottom: self.bottomView.bottomAnchor, right: self.bottomView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
    }
    
    private func getTableView() -> UITableView {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.estimatedRowHeight = 500
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none
        tableView.bounces = false
        tableView.canCancelContentTouches = true
        tableView.delaysContentTouches = true
        
        return tableView
    }
    
    private func getHeaderView() -> HomeHeaderView{
        let headerView = Bundle.main.loadNibNamed("HomeHeaderView", owner: self, options: nil)?.first as! HomeHeaderView
        return headerView
    }
    
    private func setupGesture() {
        self.headerView.searchBar.rx.tapGesture().when(GestureRecognizerState.recognized).subscribe(onNext: { (_) in
            self.navigateToAdvanceSearch(self.defaultLocationKey)
        }).disposed(by: self.disposeBag)
    }
    
}


extension HomeVC: HomeInput {
    func setupData(vm: HomeVM) {
        self.viewModel = vm
        self.tableView.reloadData()
    }
    
}


//MARK: - Table View Delegate & Datasource implementation
extension HomeVC: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return self.viewModel?.totalRecipes ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "nocell", for: indexPath) as! UITableViewCell
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCollectionCell", for: indexPath) as! HomeCollectionCell
            cell.delegate = self
            cell.selectionStyle = .none
            if let vm = self.viewModel{
                if vm.totalRecipes != 0 {
                    let recipes = vm.getRecipes()
                    cell.bindData(data: recipes[indexPath.item], location: vm.location!)
                    cell.clipsToBounds = true
                }
            }
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return (self.topView.frame.height - self.navigationBarHeight)
        }
        return UITableViewAutomaticDimension
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
            self.setupRightBarItemWith(image: "camera_icon_snap", action: #selector(navigateToCamera))
            self.setSearchBarAsNavigation()
            self.searchBar.rx.tapGesture().when(GestureRecognizerState.recognized).subscribe(onNext: { (_) in
                self.navigateToAdvanceSearch(self.defaultLocationKey)
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
    func navigateController(_ vc: UIViewController) -> UIViewController {
        return self
    }
}

extension HomeVC: SelectLocationDelegate {
    func didChooseLocation(location: RFLocation) {
        self.defaultLocationKey = location.id!
        self.tableView.reloadData()
    }
    
}
