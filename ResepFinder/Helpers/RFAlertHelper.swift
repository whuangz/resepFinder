//
//  RFAlertHelper.swift
//  ResepFinder
//
//  Created by William Huang on 21/12/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import UIKit

class RFAlertHelper: NSObject {
    static let instance = RFAlertHelper()
    
    let alertHeight : CGFloat = 44 + RFScreenHelper.statusBarHeight()
    var alertView : UIView!
    var alertLabel : UILabel!
    var isAlertDisplayed : Bool!
    var tapCompletionHandler: RFAlertTapCompletion?
    
    override init() {
        super.init()
        prepareUI()
    }
    
    func prepareUI(){
        self.alertView = UIView();
        self.alertView.frame = CGRect(x: 0, y: -self.alertHeight, width: RFScreenHelper.screenWidth(), height: self.alertHeight)
        self.alertLabel = UILabel()
        self.alertLabel.font = RFFont.instance.subHead12
        self.alertLabel.textColor = UIColor.white
        self.alertLabel.textAlignment = NSTextAlignment.center
        self.alertView.addSubview(self.alertLabel)
        
        _ = self.alertLabel.anchor(top: self.alertView.topAnchor, bottom: self.alertView.bottomAnchor, topConstant: RFScreenHelper.statusBarHeight(), widthConstant: RFScreenHelper.screenWidth() - 40, heightConstant: self.alertHeight - RFScreenHelper.statusBarHeight())
        _ = self.alertLabel.centerConstraintWith(centerX: self.alertView.centerXAnchor)
        self.isAlertDisplayed = false;
        self.alertLabel.numberOfLines = 2
        
        UIApplication.shared.keyWindow?.bringSubview(toFront: self.alertView)

    }
    
    func showSuccessAlert(_ text: String!, tapCompletion: RFAlertTapCompletion?) {
        self.addTapHandler(tapCompletion, view: self.alertView)
        self.alertView.backgroundColor = RFColor.instance.darkGreen
        self.alertLabel.text = text
        self.animateAlert()
    }
    
    func showSuccessAlert(_ text: String!) {
        self.alertView.backgroundColor = RFColor.instance.darkGreen
        self.alertLabel.text = text
        self.animateAlert()
    }
    
    func showFailureAlert(_ text: String!) {
        let backgroundColor = UIColor(red:1, green:0.36, blue:0.32, alpha:1)
        self.alertView.backgroundColor = backgroundColor
        self.alertLabel.text = text
        self.animateAlert()
    }
    
    func show() {
        self.animateAlert()
    }
    
    func animateAlert() {
        UIApplication.shared.keyWindow!.addSubview(self.alertView)
        _ = self.alertView.anchor(widthConstant: RFScreenHelper.screenWidth() , heightConstant: self.alertHeight)
    
        if(!self.isAlertDisplayed) {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.2, animations: { () -> Void in
                    self.isAlertDisplayed = true
                    self.alertView.frame.origin.y = 0
                    
                }, completion: { (isFinished) -> Void in
                    Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(RFAlertHelper.animateAlertUp), userInfo: nil, repeats: false)
                    
                })
            }
        }
    }
    
    
    @objc func animateAlertUp() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.2, delay: 0.1, options: UIViewAnimationOptions(), animations: { () -> Void in
                
                self.alertView.frame.origin.y = -self.alertHeight
                
                
            }, completion: { (isFinished) -> Void in
                self.isAlertDisplayed = false
                self.alertView.removeFromSuperview()
            })
        }
        
    }
    
    @objc func tapCompletion() {
        if self.tapCompletionHandler != nil {
            self.animateAlertUp()
            self.tapCompletionHandler!(nil)
            self.tapCompletionHandler = nil
        }
    }
    
    fileprivate func addTapHandler(_ tapCompletion: RFAlertTapCompletion!, view: UIView) {
        self.tapCompletionHandler = tapCompletion
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(RFAlertHelper.tapCompletion))
        view.addGestureRecognizer(tapGesture)
    }

}
