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
        NotificationCenter.default.addObserver(self, selector: #selector(setBadgeCounter), name: Utilities.setBadgeToAccountIcon, object: nil)
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
    
    @objc func setBadgeCounter() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [self] in
            userTabBarItem[2].badgeValue = "\(UserDefaults.standard.integer(forKey: Strings.notificationBadgeCounterKey))"
        }
    }
    
    func setIconData() {
        userTabBarItem[0].image = UIImage(systemName: Strings.tabHomeIcon)
        userTabBarItem[1].image = UIImage(systemName: Strings.tabCaptureIcon)
        userTabBarItem[2].image = UIImage(systemName: Strings.tabNotificationIcon)
        userTabBarItem[3].image = UIImage(systemName: Strings.tabAccountIcon)
        if UserDefaults.standard.integer(forKey: Strings.notificationBadgeCounterKey) != 0 {
            userTabBarItem[2].badgeValue = "\(UserDefaults.standard.integer(forKey: Strings.notificationBadgeCounterKey))"
        }
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
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if tabBar.selectedItem?.badgeValue != nil {
            userTabBarItem[2].badgeValue = nil
            UserDefaults.standard.removeObject(forKey: Strings.notificationBadgeCounterKey)
        }
    }
    
}

