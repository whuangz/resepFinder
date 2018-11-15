//
//  RFDialog.swift
//  ResepFinder
//
//  Created by William Huang on 14/11/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import Foundation

class Dialog: UIView {
    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var contentLbl: UILabel!
    @IBOutlet weak var leftBtn: UIButton!
    @IBOutlet weak var rightBtn: UIButton!
    @IBOutlet weak var dialogBg: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.dialogBg.backgroundColor =  UIColor(white: 0.5, alpha: 0.5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showDialogWith(title: String , content: String, leftBtn: String, rightBtn: String){
        self.headerLbl.text = title
        self.contentLbl.text = content
        self.leftBtn.setTitle(leftBtn, for: .normal)
        self.rightBtn.setTitle(leftBtn, for: .normal)
    }
    
}
