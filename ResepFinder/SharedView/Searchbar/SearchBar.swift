//
//  SearchBar.swift
//  ResepFinder
//
//  Created by William Huang on 19/11/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import UIKit

class SearchBar: UISearchBar {

    var textFieldInsideSearchBar: UITextField!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView(){
        self.isTranslucent = false
        self.barTintColor = .white
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 1
        self.searchBarStyle = .minimal
        self.setImage(UIImage(named: "searchbutton"), for: .search, state: .normal)
        self.sizeToFit()
        textFieldInsideSearchBar = self.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar.font = RFFont.instance.bodyMedium12
        textFieldInsideSearchBar.tintColor = .blue
        
    }
    
}
