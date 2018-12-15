//
//  RFLocationCell.swift
//  ResepFinder
//
//  Created by William Huang on 14/12/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import UIKit

class RFLocationCell: RFBaseTableCell {

    @IBOutlet weak var locationName: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    override func setupViews(){
        super.setupViews()
        configureView()
    }
    
    func bindData(_ data: RFLocation){
        self.locationName.text = data.name
    }
    
    func configureView(){
        self.locationName.font = RFFont.instance.subHead14
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        let image = selected ? UIImage(named: "check") : UIImage(named: "uncheck")
        self.checkButton.setImage(image, for: .normal)
    }
    
}
