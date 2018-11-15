//
//  RFDialog.swift
//  ResepFinder
//
//  Created by William Huang on 15/11/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import Foundation
import RxSwift

class RFDialogView {
    static let instance = RFDialogView()
    private let disposeBag = DisposeBag()
    
    private let dialogView: DialogView!
    private var completion: VoidCompletion!
    
    init() {
        self.dialogView = Bundle.main.loadNibNamed("DialogView", owner: nil, options: nil)?.first as! DialogView
        self.dialogView.frame = UIScreen.main.bounds
        
        self.dialogView.leftBtnObserver().subscribe { (_) in
            self.dialogView.removeFromSuperview()
        }.disposed(by: disposeBag)
        
        self.dialogView.rightBtnObserver().subscribe { (_) in
            if self.completion != nil {
                self.completion()
            }
            self.dialogView.removeFromSuperview()
        }.disposed(by: disposeBag)
        
    }
    
    func showDialogWith(title: String , content: String, leftBtn: String, rightBtn: String, completion: @escaping VoidCompletion){
        self.dialogView.alpha = 0
        self.dialogView.headerLbl.text = title
        self.dialogView.contentLbl.text = content
        self.dialogView.setLeftBtnWith(title: leftBtn, color: RFColor.instance.primGray)
        self.dialogView.setRightBtnWith(title: rightBtn, color: RFColor.instance.darkGreen)
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
            self.dialogView.alpha = 1
            UIApplication.shared.keyWindow?.addSubview(self.dialogView)
        }, completion:  { (valid) in
            if valid {
                self.completion = completion
            }
        })
    }
  
}
