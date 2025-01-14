//
//  RecipeDetailCell.swift
//  ResepFinder
//
//  Created by William Huang on 26/11/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class RecipeDetailCell: RFBaseTableCell {
    
    fileprivate var titleTextField: UITextField!
    fileprivate var titleDescriptionField: UITextField!
    fileprivate var difficultyField: UITextField!
    var viewModel: RecipeDetailVM?
    
    override func setupViews() {
        super.setupViews()
        prepareUI()
        
    }
    
    func setupViewModel(vm: RecipeDetailVM){
        self.viewModel = vm
        observeData(self.viewModel!)
    }
    
    fileprivate func observeData(_ viewModel: RecipeDetailVM){
//        self.titleTextField.rx.controlEvent([.editingDidEnd])
//            .asObservable()
//            .subscribe(onNext: { (text) in
//                title = self.titleTextField.text!
//            })
//            .disposed(by: self.dispose)
//
//        self.titleDescriptionField.rx.controlEvent([.editingDidEnd])
//            .asObservable()
//            .subscribe(onNext: { (text) in
//                desc = self.titleDescriptionField.text!
//            })
//            .disposed(by: self.dispose)
//
//        self.difficultyField.rx.controlEvent([.editingDidEnd])
//            .asObservable()
//            .subscribe(onNext: { (text) in
//                difficulty = self.difficultyField.text!
//            })
//            .disposed(by: self.dispose)
//
//
        self.titleTextField.rx.text.orEmpty.bind(to: viewModel.title).disposed(by: self.dispose)
        self.titleDescriptionField.rx.text.orEmpty.bind(to: viewModel.desc).disposed(by: self.dispose)
        self.difficultyField.rx.text.orEmpty.bind(to: viewModel.difficulty).disposed(by: self.dispose)
        
        
    }
    
}


//MARK: - Initialize & Prepare UI
extension RecipeDetailCell {
    
    
    fileprivate func prepareUI(){
        self.titleTextField = getTitleField()
        self.titleDescriptionField = getDescriptionField()
        self.difficultyField = getDifficultyField()
        
        configureViews()
        layoutViews()
    }
    
    fileprivate func configureViews(){
        
    }
    
    fileprivate func layoutViews(){
        
        addSubview(titleTextField)
        addSubview(titleDescriptionField)
        addSubview(difficultyField)
        
        _ = self.titleTextField.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, topConstant: 16, leftConstant: 16, rightConstant: 16, heightConstant: 30)
        _ = self.titleDescriptionField.anchor(top: titleTextField.bottomAnchor, left: titleTextField.leftAnchor, right: titleTextField.rightAnchor, topConstant: 8, heightConstant: 30)
        _ = self.difficultyField.anchor(top: titleDescriptionField.bottomAnchor, left: titleDescriptionField.leftAnchor, right: titleDescriptionField.rightAnchor, topConstant: 8, heightConstant: 30)
    }
    
    fileprivate func getTitleField() -> UITextField {
        let textField = UITextField()
        textField.placeholder = "Recipe Title"
        textField.borderStyle = .none
        textField.font = RFFont.instance.subHead16
        textField.autocorrectionType = .no
        
        return textField
    }
    
    fileprivate func getDifficultyField() -> UITextField {
        let textField = UITextField()
        textField.placeholder = "Difficulty Level (Easy, Medium, Hard)"
        textField.borderStyle = .none
        textField.font = RFFont.instance.bodyMedium14
        textField.autocorrectionType = .no
        
        return textField
    }
    
    fileprivate func getDescriptionField() -> UITextField{
        let textField = UITextField()
        textField.placeholder = "Recipe Description"
        textField.borderStyle = .none
        textField.font = RFFont.instance.bodyMedium14
        textField.autocorrectionType = .no
        
        return textField
    }
    
}
