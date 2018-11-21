//
//  MessageHeaderView.swift
//  ResepFinder
//
//  Created by William Huang on 20/11/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import UIKit

class MessageHeaderView: UIView {

    private var contentView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UILabel!
 
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupContentView()
//        setupLabel()
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        setupContentView()
//        setupLabel()
//    }
//    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupLabel()
    }
    
//
//    private func setupContentView() {
//        self.contentView = self.loadViewFromNib()
//        contentView.backgroundColor = .red
//        self.contentView.autoresizingMask = [ .flexibleHeight, .flexibleWidth]
//        self.addSubview(self.contentView)
//        
//    }
    
    private func setupLabel(){
        self.profileImage.backgroundColor = .red
        self.profileName.text = "Usernaem100"
    }

//    private func loadViewFromNib() -> UIView{
//        let bundle = Bundle(for:type(of: self))
//
//        let nib = UINib(nibName: "MessageHeaderView" , bundle: bundle)
//        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
//        return view
//    }
    
    
}
