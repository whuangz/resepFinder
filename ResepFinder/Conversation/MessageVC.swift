//
//  MessageVC.swift
//  ResepFinder
//
//  Created by William Huang on 20/11/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import UIKit

class MessageVC: RFBaseController {

    private let messageTableView: UITableView! = {
        let tableView = UITableView()
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = .none
        
        return tableView
    }()
    
    let headerView: MessageHeaderView =  {
        let view = Bundle.main.loadNibNamed("MessageHeaderView", owner: self, options: nil)?.first as! MessageHeaderView
        return view
    }()
    
    let messageInputContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let inputTextField: RFTextField = {
        let textField = RFTextField()
        textField.placeholder = "Message..."
        textField.backgroundColor = .white
        textField.setBorderColor(RFColor.instance.gray3, width: 1)
        textField.layer.cornerRadius = 16
        textField.returnKeyType = .send
        return textField
    }()
    
    let imageButton: RFPrimaryBtn = {
        let button = RFPrimaryBtn()
        button.setContentImageFor(inactive: "img_icon")
        button.setCornerWith(radius: 15)
        button.setBorderColor(RFColor.instance.gray3, width: 1)
        return button
    }()
    
    private var keyboardBottomSpaceConstraint: NSLayoutConstraint?
    
    fileprivate let cellID = "msgCell"
    var messageArr = [
        [
            Message(content: "King joy is the first king of reberum kingodm, he was very powerful with his spear and he's called sea serpent during his realm.", incoming: true, date: Date.dateFormatString(date: "08/03/2018")),
            Message(content: "King joy was killed by his own wife, when his wife found out that he's used to be a serpent that kill the whole village of his wife", incoming: true, date: Date.dateFormatString(date: "08/03/2018")),
        ],
        
        [
            Message(content: "Yes, He was killed sadistically", incoming: false, date: Date.dateFormatString(date: "08/09/2018")),
            Message(content: "Yes, He was killed sadistically", incoming: false, date: Date.dateFormatString(date: "08/09/2018")),
            Message(content: "Yes, He was killed sadistically", incoming: false, date: Date.dateFormatString(date: "08/09/2018")),
            Message(content: "Yes, He was killed sadistically", incoming: false, date: Date.dateFormatString(date: "08/09/2018")),
            Message(content: "Yes, He was killed sadistically", incoming: false, date: Date.dateFormatString(date: "08/09/2018")),
            Message(content: "Yes, He was killed sadistically", incoming: false, date: Date.dateFormatString(date: "08/09/2018")),
        ],
        
        [
            Message(content: "Yes, He was killed sadistically", incoming: true, date: Date.dateFormatString(date: "08/11/2018")),
            Message(content: "Yes, He was killed sadistically", incoming: true, date: Date.dateFormatString(date: "08/11/2018")),
            Message(content: "Yes, He was killed sadistically", incoming: true, date: Date.dateFormatString(date: "08/11/2018")),
            Message(content: "Yes, He was killed sadistically", incoming: true, date: Date.dateFormatString(date: "08/11/2018")),
            Message(content: "Yes, He was killed sadistically", incoming: true, date: Date.dateFormatString(date: "08/11/2018")),
            Message(content: "Yes, He was killed sadistically", incoming: true, date: Date.dateFormatString(date: "08/11/2018")),
            ]
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
        prepareUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        observeKeyboard()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    fileprivate func observeKeyboard() {
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillAppear(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillDisappear(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillAppear(_ notification: Notification){
        if let info = notification.userInfo {
            if let value: NSValue = info[UIKeyboardFrameEndUserInfoKey] as? NSValue {
                let rawFrame = value.cgRectValue
                let keyboardFrame = self.view.convert(rawFrame, to: nil);
                self.keyboardBottomSpaceConstraint?.constant = -(keyboardFrame.size.height + self.view.safeAreaBottomHeight())
                UIView.animate(withDuration: 0, delay: 0, options: .curveEaseOut, animations: {
                    self.view.layoutIfNeeded()
                }) { (completed) in
                    self.scrolltoLastItemOfMessage()
                }
            }
        }
    }
    
    private func scrolltoLastItemOfMessage(){
        let indexPath = IndexPath(item: (self.messageArr.last?.count)! - 1, section: self.messageArr.count - 1)
        self.messageTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    @objc func keyboardWillDisappear(_ notification: Notification){
        self.keyboardBottomSpaceConstraint?.constant = 0
        self.view.layoutIfNeeded()
    }
    
    private func setupTableView(){
        messageTableView.delegate = self
        messageTableView.dataSource = self
        messageTableView.separatorStyle = .none
        messageTableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        registerCell()
    }
    
    private func registerCell(){
        messageTableView.register(MessageCell.self, forCellReuseIdentifier: cellID)
    }
    
    private func setupNavigationBar(){
        self.navigationItem.hidesBackButton = true
        let backButton = UIImage(named: "back")
        let leftMenuButton = UIBarButtonItem(image: backButton?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), style: UIBarButtonItemStyle.plain, target: self, action: #selector(navigateBack))
        self.navigationItem.leftBarButtonItem = leftMenuButton
        
        
        let navbarView = UIView()
        navbarView.frame =  CGRect(x:0, y:0, width:(self.navigationController?.navigationBar.frame.width)!, height:(self.navigationController?.navigationBar.frame.height)!)
        navbarView.addSubview(self.headerView)
        _ = self.headerView.centerConstraintWith(centerY: navbarView.centerYAnchor)
        
        self.navigationItem.titleView = navbarView
    }
    
    private func setupHiddenTabBar(_ status: Bool){
        self.tabBarController?.tabBar.isHidden = status
    }
    
    private func prepareUI(){
        self.view.addSubview(messageTableView)
        self.view.addSubview(messageInputContainer)
        
        _ = messageTableView.anchor(top: self.view.topAnchor, left: self.view.leftAnchor, right: self.view.rightAnchor, topConstant: 0, leftConstant: 0,rightConstant: 0)
        _ = messageInputContainer.anchor(top: self.messageTableView.bottomAnchor, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 48)
        
        keyboardBottomSpaceConstraint = NSLayoutConstraint.init(item: self.messageInputContainer, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: 0)
        self.view.addConstraint(keyboardBottomSpaceConstraint!)
        
        
        
        self.messageInputContainer.addSubview(inputTextField)
        self.messageInputContainer.addSubview(imageButton)
        
        self.messageInputContainer.constraintWithVisual(format: "H:|-16-[v0(30)]-8-[v1]-16-|", views: imageButton, inputTextField)
        self.messageInputContainer.constraintWithVisual(format: "V:|-8-[v0]-8-|", views: inputTextField)
        self.messageInputContainer.constraintWithVisual(format: "V:|-8-[v0]-8-|", views: imageButton)
    }
    
    @objc func navigateBack(){
        self.navigationController?.popViewController(animated: true)
    }
    


    @objc private func handleTap(){

        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(2000)) {
            let newMessage = Message(content: "Yes, He was killed sadistically", incoming: true, date: Date.dateFormatString(date: "08/019/2018"))
            self.messageArr.append([newMessage])
            //messageArr.sort() {$0.first?.date. < $1.first?.date}
            self.messageTableView.reloadData()
        }

    }

}

extension MessageVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArr[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? MessageCell
        let msg = messageArr[indexPath.section][indexPath.row]

        cell?.chatMessages = msg
        cell?.selectionStyle = .none

        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        inputTextField.endEditing(true)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return messageArr.count
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let firstMessage = messageArr[section].first {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyy"
            let date = dateFormatter.string(from: firstMessage.date)

            let label = DateHeaderLabel()

            label.text = date

            let containerView = UIView()
            containerView.addSubview(label)
            label.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
            label.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true

            return containerView
        }

        return UIView()
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}


//
//fileprivate func setSearchBarNavigation(){
//    self.navigationController?.navigationBar.isTranslucent = false
//    self.searchNavigationBar = BSASettingNavigationView(frame: .zero)
//    if let searchNavigationBar = self.searchNavigationBar, let navigationBar = self.navigationController?.navigationBar {
//        searchNavigationBar.datasource = self
//        let searchBarWidth : CGFloat = BSAScreenHelper.screenWidth()
//        let searchBarHeight : CGFloat = 44
//
//        searchNavigationBar.frame =  CGRect(x:0, y:0, width: searchBarWidth ,height: searchBarHeight)
//        searchNavigationBar.autoresizingMask = [ .flexibleHeight, .flexibleWidth]
//        navigationBar.addSubview(searchNavigationBar)
//
//
//    }
//}


//private func loadViewFromNib() -> UIView {
//    let bundle = Bundle(for:type(of: self))
//
//    let nib = UINib(nibName: "BSASearchNavigationView" , bundle: bundle)
//    let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
//    return view
//}
