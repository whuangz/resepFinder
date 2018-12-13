//
//  HomeCollectionCell.swift
//  ResepFinder
//
//  Created by William Huang on 22/11/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import FirebaseAuth

protocol NavigationControllerDelegate {
    func navigateController(_ vc: UIViewController) -> UINavigationController
}

class HomeCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var topView: UIView!
    private var profileView: RFImageView!
    private var nameLbl: UILabel!
    private var followBtn: RFPrimaryBtn!
    
    @IBOutlet weak var middleView: UIView!
    private var imageView: RFImageView!
    private var timeView: UIView!
    private var timeIcon: UIImageView!
    private var timeLbl: UILabel!
    
    private var descriptionLbl: UILabel!
    private var difficultyLbl: UILabel!
    private var difficulty: UILabel!
    
    private var iconStackView: UIStackView!
    private var starBtn: RFPrimaryBtn!
    private var loveBtn: RFPrimaryBtn!
    
    private var disposeBag = DisposeBag()
    var delegate: NavigationControllerDelegate?
    private var recipe: RFRecipe?
    private var service = RFRecipeService()
    
    override func awakeFromNib() {
        prepareUI()
        addGesture()
    }
    
    private func addGesture(){
        middleView.rx.tapGesture().when(.recognized).subscribe(onNext: { (_) in
            self.navigateToViewRecipe()
        }).disposed(by: self.disposeBag)
    }
    
    private func navigateToViewRecipe(){
        guard let recipe = self.recipe else {return}
        let viewRecipeVM = RFViewRecipeVM(data: recipe)
        let viewRecipe = RFViewRecipeVC(vm: viewRecipeVM)
        viewRecipe.hidesBottomBarWhenPushed = true
        navigateTo(viewRecipe)
    }
    
    private func navigateTo(_ vc: UIViewController) {
        guard let delegate = self.delegate else {return}
        guard let navigationController = delegate.navigateController(vc) as? UINavigationController else {return}
        navigationController.pushViewController(vc, animated: true)
    }

    func bindData(data: RFRecipe){
        self.recipe = data
        
        self.nameLbl.text = data.creator
        guard let img = data.recipePathToImg else {return}

        self.imageView.loadImage(urlString: img)
        self.timeLbl.text = data.time
        self.descriptionLbl.text = data.desc
        self.difficulty.text = data.difficulty
        
        if let recipe = self.recipe {
            self.service.checkLovedRecipe(recipeID: ((recipe.id)!)) { (selected) in
                self.loveBtn.selected(selected)
            }
            if let userID = Auth.auth().currentUser?.uid{
                if recipe.uid == userID{
                    self.followBtn.isHidden = true
                }else{
                    self.followBtn.isHidden = false
                    self.service.checkFollowRelation(userID: (recipe.uid)!) { (selected) in
                        if selected {
                            self.followBtn.setTitle("Unfollow", for: .normal)
                        }else{
                            self.followBtn.setTitle("Follow", for: .normal)
                        }
                    }
                }
            }
           
        }
    }
}


//MARK: - Intialize & Prepare UI
extension HomeCollectionCell {
    
    fileprivate func prepareUI(){
        self.profileView = getUserProfileImageView()
        self.nameLbl = getLbl()
        self.followBtn = getPrimaryBtn()
        
        self.timeView = getView()
        self.timeIcon = getImageView()
        self.timeLbl = getTimeLbl()
        self.imageView = getImageView()
        
        self.descriptionLbl = getDescriptionLbl()
        self.difficultyLbl = getLbl()
        self.difficulty = getLbl()
        
        self.iconStackView = getStacView()
        self.starBtn = getIconBtn()
        self.loveBtn = getIconBtn()
        
        configureViews()
        layoutViews()
    }
    
    fileprivate func configureViews(){
        
        self.timeLbl.text = " 5 Mins "
        self.imageView.image = UIImage(named: "recipe1")
        self.timeIcon.image = UIImage(named: "timer")
        
        self.descriptionLbl.text = "Fluffy sweet potatoes mixed with butter, sugar, and vanilla, and baked with a crunchy pecan streusel topping. This recipe was given to me by my brother-in-law."
        self.difficultyLbl.text = "Difficulty:"
        self.difficulty.text = "Easy"
        
        self.starBtn.setImage(UIImage(named: "favorited"), for: .normal)
        self.loveBtn.setContentImageFor(active: "like", inactive: "unlike")
 
        self.setupLoveBtn()
        self.setupFollowBtn()
        
        // custom font
        self.nameLbl.font = RFFont.instance.subHead14
        self.difficultyLbl.font = RFFont.instance.subHead14
    }
    
    fileprivate func setupLoveBtn(){
        self.loveBtn.rx.tap.subscribe(onNext: {
            self.service.checkLovedRecipe(recipeID: ((self.recipe?.id)!)) { (selected) in
                if selected {
                    self.service.removeLove(recipeID: (self.recipe?.id)!)
                }else{
                    self.service.addRecipeToLoved(recipeID: (self.recipe?.id)!)
                }
                
            }
            
        }).disposed(by: self.disposeBag)
    }
    
    fileprivate func setupFollowBtn(){
        self.followBtn.rx.tap.subscribe(onNext: {
            let recipeUID = (self.recipe?.uid)!
            self.followBtn.animateTouch(duration: 0.2)
            self.service.checkFollowRelation(userID: (recipeUID)) { (selected) in
                if selected {
                    self.followBtn.setTitle("Follow", for: .normal)
                    self.service.removeFollowing(userID: (recipeUID))
                }else{
                    self.followBtn.setTitle("Unfollow", for: .normal)
                    self.service.addFollowing(userID: (recipeUID))
                }
            }
        }).disposed(by: self.disposeBag)
    }
    
