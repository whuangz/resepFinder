//
//  AddIngredientCell.swift
//  ResepFinder
//
//  Created by William Huang on 26/11/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class AddIngredientCell: RFBaseTableCell {

    var ingredientField: UITextField!
    var deleteBtn: RFPrimaryBtn!
    private var viewModel: AddIngredientVM?
    var delegate: AddIngredientProtocol?
    var cellAtIndex: Int?
    
    override func setupViews() {
        super.setupViews()
        prepareUI()
        observeData()
    }
    
    fileprivate func observeData(){
        //        guard let viewModel = self.viewModel else {return}
        
        self.ingredientField.rx.controlEvent([.editingDidEnd])
            .asObservable()
            .subscribe(onNext: { (text) in
                self.delegate?.setDetailsView(data: [self.cellAtIndex! : self.ingredientField.text!])
            })
            .disposed(by: self.dispose)
        
    }
    
}

//MARK: - Initialize & Prepare UI
extension AddIngredientCell {

    fileprivate func prepareUI(){
        
        self.ingredientField = getTextField()
        self.deleteBtn = getBtn()
        self.deleteBtn.isHidden = true
        self.viewModel = AddIngredientVM()
        
        layoutViews()
    }
    
    fileprivate func layoutViews(){
        
        addSubview(ingredientField)
        addSubview(deleteBtn)
        
        _ = self.ingredientField.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, leftConstant: 16, bottomConstant: 8, heightConstant: 30)
        _ = self.deleteBtn.anchor(left: self.ingredientField.rightAnchor, right: rightAnchor, leftConstant: 8, rightConstant: 0, widthConstant: 60)
        _ = self.deleteBtn.centerConstraintWith(centerY: self.ingredientField.centerYAnchor)
    }
    
    fileprivate func getTextField() -> UITextField {
        let textField = UITextField()
        textField.placeholder = "Input Ingredients"
        textField.borderStyle = .none
        textField.font = RFFont.instance.bodyMedium14
        textField.addLineToBottomView(color: RFColor.instance.primGray, width: 0.5)
        textField.autocorrectionType = .no
        return textField
    }
    
    fileprivate func getBtn() -> RFPrimaryBtn{
        let button = RFPrimaryBtn()
        
        button.setContentImageFor(active: "remove", inactive: "remove")
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 16, 0, 16)
        return button
    }
    
}

protocol AddIngredientProtocol {
    func setDetailsView(data: [Int:String])
}

