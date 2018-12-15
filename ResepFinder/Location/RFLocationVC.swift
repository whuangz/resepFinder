//
//  RFLocationVCV.swift
//  ResepFinder
//
//  Created by William Huang on 14/12/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class RFLocationVC: RFBaseController {
    
    private var backButton: UIButton!
    private let locTitle: UILabel = {
        let label = UILabel()
        label.font = RFFont.instance.headBold14
        label.text = "Locations"
        return label
    }()
    private var searchBarView: UISearchBar!
    private var locationTable: UITableView!
    private var viewModel: RFLocationVM?
    weak var delegate: SelectLocationDelegate?
    
    convenience init(vm: RFLocationVM, delegate: SelectLocationDelegate){
        self.init()
        self.delegate = delegate
        self.viewModel = vm
    }
    
    func getLocation(){
        self.viewModel?.getLocations(completion: { [weak self ](locations) in
            self?.viewModel?.locations = locations
            self?.locationTable.reloadData()
        })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
        registerCell()
        observeData()
        getLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.locationTable.reloadData()
    }
    
    func registerCell(){
        locationTable.register(UINib(nibName: "RFLocationCell", bundle: nil), forCellReuseIdentifier: "RFLocationCell")
    }
    
    func observeData(){
//
//        self.locationTable.rx.itemSelected
//            .subscribe(onNext: { [weak self] indexPath in
//                let cell = self?.locationTable.cellForRow(at: indexPath) as? UserMessageCell
//                self?.viewModel.validateSelectedUsers(data: (cell?.user?.uid)!)
//            }).disposed(by: self.disposeBag)
//
        
//        self.locationTable.rx.itemSelected.subscribe(onNext: {[weak self] indexPath in
//
//            if let locations = self?.viewModel?.locations {
//                self?.delegate?.didChooseLocation(location: locations[indexPath.row])
//            }
//        }).disposed(by: self.disposeBag)
    
        self.backButton?.addTarget(self, action: #selector(self.dismissSwipeView), for: .touchUpInside)
        
    }
}


//MARK: - Initialize & Prepare UI
extension RFLocationVC{
    
    fileprivate func prepareUI(){
        self.view.backgroundColor = .white
        self.backButton = getButton()
        //self.searchBarView = getSearchBarView()
        self.locationTable = getTableView()
        layoutViews()
    }
    
    fileprivate func layoutViews(){
        self.view.addSubview(backButton)
        self.view.addSubview(locTitle)
        //self.view.addSubview(searchBarView)
        self.view.addSubview(locationTable)
        
        _ = backButton.anchor(top: self.topLayoutGuide.bottomAnchor, left: self.view.leftAnchor, leftConstant: 16, heightConstant: 50)
        _ = locTitle.centerConstraintWith(centerX: self.view.centerXAnchor, centerY: self.backButton.centerYAnchor)
        //_ = searchBarView.anchor(top: self.topLayoutGuide.bottomAnchor, left: self.backButton.rightAnchor, right: self.view.rightAnchor, leftConstant: 8, rightConstant: 0, heightConstant: 50)
        _ = locationTable.anchor(top: backButton.bottomAnchor, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
        
    }
    
    private func getButton() -> UIButton {
        let btn = UIButton()
        btn.setImage(UIImage(named: "back"), for: UIControlState.normal)
        return btn
    }
    
    private func getSearchBarView() -> UISearchBar {
        let searchBar = SearchBar(frame: .zero)
        searchBar.placeholder = "Search Location ..."
        searchBar.textFieldInsideSearchBar.font = RFFont.instance.bodyMedium12
        
        return searchBar
    }
    
    private func getTableView() -> UITableView {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .singleLine
        tableView.allowsMultipleSelection = false
        
        return tableView
    }
    
}

//MARK: - UITableView Delegate & Implementation
extension RFLocationVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let locations = self.viewModel?.locations {
            return locations.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RFLocationCell") as! RFLocationCell
        
        if let locations = self.viewModel?.locations {
            cell.bindData(locations[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let locations = self.viewModel?.locations {
            self.delegate?.didChooseLocation(location: locations[indexPath.row])
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
}

protocol SelectLocationDelegate: class{
    func didChooseLocation(location: RFLocation)
}
