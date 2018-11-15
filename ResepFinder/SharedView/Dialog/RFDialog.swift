//
//  RFDialog.swift
//  ResepFinder
//
//  Created by William Huang on 15/11/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import Foundation

class RFDialogView {
    static let instance = RFDialogView()
    private let dialogView: DialogView!
    
    init() {
        self.dialogView = Bundle.main.loadNibNamed("DialogView", owner: nil, options: nil)?.first as! DialogView
        self.dialogView.frame = UIScreen.main.bounds
    }
    
    func showDialogWith(title: String , content: String, leftBtn: String, rightBtn: String){
        self.dialogView.alpha = 0
        self.dialogView.headerLbl.text = title
        self.dialogView.contentLbl.text = content
        self.dialogView.setLeftBtnWith(title: leftBtn, color: RFColor.instance.primGray)
        self.dialogView.setRightBtnWith(title: rightBtn, color: RFColor.instance.darkGreen)
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
            self.dialogView.alpha = 1
            UIApplication.shared.keyWindow?.addSubview(self.dialogView)
        }, completion: nil)
    }
}
