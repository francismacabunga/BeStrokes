//
//  AppDelegate.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 9/21/20.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    var window: UIWindow?
    var openedFromTryMeButton: Bool!
    var openedFromCaptureButton: Bool!
    var isLightModeOn: Bool!
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        openedFromTryMeButton = UserDefaults.standard.bool(forKey: Strings.firstTimeLaunchFromTMBKey)
        openedFromCaptureButton = UserDefaults.standard.bool(forKey: Strings.firstTimeLaunchFromCBKey)
        isLightModeOn = UserDefaults.standard.bool(forKey: Strings.lightModeKey)
        if !openedFromTryMeButton {
            UserDefaults.standard.setValue(true, forKey: Strings.firstTimeLaunchFromTMBKey)
        }
        if !openedFromCaptureButton {
            UserDefaults.standard.setValue(true, forKey: Strings.firstTimeLaunchFromCBKey)
        }
        
        return true
        
    }
    
    func setValue(forKey key: String, value: Bool, forTryMeButton: Bool? = nil, forCaptureButton: Bool? = nil, forLightModeSwitch: Bool? = nil) {
        if value {
            UserDefaults.standard.setValue(true, forKey: key)
        } else {
            UserDefaults.standard.setValue(false, forKey: key)
        }
        if forTryMeButton != nil {
            if forTryMeButton! {
                openedFromTryMeButton = true
            }
        }
        if forCaptureButton != nil {
            if forCaptureButton! {
                openedFromCaptureButton = true
            }
        }
        if forLightModeSwitch != nil {
            if forLightModeSwitch! {
                isLightModeOn = true
            } else {
                isLightModeOn = false
            }
        }
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
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    
}

