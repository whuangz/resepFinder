//
//  CreateReviewsCell.swift
//  ResepFinder
//
//  Created by William Huang on 26/11/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import Foundation
import HCSStarRatingView
import RxSwift
import RxCocoa

class CreateReviewsCell: RFBaseCollectionCell {
    
    fileprivate var imgView: CachedImageView!
    fileprivate var subHeader: UILabel!
    fileprivate var ratingStar: HCSStarRatingView!
    fileprivate var commentTxt: UITextView!
    var reviewBtn: RFPrimaryBtn!
    private var viewModel = CreateRecipeVM()
    private let disposeBag = DisposeBag()
    var delegate: ReviewRecipeProtocol?
    
    private var keyboardBottomSpaceConstraint: NSLayoutConstraint?
    
    override func setUpViews() {
        super.setUpViews()
        prepareUI()
        observeKeyboard()
    }
    
    func bindData(data: String){
        self.imgView.loadImage(urlString: data)
    }
    
    fileprivate func observeKeyboard() {
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillAppear(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillDisappear(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillAppear(_ notification: Notification){
        if let info = notification.userInfo {
            if let value: NSValue = info[UIKeyboardFrameEndUserInfoKey] as? NSValue {
                let rawFrame = value.cgRectValue
                let keyboardFrame = self.convert(rawFrame, to: nil);
                self.keyboardBottomSpaceConstraint?.constant = -(keyboardFrame.size.height)
                UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
                    self.layoutIfNeeded()
                }) { (completed) in
                    
                }
            }
        }
    }
    
    @objc func keyboardWillDisappear(_ notification: Notification){
        self.keyboardBottomSpaceConstraint?.constant = 0
        self.layoutIfNeeded()
    }
}


//MARK: - Initialize & Prepare UI
extension CreateReviewsCell {
    
    fileprivate func prepareUI(){
        self.backgroundColor = .white
        self.ratingStar = getRatingStar()
        self.imgView = getImageView()
        self.commentTxt = getTextView()
        self.subHeader = getSubHeader()
        self.reviewBtn = getNoBtn()
        
        configureViews()
        layoutViews()
    }
    
    fileprivate func configureViews(){
        self.imgView.image = UIImage(named: "recipe1")
        self.subHeader.text = "Does it look good as it tastes?\nGive your thought about it!"
    
        self.commentTxt.rx.text.orEmpty.bind(to: viewModel.comment).disposed(by: disposeBag)

        let validation = viewModel.validateReviewed()
        validation.bind(onNext: { (valid) in
            if valid {
                self.reviewBtn.makeEnabled()
            }else{
                self.reviewBtn.makeDisabled()
            }
        }).disposed(by: disposeBag)
        
        self.reviewBtn.rx.tap.do(onNext: { [unowned self] in
            self.commentTxt.endEditing(true)
        }).subscribe { [unowned self](_) in
            let data = RFReview(comment: self.viewModel.comment.value, rating: NSNumber(value: Float(self.ratingStar.value)))
            self.delegate?.didSendReview(data)
        }.disposed(by: disposeBag)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        self.addGestureRecognizer(tap)
    }
    
    @objc func dismissView(){
        self.endEditing(true)
    }
    
    fileprivate func layoutViews(){
        
        addSubview(imgView)
        addSubview(subHeader)
        addSubview(reviewBtn)
        addSubview(ratingStar)
        addSubview(commentTxt)
        
        _ = self.imgView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, rightConstant: 0, heightConstant: 300)
        _ = self.subHeader.anchor(top: self.imgView.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor, topConstant: 16, leftConstant: 8, rightConstant: 8)
        _ = self.ratingStar.anchor(top: self.subHeader.bottomAnchor, topConstant: 8, widthConstant: 160, heightConstant: 50)
        _ = self.ratingStar.centerConstraintWith(centerX: self.subHeader.centerXAnchor)
        _ = self.commentTxt.anchor(top: self.ratingStar.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor, topConstant: 8, leftConstant: 16, rightConstant: 16, heightConstant: 150)
        _ = self.reviewBtn.anchor(top: self.commentTxt.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor, topConstant: 24, leftConstant: 24, rightConstant: 24, heightConstant: 40)
        
        
        if RFScreenHelper.isLessThanIPhone6() {
            self.imgView.heightAnchor.constraint(equalToConstant: 200).isActive = true
            self.commentTxt.heightAnchor.constraint(equalToConstant: 85).isActive = true
        }
        
        keyboardBottomSpaceConstraint = NSLayoutConstraint.init(item: self.imgView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        self.addConstraint(keyboardBottomSpaceConstraint!)
        
        
    }
    
    fileprivate func getTextView() -> UITextView {
        let textView = UITextView()
        textView.layer.cornerRadius = 10
        textView.layer.borderWidth = 2
        textView.layer.borderColor = RFColor.instance.gray3.cgColor
        textView.autocorrectionType = .no
        textView.font = RFFont.instance.bodyMedium14
        return textView
    }
    
    fileprivate func getRatingStar() -> HCSStarRatingView {
        let rating = HCSStarRatingView()
        rating.maximumValue = 5
        rating.minimumValue = 0
        rating.value = 0
        rating.emptyStarImage = UIImage(named: "empty_star")
        rating.filledStarImage = UIImage(named: "full_star")
        return rating
    }
    
    fileprivate func getImageView() -> CachedImageView {
        let imageView = CachedImageView()
        imageView.layer.cornerRadius = 5
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }
    
    fileprivate func getSubHeader() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.sizeToFit()
        label.font = RFFont.instance.subHead16
        label.textAlignment = .center
        return label
    }
    
    fileprivate func getNoBtn() -> RFPrimaryBtn {
        let button = RFPrimaryBtn()
        button.setTitle("Write a review!", for: .normal)
        button.setTitleColor(RFColor.instance.black, for: .normal)
        button.titleLabel?.font = RFFont.instance.subHead16
        button.backgroundColor = RFColor.instance.darkGreen1
        button.setTitleColor(UIColor.white, for: .normal)
        button.setCornerWith(radius: 5)
        return button
    }
    
    
}

protocol ReviewRecipeProtocol {
    func didSendReview(_ data: RFReview)
}
