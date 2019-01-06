//
//  AppDelegate.swift
//  ResepFinder
//
//  Created by William Huang on 29/10/18.
//  Copyright © 2018 William Huang. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let tabBar = RFTabBarVC()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        //window?.rootViewController = RegistrationsVC(nibName: "RegistrationsVC", bundle: nil)
        //redirectoProfileMenu()
        
        window?.rootViewController = tabBar
        FirebaseApp.configure()
        setupUserLocation()
        
        return true
    }
    
    func setupUserLocation(){
        let dataService = RFDataService()
        if let user = Auth.auth().currentUser {
            dataService.getUser(forUid: (user.uid)) { (user) in
                UserDefaults.standard.setLocation(value: user.region!)
            }
        }else{
            UserDefaults.standard.setLocation(value: "Jawa")
        }
    }
    
    func redirectoProfileMenu(){
        let tabBar = RFTabBarVC()
        tabBar.getSelectedItemOf(RFTabBarItem.profile)
        window?.rootViewController = tabBar
//        let profileVC = ProfileVC()
//        window?.rootViewController = profileVC
    }
    
    func redirectoHomeMenu(){
        tabBar.getSelectedItemOf(RFTabBarItem.home)
        window?.rootViewController = tabBar
        //        let profileVC = ProfileVC()
        //        window?.rootViewController = profileVC
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}

extension UIApplication {
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}

