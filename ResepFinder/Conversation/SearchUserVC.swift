//
//  SearchUserVC.swift
//  ResepFinder
//
//  Created by William Huang on 19/11/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import FirebaseAuth

class SearchUserVC: RFBaseController {
    
    private var searchBarView: UISearchBar!
    private var userTable: UITableView!
    private var viewModel: SearchUserVM = SearchUserVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
        setupNavigationBar()
        registerCell()
        observeData()
    }
    
    func registerCell(){
        userTable.register(UINib(nibName: "UserMessageCell", bundle: nil), forCellReuseIdentifier: "UserMessageCell")
    }
    
    func setupNavigationBar(){
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationItem.title = "New Message"
        self.setupRightBarItemWith(title: "Next", action: #selector(navigateToCreateMessage))
        self.setupCustomLeftBarItem(image: "back", action: #selector(self.navigateToPreviouseScreen))
    }
    
    @objc func navigateToCreateMessage(){
        if let currentUser = Auth.auth().currentUser?.uid {
            self.viewModel.createRoomBy(uid: currentUser)
            self.navigateToPreviouseScreen()
        }
    }
    
    func observeData(){
        let searchUserResults = searchBarView.rx.text.orEmpty.throttle(0.3, scheduler: MainScheduler.instance).distinctUntilChanged().flatMapLatest { (query) -> Observable<[RFUser]> in
            if query.isEmpty {
                return .just([])
            }
            return self.searchUser(query: query).catchErrorJustReturn([])
        }.observeOn(MainScheduler.instance)
        
        searchUserResults.asObservable().bind(to: self.userTable.rx.items(cellIdentifier: "UserMessageCell", cellType: UserMessageCell.self)) { (row, element, cell) in
            cell.searchUserCell()
            cell.bindData(data: element)
        }.disposed(by: self.disposeBag)
        
        self.userTable.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                let cell = self?.userTable.cellForRow(at: indexPath) as? UserMessageCell
                self?.viewModel.validateSelectedUsers(data: (cell?.user?.uid)!)
        }).disposed(by: self.disposeBag)
        
        self.userTable.rx.itemDeselected
            .subscribe(onNext: { [weak self] indexPath in
                let cell = self?.userTable.cellForRow(at: indexPath) as? UserMessageCell
                self?.viewModel.validateSelectedUsers(data: (cell?.user?.uid)!)
        }).disposed(by: self.disposeBag)
        
    
        
    }
    
    func searchUser(query: String) -> Observable<[RFUser]>{
        return Observable.create({ (observer) in

            self.viewModel.getUsers(query: query, completion: { (listofUsers) in
                observer.onNext(listofUsers)
            })
            
            return Disposables.create()
        })
    }
    
}


//MARK: - Initialize & Prepare UI
extension SearchUserVC{
    
    fileprivate func prepareUI(){
        self.view.backgroundColor = .white
        self.searchBarView = getSearchBarView()
        self.userTable = getTableView()
        layoutViews()
    }
    
    fileprivate func layoutViews(){
        self.view.addSubview(searchBarView)
        self.view.addSubview(userTable)
        
        _ = searchBarView.anchor(top: self.topLayoutGuide.bottomAnchor, left: self.view.leftAnchor, right: self.view.rightAnchor, leftConstant: 0, rightConstant: 0, heightConstant: 50)
        searchBarView.addSeperatorLine()
        _ = userTable.anchor(top: searchBarView.bottomAnchor, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
        
    }
    
    private func getSearchBarView() -> UISearchBar {
        let searchBar = SearchBar(frame: .zero)
        searchBar.searchBarStyle = .prominent
        searchBar.placeholder = "Find people ..."
        searchBar.autocorrectionType = .no
        searchBar.autocapitalizationType = .none
        searchBar.textFieldInsideSearchBar.font = RFFont.instance.bodyMedium12

        let searchText = "To:"
        let searchTextSize = (searchText as! NSString).size(withAttributes: [NSAttributedStringKey.font : RFFont.instance.bodyMedium12])
        let searchLbl = UILabel(frame: CGRect(x: 0, y: 0, width: (searchTextSize.width) , height: searchTextSize.height ))
        searchLbl.text = searchText
        searchLbl.font = RFFont.instance.bodyMedium12
        
        searchBar.textFieldInsideSearchBar.leftView = searchLbl
        
        return searchBar
    }
    
    private func getTableView() -> UITableView {
        let tableView = UITableView()
        //tableView.delegate = self
        //tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none
        tableView.allowsMultipleSelection = true
        
        return tableView
    }
    
}

//MARK: - UITableView Delegate & Implementation
extension SearchUserVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserMessageCell") as! UserMessageCell
        cell.searchUserCell()
        
        return cell
    }
    
    
}
