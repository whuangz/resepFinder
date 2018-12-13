//
//  RFViewRecipeVC.swift
//  ResepFinder
//
//  Created by William Huang on 25/11/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import UIKit
import FirebaseAuth

class RFViewRecipeVC: RFBaseController {
    
    private var tableView: RFParallaxTableView!
    private var viewModel: RFViewRecipeVM?
    
    let headerView: CachedImageView = {
        let imageView = CachedImageView()
        imageView.image = UIImage(named: "recipe1")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let titleLbl: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "Title With Rumah makan abadi sate padang akaman bdat koko conu"
        label.font = RFFont.instance.headBold14
        label.textColor = .white
        return label
    }()
    
    let profileImage: RFImageView = {
        let imageView = RFImageView()
        imageView.backgroundColor = .red
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.setCornerWith(radius: 15)
        return imageView
    }()
    
    let profileLbl: UILabel = {
        let label = UILabel()
        label.text = "Username100"
        label.font = RFFont.instance.bodyMedium12
        return label
    }()
    
    let followBtn: RFPrimaryBtn = {
        let button = RFPrimaryBtn()
        button.setTitle("Follow", for: .normal)
        button.isHidden = true
        button.setTitleColor(RFColor.instance.black, for: .normal)
        button.backgroundColor = UIColor.init(white: 0.9, alpha: 0.8)
        button.titleLabel?.font = RFFont.instance.bodyMedium10
        button.setCornerWith(radius: 5)
        return button
    }()
    
    let bottomView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: RFScreenHelper.screenWidth() , height: 80))
        return view
    }()
    
    let startBtn: RFPrimaryBtn = {
        let btn = RFPrimaryBtn()
        btn.setTitle("Start Cooking", for: .normal)
        btn.setTitleColor(RFColor.instance.black, for: .normal)
        btn.backgroundColor = RFColor.instance.primaryGreen
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.font = RFFont.instance.subHead14
        btn.setCornerWith(radius: 15)
        
        return btn
    }()
    
    convenience init(vm: RFViewRecipeVM) {
        self.init()
        self.viewModel = vm
    }

    
    func getRecipe() -> RFRecipe {
        return self.viewModel?.recipe ?? RFRecipe()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        prepareUI()
        registerCell()
        addGesture()
    }
    
    private func setupNavigationBar(){
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.view.backgroundColor = .clear
        self.navigationController?.navigationBar.backgroundColor = .clear
        
        self.navigationController?.navigationBar.isTranslucent = true
        self.setupCustomLeftBarItem(image: "close", action: #selector(self.navigateToPreviouseScreen))
    }
    
    private func registerCell(){
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "headerCell")
        self.tableView.register(DescriptionCell.self, forCellReuseIdentifier: "createDescriptionCell")
        self.tableView.register(ReviewCell.self, forCellReuseIdentifier: "createReviewCell")
        self.tableView.register(IngredientsCell.self, forCellReuseIdentifier: "createIngredientsCell")
    }
    
    @objc func doNothing(){
        print("DO NOTHING")
    }
    
    @objc func navigateToStartCooking(){
        if let recipe = self.getRecipe() as? RFRecipe {
            let startVM = StartCookingVM(data: recipe.steps!, recipeImg: recipe.recipePathToImg!)
            let startVC = StartCookingVC(vm: startVM)
            self.present(startVC, animated: true, completion: nil)
        }
    }
}


extension RFViewRecipeVC {
    
    private func prepareUI(){
        self.tableView = getTableView()
        self.tableView.tableHeaderView = headerView
        self.tableView.constructParallaxHeader()
        self.tableView.tableFooterView = bottomView
        layoutViews()
        configureView()
    }
    
    private func configureView(){
        self.setupFollowBtn()
    }
    
    fileprivate func setupFollowBtn(){
        if let recipeUID = (self.viewModel?.recipe?.uid), let service = self.viewModel?.service {
            if recipeUID == Auth.auth().currentUser?.uid{
                self.followBtn.isHidden = true
            }else{
                self.followBtn.isHidden = false
                self.followBtn.rx.tap.subscribe(onNext: {
                    self.followBtn.animateTouch(duration: 0.2)
                    service.checkFollowRelation(userID: (recipeUID)) { (selected) in
                        if selected {
                            self.followBtn.setTitle("Follow", for: .normal)
                            service.removeFollowing(userID: (recipeUID))
                        }else{
                            self.followBtn.setTitle("Unfollow", for: .normal)
                            service.addFollowing(userID: (recipeUID))
                        }
                    }
                }).disposed(by: self.disposeBag)
            }
        }
    }
    
    private func addGesture() {
        self.startBtn.rx.tap.subscribe(onNext: { (_) in
            self.navigateToStartCooking()
        }).disposed(by: self.disposeBag)
    }
    
