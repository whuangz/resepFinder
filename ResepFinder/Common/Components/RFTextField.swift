//
//  RFTextField.swift
//  RFCommon
//
//  Created by William Huang on 30/10/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import UIKit

class RFTextField: JVFloatLabeledTextField {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureTextField()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        configureTextField()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureBottomBorder()
    }
    
    
    fileprivate func configureTextField(){
        self.floatingLabelActiveTextColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        self.keepBaseline = true
        self.autocorrectionType = .no
        self.spellCheckingType = .no
        self.autocapitalizationType = .none
        self.borderStyle = .none
    }
    
    fileprivate func configureBottomBorder(){
        let border = CALayer()
        border.borderColor = UIColor.gray.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - 0.5, width: self.frame.size.width, height: self.frame.size.height)
        
        border.borderWidth = CGFloat(0.5)
        self.layer.masksToBounds = true
        self.layer.addSublayer(border)
    }
    
    
    //MARK: - Properties
    var showHidePasswordImg: UIImageView!
    
}

extension RFTextField {
    
    
    func showHidePasswordView(){
        self.isSecureTextEntry = true
        let active = UIImage(named: "eye-pass-active")
        let inactive = UIImage(named: "eye-pass-inactive")
        self.showHidePasswordImg = UIImageView()
        self.showHidePasswordImg.isUserInteractionEnabled = true
        self.showHidePasswordImg.highlightedImage = active
        self.showHidePasswordImg.image = inactive
        self.showHidePasswordImg.isHighlighted = false
        self.showHidePasswordImg.contentMode = .center
        
        
        self.rightViewMode = .always
        self.rightView = self.showHidePasswordImg
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(showHidePasswordViewTapped))
        self.showHidePasswordImg.addGestureRecognizer(tap)
    }
    
    @objc fileprivate func showHidePasswordViewTapped(){
        
        if self.showHidePasswordImg.isHighlighted == true{
            self.isSecureTextEntry = true
            showHidePasswordImg.isHighlighted = false
        }else{
            showHidePasswordImg.isHighlighted = true
            self.isSecureTextEntry = false
        }
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        let rightBounds = CGRect(x: self.bounds.size.width - 20, y: 15, width: 20, height: 20 )
        return rightBounds
    }
}
