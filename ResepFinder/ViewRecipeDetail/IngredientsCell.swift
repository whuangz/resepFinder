//
//  IngredientsCell.swift
//  ResepFinder
//
//  Created by William Huang on 25/11/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import Foundation

class IngredientsCell: RFBaseTableCell {
    
    fileprivate var topView: UIView!
    fileprivate var ingredientHeader: UILabel!
    fileprivate var ingredientContent: UITextView!
    fileprivate var addToShoppingList: RFPrimaryBtn!
    
    var arrayOfDummbyText = [
        "2 sweet potatoes",
        "1 cup creamy peanut butter",
        "10 oz marshmallows",
        "1 tbsp unsalated butter",
        "1 tbsp maple syrup",
        "2 sweet potatoes",
        "1 cup creamy peanut butter",
        "10 oz marshmallows",
        "1 tbsp unsalated butter",
        "1 tbsp maple syrup",
    ]
    
    override func setupViews() {
        super.setupViews()
        prepareUI()
    }
    
}


//MARK: - Initialize & Prepare UI
extension IngredientsCell {
    
    
    fileprivate func prepareUI(){
        self.topView = self.getView()
        self.ingredientHeader = self.getHeaderLbl()
        self.ingredientContent = self.getTextView()
        self.addToShoppingList = self.getBtn()
        
        configureViews()
        layoutViews()
    }
    
    fileprivate func configureViews(){
        
        ingredientContent.attributedText = addAttributedString(text: arrayOfDummbyText.joined(separator: "\n"), lineSpacing: 5, font: RFFont.instance.bodyMedium12!)
        
    }
    
    fileprivate func layoutViews(){
        
        addSubview(topView)
        topView.addSubview(ingredientHeader)
        topView.addSubview(ingredientContent)
        topView.addSubview(addToShoppingList)
        
        _ = self.topView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        _ = self.ingredientHeader.anchor(top: topView.topAnchor, left: topView.leftAnchor, right: topView.rightAnchor, topConstant: 16, leftConstant: 16)
        _ = self.ingredientContent.anchor(top: ingredientHeader.bottomAnchor, left: topView.leftAnchor, bottom: topView.bottomAnchor, right: topView.rightAnchor, topConstant: 16, leftConstant: 16, rightConstant: 16)
        _ = self.addToShoppingList.anchor(left: ingredientHeader.rightAnchor, right: topView.rightAnchor, leftConstant: 8, rightConstant: 16, widthConstant: 130)
        _ = self.addToShoppingList.centerConstraintWith(centerY: ingredientHeader.centerYAnchor)
    }
    
    fileprivate func getView() -> UIView {
        let view = UIView()
        view.layer.masksToBounds = true
        return view
    }
    
    fileprivate func getHeaderLbl() -> UILabel {
        let label = UILabel()
        label.font = RFFont.instance.subHead14
        label.text = "Ingredients"
        return label
    }
    
    fileprivate func getTextView() -> UITextView {
        let textView = UITextView()
        textView.isEditable = false
        textView.isSelectable = false
        return textView
    }
    
    fileprivate func getBtn() -> RFPrimaryBtn {
        let button = RFPrimaryBtn()
        button.setTitle("Add to Shopping List", for: .normal)
        button.setTitleColor(RFColor.instance.black, for: .normal)
        button.backgroundColor = UIColor.init(white: 0.9, alpha: 0.8)
        button.titleLabel?.font = RFFont.instance.bodyMedium10
        button.setCornerWith(radius: 5)
        return button
    }
    
}
