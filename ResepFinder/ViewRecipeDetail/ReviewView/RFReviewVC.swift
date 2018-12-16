//
//  RFReviewVC.swift
//  ResepFinder
//
//  Created by William Huang on 16/12/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import UIKit

class RFReviewVC: RFBaseController {
    
    private var viewModel: RFReviewVM?
    private var reviewList: UITableView!
    private var listOfReviews: [RFReview]?
    
    convenience init(vm: RFReviewVM) {
        self.init()
        self.viewModel = vm
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
        setupNavigationBar()
        registerCell()
        getReviews()
    }
    
    func registerCell(){
        reviewList.register(UINib(nibName: "RFReviewListCell", bundle: nil), forCellReuseIdentifier: "RFReviewListCell")
    }
    
    func setupNavigationBar(){
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationItem.title = "Reviews"
        self.setupCustomLeftBarItem(image: "back", action: #selector(self.navigateToPreviouseScreen))
    }
    
    func getReviews(){
        self.viewModel?.getListOfReviews(compeltion: { (reviews) in
            self.listOfReviews = reviews
            self.reviewList.reloadData()
        })
    }

}

//MARK: - Initialize & Prepare UI
extension RFReviewVC{
    
    fileprivate func prepareUI(){
        self.view.backgroundColor = .white
        //self.searchBarView = getSearchBarView()
        self.reviewList = getTableView()
        layoutViews()
    }
    
    fileprivate func layoutViews(){
        
        self.view.addSubview(reviewList)
        
        _ = reviewList.anchor(top: self.view.topAnchor, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
        
    }
    
    private func getTableView() -> UITableView {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.estimatedRowHeight = UITableViewAutomaticDimension
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .singleLine
        tableView.allowsMultipleSelection = false
        tableView.allowsSelection = false
        
        return tableView
    }
    
}

//MARK: - UITableView Delegate & Implementation
extension RFReviewVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let reviews = self.listOfReviews {
            return reviews.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RFReviewListCell") as! RFReviewListCell
        
        if let reviews = self.listOfReviews {
            cell.bindData(reviews[indexPath.row])
        }
        
        cell.contentView.layoutIfNeeded()
        cell.contentView.setNeedsLayout()
        
        return cell
    }

    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
}
