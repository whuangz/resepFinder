//
//  AdvancedSearchVC.swift
//  ResepFinder
//
//  Created by William Huang on 24/11/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class RFAdvancedSearchVC: RFBaseController {

    var searchTableView: UITableView!
    private var viewModel: RFAdvancedSearchVM!
    
    convenience init(vm: RFAdvancedSearchVM){
        self.init()
        self.viewModel = vm
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
        registerCell()
        setupNavigationBar()
        observeData()
        self.searchBar.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }
    

    fileprivate func setupNavigationBar(){
        self.setupCustomLeftBarItem(image: "back", action: #selector(self.navigateToPreviouseScreen))
        self.setSearchBarAsNavigation()
        self.navigationController?.navigationBar.backgroundColor = .white
    }

    private func registerCell(){
        self.searchTableView.register(UINib(nibName: "RFSearchCell", bundle: nil), forCellReuseIdentifier: "RFSearchCell")
    }
    
    func observeData(){
        let searchUserResults = self.searchBar.rx.text.orEmpty.throttle(0.3, scheduler: MainScheduler.instance).distinctUntilChanged().flatMapLatest { (query) -> Observable<[RFRecipe]> in
            if query.isEmpty {
                return .just([])
            }
            return self.searchRecipe(query: query).catchErrorJustReturn([])
            }.observeOn(MainScheduler.instance)
        
        searchUserResults.asObservable().bind(to: self.searchTableView.rx.items(cellIdentifier: "RFSearchCell", cellType: RFSearchCell.self)) { (row, element, cell) in
            cell.bindData(data: element)
            }.disposed(by: self.disposeBag)
        
        self.searchTableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                let cell = self?.searchTableView.cellForRow(at: indexPath) as? RFSearchCell
                self?.navigateToSearchResult(byTitle: cell?.recipeTitle ?? "")
            }).disposed(by: self.disposeBag)
        
    }
    
    func searchRecipe(query: String) -> Observable<[RFRecipe]>{
        return Observable.create({ (observer) in
            self.viewModel.getRecipesBy(query: query, completion: { (listOfRecipes) in
                observer.onNext(listOfRecipes)
            })
            
            return Disposables.create()
        })
    }
    
    func navigateToSearchResult(byTitle title:String){
        let vm = RFSearchResultVM(title: title, location: self.viewModel.getLocation())
        let vc = RFSearchResultVC(vm: vm)
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

//MARK: - Tableview delegate & extension
extension RFAdvancedSearchVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell")
        return cell!
    }
    
}


//MARK: - Initialize & prepare UI
extension RFAdvancedSearchVC {
    
    fileprivate func prepareUI(){
        self.view.backgroundColor = .white
        self.searchTableView = getTableView()
        layoutViews()
    }
    
    
    fileprivate func layoutViews(){
        self.view.addSubview(searchTableView)
        
        _ = searchTableView.anchor(top: self.view.topAnchor, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
    }
    
    private func getSearchBarView() -> SearchBar {
        let searchBar = SearchBar(frame: .zero)
        searchBar.placeholder = "Find Conversation ..."
        searchBar.textFieldInsideSearchBar.font = RFFont.instance.bodyMedium12
        
        return searchBar
    }
    
    private func getTableView() -> UITableView {
        let tableView = UITableView()
        
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .singleLine
        tableView.tableFooterView = UIView(frame: .zero)
        
        return tableView
    }
}
