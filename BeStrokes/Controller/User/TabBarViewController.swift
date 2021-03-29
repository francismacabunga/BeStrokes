//
//  TabBarViewController.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 12/9/20.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    //MARK: - Constants / Variables
    
    private var userTabBar: UITabBar?
    private var userTabBarItem = [UITabBarItem]()
    private let stickerData = StickerData()
    
    
    //MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTabBar()
        setDelegate()
        setDesignElements()
        setIconData()
        
    }
    
    
    //MARK: - Design Elements
    
    func setDesignElements() {
        NotificationCenter.default.addObserver(self, selector: #selector(setLightMode), name: Utilities.setLightModeAppearance, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setDarkMode), name: Utilities.setDarkModeAppearance, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateBadgeCounter), name: Utilities.setBadgeCounterToNotificationIcon, object: nil)
        checkThemeAppearance()
    }
    
    func checkThemeAppearance() {
        if UserDefaults.standard.bool(forKey: Strings.lightModeKey) {
            setLightMode()
        } else {
            setDarkMode()
        }
    }
    
    @objc func setLightMode() {
        UIView.animate(withDuration: 0.3) { [self] in
            Utilities.setDesignOn(tabBar: userTabBar!, backgroundColor: .white, iconColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        }
    }
    
    @objc func setDarkMode() {
        UIView.animate(withDuration: 0.3) { [self] in
            Utilities.setDesignOn(tabBar: userTabBar!, backgroundColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), iconColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        }
    }
    
    @objc func updateBadgeCounter() {
        setBadgeCounterValue()
    }
    
    func setBadgeCounterValue() {
        DispatchQueue.main.async { [self] in
            if UserDefaults.standard.bool(forKey: Strings.notificationKey) {
                if UserDefaults.standard.integer(forKey: Strings.notificationBadgeCounterKey) > 0 {
                    userTabBarItem[2].badgeValue = "\(UserDefaults.standard.integer(forKey: Strings.notificationBadgeCounterKey))"
                } else {
                    userTabBarItem[2].badgeValue = nil
                }
            } else {
                userTabBarItem[2].badgeValue = nil
            }
        }
    }
    
    func setIconData() {
        userTabBarItem[0].tag = 0
        userTabBarItem[0].image = UIImage(systemName: Strings.tabHomeIcon)
        userTabBarItem[1].tag = 1
        userTabBarItem[1].image = UIImage(systemName: Strings.tabCaptureIcon)
        userTabBarItem[2].tag = 2
        userTabBarItem[2].image = UIImage(systemName: Strings.tabNotificationIcon)
        userTabBarItem[3].tag = 3
        userTabBarItem[3].image = UIImage(systemName: Strings.tabAccountIcon)
        setBadgeCounterValue()
    }
    
    
    //MARK: - Tab Bar Process
    
    func setTabBar() {
        userTabBar = self.tabBar
        userTabBarItem = (userTabBar?.items)!
    }
    
    func setDelegate() {
        self.delegate = self
    }
    
}


//MARK: - Tab Bar Controller Delegate

extension TabBarViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
      
        
//        tabBarController.selectedViewController = viewController
//        view.window?.rootViewController = tabBarController
//        view.window?.makeKeyAndVisible()
        
        
//        let tabBarVC = tabBarController
//        
//        if tabBarVC.selectedIndex == 0 {
//            print("HomeVC")
//            tabBarVC.selectedViewController = tabBarVC.viewControllers?[0]
//            view.window?.rootViewController = tabBarVC
//            view.window?.makeKeyAndVisible()
//        }
//        if tabBarVC.selectedIndex == 1 {
//            print("CaptureVC")
//            tabBarVC.selectedViewController = tabBarVC.viewControllers?[1]
//            view.window?.rootViewController = tabBarVC
//            view.window?.makeKeyAndVisible()
//        }
//        if tabBarVC.selectedIndex == 2 {
//            print("NotificationVC")
//            tabBarVC.selectedViewController = tabBarVC.viewControllers?[2]
//            view.window?.rootViewController = tabBarVC
//            view.window?.makeKeyAndVisible()
//        }
//        if tabBarVC.selectedIndex == 3 {
//            print("AccountVC")
//            tabBarVC.selectedViewController = tabBarVC.viewControllers?[3]
//            view.window?.rootViewController = tabBarVC
//            view.window?.makeKeyAndVisible()
//        }
    }
       
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if tabBar.selectedItem?.tag == 0 {
            UserDefaults.standard.setValue(true, forKey: Strings.homeVCTappedKey)
            UserDefaults.standard.setValue(true, forKey: Strings.isHomeVCLoadedKey)
            UserDefaults.standard.setValue(false, forKey: Strings.captureVCTappedKey)
            UserDefaults.standard.setValue(false, forKey: Strings.notificationVCTappedKey)
            UserDefaults.standard.setValue(false, forKey: Strings.accountVCTappedKey)
            UserDefaults.standard.setValue(false, forKey: Strings.isCaptureVCLoadedKey)
            UserDefaults.standard.setValue(false, forKey: Strings.isNotificationVCLoadedKey)
            UserDefaults.standard.setValue(false, forKey: Strings.isAccountVCLoadedKey)
        } else if tabBar.selectedItem?.tag == 1 {
            UserDefaults.standard.setValue(true, forKey: Strings.captureVCTappedKey)
            UserDefaults.standard.setValue(true, forKey: Strings.isCaptureVCLoadedKey)
            UserDefaults.standard.setValue(false, forKey: Strings.homeVCTappedKey)
            UserDefaults.standard.setValue(false, forKey: Strings.notificationVCTappedKey)
            UserDefaults.standard.setValue(false, forKey: Strings.accountVCTappedKey)
            UserDefaults.standard.setValue(false, forKey: Strings.isHomeVCLoadedKey)
            UserDefaults.standard.setValue(false, forKey: Strings.isNotificationVCLoadedKey)
            UserDefaults.standard.setValue(false, forKey: Strings.isAccountVCLoadedKey)
        } else if tabBar.selectedItem?.tag == 2 {
            UserDefaults.standard.setValue(true, forKey: Strings.notificationVCTappedKey)
            UserDefaults.standard.setValue(true, forKey: Strings.isNotificationVCLoadedKey)
            UserDefaults.standard.setValue(false, forKey: Strings.homeVCTappedKey)
            UserDefaults.standard.setValue(false, forKey: Strings.captureVCTappedKey)
            UserDefaults.standard.setValue(false, forKey: Strings.accountVCTappedKey)
            UserDefaults.standard.setValue(false, forKey: Strings.isHomeVCLoadedKey)
            UserDefaults.standard.setValue(false, forKey: Strings.isCaptureVCLoadedKey)
            UserDefaults.standard.setValue(false, forKey: Strings.isAccountVCLoadedKey)
        } else if tabBar.selectedItem?.tag == 3 {
            UserDefaults.standard.setValue(true, forKey: Strings.accountVCTappedKey)
            UserDefaults.standard.setValue(true, forKey: Strings.isAccountVCLoadedKey)
            UserDefaults.standard.setValue(false, forKey: Strings.homeVCTappedKey)
            UserDefaults.standard.setValue(false, forKey: Strings.captureVCTappedKey)
            UserDefaults.standard.setValue(false, forKey: Strings.notificationVCTappedKey)
            UserDefaults.standard.setValue(false, forKey: Strings.isHomeVCLoadedKey)
            UserDefaults.standard.setValue(false, forKey: Strings.isCaptureVCLoadedKey)
            UserDefaults.standard.setValue(false, forKey: Strings.isNotificationVCLoadedKey)
        }
    }
    
}

