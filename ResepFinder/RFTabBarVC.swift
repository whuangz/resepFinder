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
        self.view.backgroundColor = .white
        configureViews()
        setupTabBarMenuItems()
    }
    
    fileprivate func setupTabBarMenuItems(){
        self.tabBar.tintColor = .white
        self.tabBar.isTranslucent = false
        self.delegate = self
        let home = self.setTabBarItem(HomeVC(), imageName: "home", selectedImg: "selected_home", tag: 1, title: RFLocalizedString().forKey("home_tab_menu"))
        
        
        let createRecipe = CreateVC()
        createRecipe.tabBarItem.title = "\(RFLocalizedString().forKey("create_tab_menu"))"
        createRecipe.tabBarItem.image = UIImage(named: "createR")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        createRecipe.tabBarItem.tag = 2
        
        
        let conversation = self.setTabBarItem(ConversationVC(), imageName: "conversation", selectedImg: "selected_conversation", tag: 3, title: RFLocalizedString().forKey("conversation_tab_menu"))
        
        let profile = self.setTabBarItem(self.profileVC, imageName: "profile", selectedImg: "selected_profile", tag: 4, title: RFLocalizedString().forKey("profile_tab_menu"))
        
        self.viewControllers = [home, createRecipe, conversation, profile]
        self.selectedViewController = self.viewControllers?.first as? UINavigationController
    }
    
    fileprivate func configureViews(){
        let attrs = [NSAttributedStringKey.font: RFFont.instance.headBold14!]
        UINavigationBar.appearance().titleTextAttributes = attrs
    }
    
    private func setTabBarItem(_ vc: UIViewController, imageName: String, selectedImg: String, tag: Int, title:String) -> UINavigationController{
        let navigationVC = UINavigationController(rootViewController: vc as UIViewController)
        navigationVC.tabBarItem.image = UIImage(named: imageName)?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        navigationVC.tabBarItem.selectedImage = UIImage(named: selectedImg)?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        navigationVC.tabBarItem.imageInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        navigationVC.tabBarItem.tag = tag
        navigationVC.tabBarItem.title = title
        navigationVC.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor : RFColor.instance.black], for: UIControlState())
        navigationVC.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.font : RFFont.instance.subHead10!], for: UIControlState())
        navigationVC.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor : RFColor.instance.darkGreen1], for: UIControlState.selected)
        
        return navigationVC
    }
    
    
    //MARK: - GET SPECIFIC TAB BAR ITEM
    func getSelectedItemOf(_ selectedVC: RFTabBarItem){
        self.selectedViewController = self.viewControllers?[selectedVC.rawValue] as? UINavigationController
    }
    
}


extension RFTabBarVC: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        // If your view controller is emedded in a UINavigationController you will need to check if it's a UINavigationController and check that the root view controller is your desired controller (or subclass the navigation controller)
        if viewController is CreateVC {
            
            let createVC = CreateVC()
            let navigationVC = UINavigationController(rootViewController: createVC)
            navigationVC.hidesBottomBarWhenPushed = true
            self.present(navigationVC, animated: true, completion: nil)
            
            return false
        }
        
        // Tells the tab bar to select other view controller as normal
        return true
    }
}
