//
//  HomeHeaderView.swift
//  ResepFinder
//
//  Created by William Huang on 21/11/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import UIKit

class HomeHeaderView: UICollectionReusableView {

    @IBOutlet weak var rfLogo: UIImageView!
    @IBOutlet weak var searchBar: SearchBar!
    @IBOutlet weak var cameraBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prepareUI()
    }
    
}

//MARK: - Initialize & Prepare UI
extension HomeHeaderView {
    func prepareUI(){
        configureViews()
    }
    
    private func configureViews(){
        self.rfLogo.image = UIImage(named: "logo")
        self.rfLogo.contentMode = .scaleAspectFit
        //self.locationBtn.setImage(UIImage(named: "location")?.withRenderingMode(.alwaysOriginal), for: .normal)
        self.cameraBtn.setImage(UIImage(named: "camera_icon_snap")?.withRenderingMode(.alwaysOriginal), for: .normal)
        self.searchBar.placeholder = "Find Recipes..."
        self.searchBar.isUserInteractionEnabled = false
        
        //custom font
    }
    
}
