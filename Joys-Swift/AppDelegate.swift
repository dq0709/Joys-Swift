//
//  AppDelegate.swift
//  Joys-Swift
//
//  Created by 邓琼 on 2017/7/21.
//  Copyright © 2017年 dq. All rights reserved.
//

import UIKit
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.configGlobalUI()
        let chosenVC = DQChosenTableViewController.init();
        let chosenLeftVC = DQChosenLeftMenuTableViewController.init()
        let chosenMenuVC = RESideMenu.init(contentViewController: chosenVC, leftMenuViewController: chosenLeftVC, rightMenuViewController: nil)
        chosenMenuVC?.tabBarItem.image = UIImage.init(named: "JX")
        self.configSideMenu(sideMenuVC: chosenMenuVC!)
        
        let picVC = DQNavi.standardNavi
        picVC.tabBarItem.image = UIImage.init(named: "MT")

        let jokesTVC = DQJokesTableViewController.init()
        jokesTVC.tabBarItem.image = UIImage.init(named: "DZ")
        
        let tbC = UITabBarController.init()
        tbC.addChildViewController(UINavigationController.init(rootViewController: chosenMenuVC!))
        tbC.addChildViewController(picVC)
        tbC.addChildViewController(UINavigationController.init(rootViewController: jokesTVC))
        
        window = UIWindow.init()
        window?.rootViewController = tbC
        window?.makeKeyAndVisible()
        
        return true
    }
    
    //配置sideMenu
    func configSideMenu(sideMenuVC:RESideMenu) -> Void {
        sideMenuVC.contentViewScaleValue = 0.8;
        sideMenuVC.contentViewInPortraitOffsetCenterX = -20;
        sideMenuVC.backgroundImage = UIImage.init(named: "bgImage_640x1136")
        sideMenuVC.panGestureEnabled = true;
        sideMenuVC.contentViewShadowColor = UIColor.init(red: 126/255.0, green: 126/255.0, blue: 126/255.0, alpha: 1)
        sideMenuVC.contentViewShadowEnabled = true;
        sideMenuVC.menuPreferredStatusBarStyle = UIStatusBarStyle.lightContent
    }
    
    //配置UI
    func configGlobalUI() -> Void {
        UITabBar.appearance().tintColor = UIColor.init(red: 23/255.0, green: 158/255.0, blue: 117/255.0, alpha: 1)
        UITabBar.appearance().selectionIndicatorImage = UIImage.init(named: "barSelectedImage")
        
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().barTintColor = UIColor.init(red: 132/255.0, green: 175/255.0, blue: 109/255.0 , alpha: 1)
        UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName:UIFont.systemFont(ofSize: 20), NSForegroundColorAttributeName:UIColor.white]
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

