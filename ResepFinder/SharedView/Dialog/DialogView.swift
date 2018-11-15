//
//  RFDialog.swift
//  ResepFinder
//
//  Created by William Huang on 14/11/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class DialogView: UIView {
    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var contentLbl: UILabel!
    @IBOutlet weak var leftBtn: UIButton!
    @IBOutlet weak var rightBtn: UIButton!
    @IBOutlet weak var dialogBg: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    fileprivate func setupView(){
        self.backgroundColor =  UIColor(white: 0, alpha: 0.5)
        self.dialogBg.layer.cornerRadius = 10
        self.dialogBg.clipsToBounds = true
    }
    
    func setLeftBtnWith(title: String, color: UIColor){
        self.leftBtn.setTitle(title, for: .normal)
        self.leftBtn.setTitleColor(color, for: .normal)
    }
    
    func setRightBtnWith(title: String, color: UIColor){
        self.rightBtn.setTitle(title, for: .normal)
        self.rightBtn.setTitleColor(color, for: .normal)
    }
    
    func leftBtnObserver()-> ControlEvent<()> {
        return self.leftBtn.rx.controlEvent(UIControlEvents.touchUpInside).asControlEvent()
    }
    
    func rightBtnObserver()-> ControlEvent<()> {
        return self.rightBtn.rx.controlEvent(UIControlEvents.touchUpInside).asControlEvent()
    }
}