    fileprivate func layoutViews(){
        self.topView.addSubview(profileView)
        self.topView.addSubview(nameLbl)
        self.topView.addSubview(followBtn)
        
        self.middleView.addSubview(imageView)
        self.imageView.addSubview(timeView)
        timeView.addSubview(timeIcon)
        timeView.addSubview(timeLbl)
        
        self.middleView.addSubview(descriptionLbl)
        self.middleView.addSubview(difficultyLbl)
        self.middleView.addSubview(difficulty)
        self.middleView.addSubview(descriptionLbl)
        self.middleView.addSubview(iconStackView)
        //self.iconStackView.addArrangedSubview(self.starBtn)
        self.iconStackView.addArrangedSubview(self.loveBtn)
        
        //top view constraint
        _ = profileView.anchor(top: self.topView.topAnchor, left: self.topView.leftAnchor, bottom: self.topView.bottomAnchor, topConstant: 8, leftConstant: 16, bottomConstant: 8, widthConstant: 30, heightConstant: 30)
        _ = nameLbl.centerConstraintWith(centerY: self.profileView.centerYAnchor)
        _ = nameLbl.anchor(left: self.profileView.rightAnchor, leftConstant: 8)
        _ = followBtn.centerConstraintWith(centerY: self.nameLbl.centerYAnchor)
        _ = followBtn.anchor(left: self.nameLbl.rightAnchor, right: self.topView.rightAnchor, leftConstant: 8, rightConstant: 16, widthConstant: 60)
        
        //middle view constraint
        _ = imageView.anchor(top: self.middleView.topAnchor, left: self.middleView.leftAnchor, right: self.middleView.rightAnchor, topConstant: 0, leftConstant: 0, rightConstant: 0, heightConstant: 200)
        _ = self.timeView.anchor(bottom: imageView.bottomAnchor, right: imageView.rightAnchor, bottomConstant: 8, rightConstant: 8, eqWidth: self.timeLbl.widthAnchor, eqHeight: self.timeLbl.heightAnchor, widthMultiplier: 1.5)
        _ = self.timeLbl.anchor(bottom: timeView.bottomAnchor, right: timeView.rightAnchor, rightConstant: 4)
        _ = self.timeIcon.anchor(left: timeView.leftAnchor, right: timeLbl.leftAnchor, leftConstant: 4, rightConstant: 4)
        _ = self.timeIcon.centerConstraintWith(centerY: self.timeLbl.centerYAnchor)
        
        //bottom view constraint
        _ = descriptionLbl.anchor(top: self.imageView.bottomAnchor, left: self.imageView.leftAnchor, right: self.imageView.rightAnchor, topConstant: 8, leftConstant: 16, rightConstant: 16)    
        _ = difficultyLbl.anchor(top: self.descriptionLbl.bottomAnchor, left: descriptionLbl.leftAnchor, topConstant: 16, leftConstant: 0)
            difficultyLbl.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .horizontal)
        _ = difficulty.anchor(left: difficultyLbl.rightAnchor, leftConstant: 8)
        _ = difficulty.centerConstraintWith(centerY: difficultyLbl.centerYAnchor)
        _ = iconStackView.anchor(left: difficulty.rightAnchor, right: descriptionLbl.rightAnchor, leftConstant: 8)
        _ = iconStackView.centerConstraintWith(centerY: difficultyLbl.centerYAnchor)
        
        
        //_ = starBtn.anchor(widthConstant: 30, heightConstant: 30)
        _ = loveBtn.anchor(widthConstant: 30, heightConstant: 30)
        
    }
    
    fileprivate func getUserProfileImageView() -> RFImageView {
        let imageView = RFImageView()
        imageView.backgroundColor = .red
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }
    
    fileprivate func getImageView() -> RFImageView {
        let imageView = RFImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }
    
    fileprivate func getPrimaryBtn() -> RFPrimaryBtn {
        let button = RFPrimaryBtn()
        button.isHidden = true
        button.setTitleColor(RFColor.instance.black, for: .normal)
        button.backgroundColor = UIColor.init(white: 0.9, alpha: 0.8)
        button.titleLabel?.font = RFFont.instance.bodyMedium12
        button.titleEdgeInsets = UIEdgeInsets(top: -8, left: -8, bottom: -8, right: -8)
        button.setCornerWith(radius: 5)
        return button
    }
    
    fileprivate func getIconBtn() -> RFPrimaryBtn {
        let button = RFPrimaryBtn()
        return button
    }
    
    fileprivate func getLbl() -> UILabel {
        let label = UILabel()
        label.text = "Username100"
        label.font =  RFFont.instance.bodyMedium12
        return label
    }
    
    fileprivate func getTimeLbl() -> UILabel {
        let label = UILabel()
        label.text = " 5 Mins "
        label.font = RFFont.instance.subHead12
        label.backgroundColor = UIColor(white: 0.9, alpha: 0.5)
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        return label
    }
    
    fileprivate func getDescriptionLbl() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.font =  RFFont.instance.bodyMedium12
        return label
    }
    
    fileprivate func getStacView() -> UIStackView {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.axis = .horizontal
        return stackView
    }
    
    fileprivate func getView() -> UIView {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor(white: 0.9, alpha: 0.5)
        return view
    }
    
}
