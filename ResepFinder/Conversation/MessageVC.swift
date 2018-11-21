//
//  MessageVC.swift
//  ResepFinder
//
//  Created by William Huang on 20/11/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import UIKit

class MessageVC: UITableViewController {

    fileprivate let cellID = "msgCell"
    var messageArr = [
        [
            Message(content: "King joy is the first king of reberum kingodm, he was very powerful with his spear and he's called sea serpent during his realm.", incoming: true, date: Date.dateFormatString(date: "08/03/2018")),
            Message(content: "King joy was killed by his own wife, when his wife found out that he's used to be a serpent that kill the whole village of his wife", incoming: true, date: Date.dateFormatString(date: "08/03/2018")),
            ],
        [
            Message(content: "Yes, He was killed sadistically", incoming: false, date: Date.dateFormatString(date: "08/09/2018")),
        ]
    ]
    
    let headerView: MessageHeaderView =  {
        let view = Bundle.main.loadNibNamed("MessageHeaderView", owner: self, options: nil)?.first as! MessageHeaderView
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let navbarView = UIView()
        self.navigationItem.hidesBackButton = true
        let backButton = UIImage(named: "back")
        let leftMenuButton = UIBarButtonItem(image: backButton?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), style: UIBarButtonItemStyle.plain, target: self, action: #selector(navigateBack))
        
    
    
        navbarView.frame =  CGRect(x:0, y:0, width:(self.navigationController?.navigationBar.frame.width)!, height:(self.navigationController?.navigationBar.frame.height)!)
        navbarView.addSubview(self.headerView)
        self.headerView.centerConstraintWith(centerY: navbarView.centerYAnchor)
        
        self.navigationItem.leftBarButtonItem = leftMenuButton
        self.navigationItem.titleView = navbarView
        
//        if let navigationBar = self.navigationController?.navigationBar {
//            navigationBar.addSubview(headerView!)
//        }
        tableView.register(MessageCell.self, forCellReuseIdentifier: cellID)
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
    }
    
    @objc func navigateBack(){
        self.navigationController?.popViewController(animated: true)
    }
    


    @objc private func handleTap(){

        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(2000)) {
            let newMessage = Message(content: "Yes, He was killed sadistically", incoming: true, date: Date.dateFormatString(date: "08/019/2018"))
            self.messageArr.append([newMessage])
            //messageArr.sort() {$0.first?.date. < $1.first?.date}
            self.tableView.reloadData()
        }

    }

}


class DateHeaderLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        translatesAutoresizingMaskIntoConstraints = false
        textColor = UIColor.white
        textAlignment = .center
        font = UIFont.boldSystemFont(ofSize: 14)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        let originalContentSize = super.intrinsicContentSize
        let height = originalContentSize.height + 12
        layer.cornerRadius = height / 2
        layer.masksToBounds = true
        return CGSize(width: originalContentSize.width + 16, height: height)
    }
}

extension MessageVC {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageArr[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? MessageCell
        let msg = messageArr[indexPath.section][indexPath.row]

        cell?.chatMessages = msg

        return cell!
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return messageArr.count
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
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

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
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
