//
//  LoginVCViewController.swift
//  ResepFinder
//
//  Created by William Huang on 07/11/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class LoginVC: UIViewController {

    @IBOutlet weak var scrollView: TPKeyboardAvoidingScrollView!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var loginTitle: UILabel!
    @IBOutlet weak var emailTxt: RFTextField!
    @IBOutlet weak var pwdTxt: RFTextField!
    @IBOutlet weak var loginBtn: RFButton!
    @IBOutlet weak var socialLbl: UILabel!
    @IBOutlet weak var textFieldStackView: UIStackView!
    private var viewModel: LoginVM?
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupViewModel()
        setupDelegate()
        addGesture()
    }
    
    func setupDelegate(){
        self.emailTxt.delegate = self
        self.pwdTxt.delegate = self
    }

    //MARK: - SETUP Localized Strings
    let loginLabel = "\(RFLocalizedString().forKey("login_label"))"
    let emailPlaceholder = "\(RFLocalizedString().forKey("email_placeholder"))"
    let pwdPlaceholder = "\(RFLocalizedString().forKey("pwd_placeholder"))"
    let loginBtnText = "\(RFLocalizedString().forKey("login_label"))"
    let socialMediaText = "\(RFLocalizedString().forKey("social_media_label"))"
}


extension LoginVC: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.scrollView.setContentOffset(CGPoint(x: self.scrollView.contentOffset.x, y: 0), animated: true)
    }
}


extension LoginVC {
    private func setupViewModel(){
        self.viewModel = LoginVM()
        bindToViewModel()
        callBacks()
    }
    
    func bindToViewModel(){
        guard let viewModel = self.viewModel else {return}
        
        self.emailTxt.rx.text.orEmpty.bind(to: viewModel.email).disposed(by: disposeBag)
        self.pwdTxt.rx.text.orEmpty.bind(to: viewModel.pwd).disposed(by: disposeBag)
        
        let validation = viewModel.validateLogin()
        validation.bind { (valid) in
            if valid {
                self.loginBtn.makeEnabled()
            }else{
                self.loginBtn.makeDisabled()
            }
        }.disposed(by: disposeBag)
        
        self.loginBtn.rx.tap.do(onNext: { [unowned self] in
            self.view.endEditing(true)
        }).subscribe { (_) in
            viewModel.doLogin()
        }.disposed(by: disposeBag)
        
    }
    
    func callBacks(){
        guard let viewModel = self.viewModel else {return}
        viewModel.isSuccess.asObservable().bind { (valid) in
            print(valid)
            if valid {
                self.navigateToProfileMenu()
            }
        }.disposed(by: disposeBag)
        
        viewModel.errMsg.asObservable().bind { (message) in
            debugPrint(message)
        }.disposed(by: disposeBag)
    }
}


//MARK: - ADD GESTURE ACTION
extension LoginVC {
    
    func addGesture(){
        self.closeBtn.addTarget(self, action: #selector(dismissLoggedInView), for: .touchUpInside)
    }
    
    @objc func navigateToRegionList(){
        print("LIST")
    }
    
    @objc func dismissLoggedInView(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func navigateToProfileMenu(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.redirectoProfileMenu()
    }
}


//MARK: - PREPARE FOR VIEW
extension LoginVC {
    func setupView(){
        setupLabels()
        setupTextField()
        setupButton()
    }
    
    func setupLabels(){
        //set text
        self.loginTitle.text = loginLabel
        self.emailTxt.setPlaceholder(emailPlaceholder, floatingTitle: emailPlaceholder)
        self.pwdTxt.setPlaceholder(pwdPlaceholder, floatingTitle: pwdPlaceholder)
        self.loginBtn.setTitle(loginBtnText, for: .normal)
        self.socialLbl.text = socialMediaText
        
        
        //set font
        self.loginTitle.font = RFFont.instance.headBold18
        
    }
    
    func setupTextField(){
        self.emailTxt.keyboardType = .emailAddress
        self.pwdTxt.showHidePasswordView()
    }
    
    func setupButton(){
        self.closeBtn.setImage(UIImage(named: "close"), for: .normal)
        self.closeBtn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom:0, right: 16)
        self.loginBtn.makeDisabled()
    }
    
}
