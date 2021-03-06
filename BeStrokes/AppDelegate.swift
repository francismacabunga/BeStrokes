//
//  AppDelegate.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 9/21/20.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        
        if Auth.auth().currentUser != nil {
            let tabBarVC = Utilities.transition(to: Strings.tabBarVC, onStoryboard: Strings.userStoryboard, canAccessDestinationProperties: true) as! TabBarViewController
            tabBarVC.selectedViewController = tabBarVC.viewControllers?[0]
            self.window?.rootViewController = tabBarVC
            self.window?.makeKeyAndVisible()
        } else {
            let landingVC = Utilities.transition(to: Strings.landingVC, onStoryboard: Strings.guestStoryboard, canAccessDestinationProperties: true) as! LandingViewController
            self.window?.rootViewController = landingVC
            self.window?.makeKeyAndVisible()
        }
        
        return true
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        Utilities.checkIfNotificationIsPermitted { (permission) in
            if permission {
                UserDefaults.standard.setValue(true, forKey: Strings.notificationKey)
                NotificationCenter.default.post(name: Utilities.setBadgeCounterToNotificationIcon, object: nil)
            } else {
                UserDefaults.standard.setValue(false, forKey: Strings.notificationKey)
                NotificationCenter.default.post(name: Utilities.setBadgeCounterToNotificationIcon, object: nil)
            }
        }
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    
}