    private func layoutViews(){
        self.view.addSubview(tableView)
        self.tableView.addSubview(titleLbl)
        self.tableView.addSubview(profileImage)
        self.tableView.addSubview(profileLbl)
        self.tableView.addSubview(followBtn)
        self.bottomView.addSubview(startBtn)
        
        _ = tableView.anchor(top: self.view.topAnchor, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor)
        _ = titleLbl.anchor(left: self.headerView.leftAnchor, bottom: self.headerView.bottomAnchor, right: self.headerView.rightAnchor, leftConstant: 16, bottomConstant: self.tableView.kTableHeaderCutAway, rightConstant: 16)
        _ = titleLbl.centerConstraintWith(centerX: self.tableView.centerXAnchor)
        
        _ = profileImage.anchor(left: self.tableView.leftAnchor, bottom: self.headerView.bottomAnchor, leftConstant: 16, widthConstant: 30, heightConstant: 30)
        _ = profileLbl.anchor(left: self.profileImage.rightAnchor, leftConstant: 8)
        _ = profileLbl.centerConstraintWith(centerY: self.profileImage.centerYAnchor)
        _ = followBtn.anchor(top: profileLbl.bottomAnchor, left: self.profileImage.rightAnchor, topConstant: 4, leftConstant: 8, widthConstant: 50)
        
        _ = startBtn.anchor(left: self.bottomView.leftAnchor, right: self.bottomView.rightAnchor, leftConstant: 32, rightConstant: 32)
        _ = startBtn.centerConstraintWith(centerX: self.bottomView.centerXAnchor, centerY: self.bottomView.centerYAnchor)
        
    }
    
    private func getTableView() -> RFParallaxTableView {
        let tableView = RFParallaxTableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none
        tableView.allowsMultipleSelection = true
        
        return tableView
    }
    
}

extension RFViewRecipeVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = RFViewRecipeSection(rawValue: indexPath.row)
        switch section! {
            case .header:
                return createHeaderCell()
            case .description:
                return createDescriptionCell()
            case .comment:
                return createCommentsCell()
            case .ingredients:
                return createIngredientsCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = RFViewRecipeSection(rawValue: indexPath.row)
        switch section! {
            case .header:
                return self.tableView.kTableHeaderCutAway
            case .description:
                return getDescriptionHeight()
            case .comment:
                return 80
            case .ingredients:
                return getIngredientContentHeight()
        }
    }
  
    
    func getDescriptionHeight() -> CGFloat {
        if let desc = self.getRecipe().desc {
            return desc.height(withConstrainedWidth: self.view.frame.width - 32, font: RFFont.instance.bodyMedium12!)
        }
        return 10
    }

    func getIngredientContentHeight() -> CGFloat{
        let padding: CGFloat = 64 + 32
        
        if let ingredients = self.getRecipe().getRecipesDescription() {
            let attrs = self.view.addAttributedString(text: ingredients.joined(separator: "\n"), lineSpacing: 5, font: RFFont.instance.bodyMedium12!)
            let cellHeight = attrs.height(withConstrainedWidth: self.view.frame.width - 32)
            
            return cellHeight + padding
        }
        
        return 32
       
    }
    
    private func createHeaderCell() -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! UITableViewCell
        cell.selectionStyle = .none
        if let url = self.viewModel?.recipe?.recipePathToImg {
         headerView.loadImage(urlString: url )
        }
        
        self.titleLbl.text = self.getRecipe().title
        self.profileLbl.text = self.getRecipe().creator
        return cell
    }
    
    private func createDescriptionCell() -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "createDescriptionCell") as! DescriptionCell
        cell.descriptionLbl.text = self.getRecipe().desc
        return cell
    }
    
    private func createCommentsCell() -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "createReviewCell") as! ReviewCell
        return cell
    }
    
    private func createIngredientsCell() -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "createIngredientsCell") as! IngredientsCell
        cell.bindData(self.getRecipe())
        cell.configureViews(self.getRecipe().getRecipesDescription()!)
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.tableView.updateHeaderView()
        
        var offset = ((scrollView.contentOffset.y + self.tableView.kTableHeaderHeight) / 185)
        print(offset)
        let color = UIColor(red: 1, green: 1, blue: 1, alpha: offset)
        if offset > 1 {
            offset = 1
            self.navigationController?.navigationBar.backgroundColor = color
            self.navigationController?.navigationBar.tintColor = UIColor(hue: 1, saturation: offset, brightness: 1, alpha: 1)
    
            UIApplication.shared.statusBarView?.backgroundColor = color
        }else{
            
            self.navigationController?.navigationBar.backgroundColor = color
            self.navigationController?.navigationBar.tintColor = UIColor(hue: 1, saturation: offset, brightness: 1, alpha: 1)
            UIApplication.shared.statusBarView?.backgroundColor = color
        }
        
        
    }
    
}
