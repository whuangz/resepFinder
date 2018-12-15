//
//  StartCookingVC.swift
//  ResepFinder
//
//  Created by William Huang on 26/11/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import UIKit

class StartCookingVC: RFBaseController {
    
    private var collectionView: UICollectionView!
    private var totalSteps: CGFloat = 4
    var viewModel: StartCookingVM?
    
    private let closeBtn: RFPrimaryBtn = {
        let btn = RFPrimaryBtn()
        btn.setContentImageFor(active: "close", inactive: "close")
        btn.setCornerWith(radius: 12)
        btn.backgroundColor = .white
        return btn
    }()
    
    private let progressView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.init(white: 0.9, alpha: 0.8).cgColor
        view.layer.borderWidth = 1.0
        return view
    }()
    
    private let progress: UIView = {
        let view = UIView()
        view.backgroundColor = RFColor.instance.primaryGreen
        return view
    }()
    
    private var progressWidth: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
        registerCell()
        addGesture()
    }
    
    convenience init(vm: StartCookingVM) {
        self.init()
        self.viewModel = vm
        self.totalSteps = CGFloat(self.viewModel?.steps?.count ?? 0)
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    func registerCell(){
        collectionView.register(StepsCell.self, forCellWithReuseIdentifier: "stepsCell")
        collectionView.register(CreateReviewsCell.self, forCellWithReuseIdentifier: "createReviewsCell")
    }
    
    func addGesture(){
        closeBtn.rx.tap.subscribe(onNext: { (_) in
            self.dismissToPreviousScreen()
        }).disposed(by: self.disposeBag)
    }
    
}


//MARK: - Initialize & Prepare UI
extension StartCookingVC{
    
    fileprivate func prepareUI(){
        self.view.backgroundColor = .white
        self.collectionView = getCollectionView()
        
        layoutViews()
    }
    
    fileprivate func layoutViews(){
        self.view.addSubview(collectionView)
        self.view.addSubview(closeBtn)
        self.view.addSubview(progressView)
        self.progressView.addSubview(progress)
        
        
        _ = collectionView.anchor(top: self.view.topAnchor, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
        _ = closeBtn.anchor(top: self.view.topAnchor, left: self.view.leftAnchor, topConstant: 8, leftConstant: 8, widthConstant: 24, heightConstant: 24)
        _ = progressView.anchor(left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, heightConstant: 40)
        
        _ = progress.anchor(top: self.progressView.topAnchor, left: self.progressView.leftAnchor, bottom: self.progressView.bottomAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0)
        progressWidth = progress.widthAnchor.constraint(equalToConstant: RFScreenHelper.screenWidth() / (totalSteps + 1))
        progressWidth.isActive = true
    }
    
    private func getCollectionView() -> UICollectionView {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.scrollDirection = .horizontal
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = .white
        cv.showsHorizontalScrollIndicator = false
        cv.alwaysBounceHorizontal = false
        cv.bounces = false
        cv.isPagingEnabled = true
        cv.isScrollEnabled = true

        return cv
    }
    
}

//MARK: - UITableView Delegate & Implementation
extension StartCookingVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Int(totalSteps + 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row >= Int(totalSteps) {
            return createReviewCell(indexPath: indexPath)
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "stepsCell", for: indexPath) as! StepsCell
            cell.stepNo.setTitle("\(indexPath.item + 1)", for: UIControlState.normal)
            if let steps = self.viewModel?.steps {
                cell.bindData(data: (steps[indexPath.item]))
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    private func createReviewCell(indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "createReviewsCell", for: indexPath) as! CreateReviewsCell
        cell.bindData(data: (self.viewModel?.recipeImg)!)
        cell.delegate = self
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offset = scrollView.contentOffset.x / RFScreenHelper.screenWidth()
        progressWidth.constant = (RFScreenHelper.screenWidth() / (totalSteps + 1) * (offset + 1))
    
    }
    
}

extension StartCookingVC: ReviewRecipeProtocol{
    func didSendReview(_ data: RFReview) {
        self.viewModel?.submitReview(data)
        self.dismiss(animated: true, completion: nil)
    }
    
}
