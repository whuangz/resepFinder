//
//  RegistrationsVC.swift
//  RFProfileMenu
//
//  Created by William Huang on 30/10/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import UIKit
import RxSwift

class RegistrationsVC: UIViewController {
    
    @IBOutlet weak var scrollView: TPKeyboardAvoidingScrollView!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var registerTitle: UILabel!
    @IBOutlet weak var userNameTxt: RFCustomTextField!
    @IBOutlet weak var emailTxt: RFCustomTextField!
    @IBOutlet weak var pwdTxt: RFCustomTextField!
    @IBOutlet weak var conPwdTxt: RFCustomTextField!
    @IBOutlet weak var regionTxt: RFCustomTextField!
    @IBOutlet weak var registerBtn: RFPrimaryBtn!
    @IBOutlet weak var loginLink: UIButton!
    @IBOutlet weak var socialLbl: UILabel!
    @IBOutlet weak var textFieldStackView: UIStackView!
    private var viewModel: RegistrationsVM?
    private let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        setupView()
        addGesture()
        setupDelegate()
        setupViewModel()
        
        if UIScreen.main.bounds.size.width <= 320 {
            self.textFieldStackView.spacing = 10
        }
    }
    
    func setupDelegate(){
        self.userNameTxt.delegate = self
        self.emailTxt.delegate = self
        self.pwdTxt.delegate = self
        self.conPwdTxt.delegate = self
    }
    
    //MARK: - SETUP Localized Strings
    let registerTitleText = "\(RFLocalizedString().forKey("register_title"))"
    let namePlaceholder = "\(RFLocalizedString().forKey("username_placeholder"))"
    let emailPlaceholder = "\(RFLocalizedString().forKey("email_placeholder"))"
    let pwdPlaceholder = "\(RFLocalizedString().forKey("pwd_placeholder"))"
    let condPwdPlaceholder = "\(RFLocalizedString().forKey("con_pwd_placeholder"))"
    let regionPlaceholder = "\(RFLocalizedString().forKey("region_placeholder"))"
    let registerBtnText = "\(RFLocalizedString().forKey("sign_up_label"))"
    let loginLinkText = "\(RFLocalizedString().forKey("login_link_label"))"
    let socialMediaText = "\(RFLocalizedString().forKey("social_media_label"))"
}

extension RegistrationsVC: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.scrollView.setContentOffset(CGPoint(x: self.scrollView.contentOffset.x, y: 0), animated: true)
    }
}

extension RegistrationsVC {
    private func setupViewModel(){
        self.viewModel = RegistrationsVM()
        bindToViewModel()
        callBacks()
    }
    
    func bindToViewModel(){
        guard let viewModel = self.viewModel else {return}
        
        self.userNameTxt.rx.text.orEmpty.bind(to: viewModel.username).disposed(by: disposeBag)
        self.emailTxt.rx.text.orEmpty.bind(to: viewModel.email).disposed(by: disposeBag)
        self.pwdTxt.rx.text.orEmpty.bind(to: viewModel.pwd).disposed(by: disposeBag)
        self.conPwdTxt.rx.text.orEmpty.bind(to: viewModel.conPwd).disposed(by: disposeBag)
        
        let validation = viewModel.validateRegister()
        validation.bind(onNext: { (valid) in
            if valid {
                self.registerBtn.makeEnabled()
            }else{
                self.registerBtn.makeDisabled()
            }
        }).disposed(by: disposeBag)
        self.registerBtn.rx.tap.do(onNext: { [unowned self] in
            self.view.endEditing(true)
        }).subscribe { (_) in
            viewModel.doRegister()
        }.disposed(by: disposeBag)
        
    }
    
    func callBacks(){
        guard let viewModel = self.viewModel else {return}
        viewModel.isSuccess.asObservable().bind { (valid) in
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
extension RegistrationsVC {
    
    func addGesture(){
        self.regionTxt.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(navigateToRegionList)))
        self.loginLink.addTarget(self, action: #selector(navigateToLogin), for: .touchUpInside)
        self.closeBtn.addTarget(self, action: #selector(navigateToHomeVC), for: .touchUpInside)
    }
    
    @objc func navigateToRegionList(){
        let locationVM = RFLocationVM()
        let locationVC = RFLocationVC(vm: locationVM, delegate: self)
        //self.presentDetail(locationVC)
        //self.present(locationVC, animated: true, completion: nil)
        self.navigationController?.pushViewController(locationVC, animated: true)
    }
    
    @objc func navigateToLogin(){
        let loginVC = LoginVC.init(nibName: "LoginVC", bundle: nil)
        self.present(loginVC, animated: true, completion: nil)
    }
    
    @objc func navigateToHomeVC() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func navigateToProfileMenu(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.redirectoProfileMenu()
    }
}


//MARK: - PREPARE FOR VIEW
extension RegistrationsVC {
    func setupView(){
        setupLabels()
        setupTextField()
        setupButton()
    }
    
    func setupLabels(){
        //set text
        self.registerTitle.text = registerTitleText
        self.userNameTxt.setPlaceholder(namePlaceholder, floatingTitle: namePlaceholder)
        self.emailTxt.setPlaceholder(emailPlaceholder, floatingTitle: emailPlaceholder)
        self.pwdTxt.setPlaceholder(pwdPlaceholder, floatingTitle: pwdPlaceholder)
        self.conPwdTxt.setPlaceholder(condPwdPlaceholder, floatingTitle: condPwdPlaceholder)
        self.regionTxt.text = regionPlaceholder
        self.registerBtn.setTitle(registerBtnText, for: .normal)
        self.loginLink.setTitle(loginLinkText, for: .normal)
        self.socialLbl.text = socialMediaText
        
        
        //set font
        self.registerTitle.font = RFFont.instance.headBold18
        
    }
    
    func setupTextField(){
        self.emailTxt.keyboardType = .emailAddress
        self.pwdTxt.showHidePasswordView()
        self.conPwdTxt.showHidePasswordView()
    }
    
    func setupButton(){
        self.closeBtn.setImage(UIImage(named: "close"), for: .normal)
        self.closeBtn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom:0, right: 16)
        self.registerBtn.makeDisabled()
    }

}

extension RegistrationsVC: SelectLocationDelegate {
    func didChooseLocation(location: RFLocation) {
        guard let viewModel = self.viewModel else {return}
        self.regionTxt.text = location.name
        self.regionTxt.rx.text.orEmpty.bind(to: viewModel.region).disposed(by: disposeBag)
    }
    
}
