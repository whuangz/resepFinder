//
//  RFSearchCell.swift
//  ResepFinder
//
//  Created by William Huang on 17/12/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import UIKit

class RFSearchCell: UITableViewCell {

    @IBOutlet weak var recipeName: UILabel!

    var recipeTitle: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func bindData(data: RFRecipe){
        self.recipeTitle = data.title
        self.recipeName.text = data.title
    }
    
}
