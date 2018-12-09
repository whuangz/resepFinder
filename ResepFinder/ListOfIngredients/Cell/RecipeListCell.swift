//
//  RecipeListCell.swift
//  ResepFinder
//
//  Created by William Huang on 09/12/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import UIKit

class RecipeListCell: RFBaseTableCell {

    fileprivate var recipeImg: CachedImageView!
    fileprivate var recipeName: UILabel!
    fileprivate var numberOfIngredietns: UILabel!
    
    override func setupViews() {
        super.setupViews()
        prepareUI()
    }
    
    func bindModel(_ model: AnyObject) {
        if let recipe = model as? RFRecipe {
            if let path = recipe.recipePathToImg {
                self.recipeImg.loadImage(urlString: path)
            }
            self.recipeName.text = recipe.title
            self.numberOfIngredietns.text = "Total Ingredients: \(recipe.ingredients?.count ?? 0)"
        }
    }

}

extension RecipeListCell {
    
    fileprivate func prepareUI(){
        self.recipeImg = getImageView()
        self.recipeName = getTitle()
        self.numberOfIngredietns = getLabel()
        
        layoutViews()
    }
    
    fileprivate func layoutViews(){
        addSubview(recipeImg)
        addSubview(recipeName)
        addSubview(numberOfIngredietns)
        
        _ = recipeImg.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, topConstant: 8, leftConstant: 8, bottomConstant: 8 ,widthConstant: 60, heightConstant: 60)
        _ = recipeName.anchor(left: self.recipeImg.rightAnchor, leftConstant: 8)
        _ = recipeName.centerConstraintWith(centerY: self.recipeImg.centerYAnchor, yConstant: -16)
        _ = numberOfIngredietns.anchor(top: self.recipeName.bottomAnchor ,left: self.recipeName.leftAnchor, topConstant: 8)
        
    }
    
    fileprivate func getImageView() -> CachedImageView {
        let imageView = CachedImageView()
        imageView.backgroundColor = .red
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }
    
    fileprivate func getTitle() -> UILabel {
        let label = UILabel()
        label.text = "Recipe"
        label.font = RFFont.instance.subHead14
        return label
    }
    
    fileprivate func getLabel() -> UILabel {
        let label = UILabel()
        label.text = "10"
        label.font = RFFont.instance.bodyMedium12
        return label
    }

    
}
