//
//  ViewController.swift
//  ResepFinder
//
//  Created by William Huang on 29/10/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import UIKit

class RFTabBarVC: UITabBarController {

    private var profileVC = ProfileVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarMenuItems()
    }
    
    fileprivate func setupTabBarMenuItems(){
        self.tabBar.tintColor = .white
        self.tabBar.isTranslucent = false
        
        let home = self.setTabBarItem(UIViewController(), imageName: "home", selectedImg: "selected_home", tag: 1, title: RFLocalizedString().forKey("home_tab_menu"))
        let create = self.setTabBarItem(UIViewController(), imageName: "createR", selectedImg: "selected_createR", tag: 2, title: RFLocalizedString().forKey("create_tab_menu"))
        let conversation = self.setTabBarItem(UIViewController(), imageName: "conversation", selectedImg: "selected_conversation", tag: 3, title: RFLocalizedString().forKey("conversation_tab_menu"))
        let profile = self.setTabBarItem(self.profileVC, imageName: "profile", selectedImg: "selected_profile", tag: 4, title: RFLocalizedString().forKey("profile_tab_menu"))
        
        self.viewControllers = [home, create, conversation, profile]
        self.selectedViewController = self.viewControllers?.first as? UINavigationController
    }
    
    private func addTabBarItemVC(_ vc: UIViewController, imageName: String, selectedImg: String, tag: Int, title:String){
    }
    
    private func setTabBarItem(_ vc: UIViewController, imageName: String, selectedImg: String, tag: Int, title:String) -> UINavigationController{
        let navigationVC = UINavigationController(rootViewController: vc as UIViewController)
        navigationVC.tabBarItem.image = UIImage(named: imageName)?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        navigationVC.tabBarItem.selectedImage = UIImage(named: selectedImg)?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        navigationVC.tabBarItem.imageInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        navigationVC.tabBarItem.tag = tag
        navigationVC.tabBarItem.title = title
        navigationVC.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor : RFColor.instance.black], for: UIControlState())
        navigationVC.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor : RFColor.instance.darkGreen1], for: UIControlState.selected)
        return navigationVC
    }
}

