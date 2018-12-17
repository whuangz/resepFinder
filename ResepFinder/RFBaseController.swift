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
import RxGesture

class RFBaseController: UIViewController {
    
    let disposeBag = DisposeBag()
    var searchBar: SearchBar!

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
        //self.navigationItem.setRightBarButton(rightMenuBtn, animated: true)
    }
    
    func setupRightBarItemWith(title: String, action: Selector){
        let btn = UIButton(type: .custom)
        let attrs: [NSAttributedStringKey : Any] = [
            NSAttributedStringKey.font : RFFont.instance.subHead14,
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
    
    func setSearchBarAsNavigation(){
        let frame = CGRect(x:0, y:0, width:(self.navigationController?.navigationBar.frame.width)!, height:(self.navigationController?.navigationBar.frame.height)!)
        
        let navbarView = UIView(frame: frame)
        searchBar = SearchBar(frame: .zero)
        searchBar.frame = CGRect(x:0, y:0, width:(self.navigationController?.navigationBar.frame.width)!, height:40)
        searchBar.autoresizingMask = [.flexibleWidth]
        searchBar.placeholder = "Find Recipe ..."
        searchBar.isUserInteractionEnabled = true
        navbarView.addSubview(searchBar)
        self.navigationItem.titleView = navbarView
    }
    
}

extension RFBaseController {
    
    @objc func navigateToAdvanceSearch(_ locationID: String) {
        let vm = RFAdvancedSearchVM(locID: locationID)
        let advancedSearchVC = RFAdvancedSearchVC(vm: vm)
        advancedSearchVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(advancedSearchVC, animated: true)
    }
    
    @objc func navigateToPreviouseScreen(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func dismissToPreviousScreen(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func dismissSwipeView(){
        self.dismissDetail()
    }
    
    @objc func swipeBack(){
        self.popViewController()
    }
    
    @objc func dismissToRoot(){
        self.navigationController?.popToRootViewController(animated: true)
    }

}
