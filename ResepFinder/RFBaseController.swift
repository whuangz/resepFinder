//
//  RFBaseController.swift
//  ResepFinder
//
//  Created by William Huang on 09/11/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class RFBaseController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    private func bind(textfield: UITextField, to variable: Variable<String>){
        variable.asObservable().bind(to: textfield.rx.text.orEmpty).disposed(by: disposeBag)
        //textfield.rx.text.orEmpty
    }
}



//MARK: - Initialize Navigation Bar
extension RFBaseController {

    func setupCustomLeftBarItem(image: String, action: Selector){
        self.navigationItem.hidesBackButton = true
        
        let btn = UIImage(named: image)
        let leftMenuButton = UIBarButtonItem(image: btn?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), style: UIBarButtonItemStyle.plain, target: self, action: action)
        
        self.navigationItem.leftBarButtonItem = leftMenuButton
    }
    
    func setupRightBarItemWith(image: String, action: Selector){
        let btn = UIImage(named: image)
        let rightMenuBtn = UIBarButtonItem(image: btn?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), style: UIBarButtonItemStyle.plain, target: self, action: action)
        
        self.navigationItem.rightBarButtonItem = rightMenuBtn
    }
    
    func setupRightBarItemWith(title: String, action: Selector){
        let btn = UIButton(type: .custom)
        let attrs: [NSAttributedStringKey : Any] = [
            NSAttributedStringKey.foregroundColor : RFColor.instance.primGray,
            NSAttributedStringKey.underlineStyle : NSUnderlineStyle.styleSingle.rawValue,
        ]
        let btnTitle = NSMutableAttributedString(string: title, attributes: attrs)
        btn.setAttributedTitle(btnTitle, for: .normal)
        btn.showsTouchWhenHighlighted = false
        
        btn.addTarget(self, action: action, for: .touchUpInside)
        
        let barButton = UIBarButtonItem(customView: btn)
        self.navigationItem.rightBarButtonItem = barButton
    }
    
}
