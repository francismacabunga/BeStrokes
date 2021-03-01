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
    private var items = [UITabBarItem]()
    
    
    //MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userTabBar = self.tabBar
        items = (userTabBar?.items)!
        self.delegate = self
        setDesignElements()
        setIconData()
        
    }
    
    
    //MARK: - Design Elements
    
    func setDesignElements() {
        NotificationCenter.default.addObserver(self, selector: #selector(setLightMode), name: Utilities.setLightModeAppearance, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setDarkMode), name: Utilities.setDarkModeAppearance, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setBadge), name: Utilities.setBadgeToAccountIcon, object: nil)
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
    
    @objc func setBadge() {
        print("Change icon color to red!")
    }
    
    func setIconData() {
        items[0].title = Strings.homeTabText
        items[0].image = UIImage(systemName: Strings.tabHomeIcon)
        items[1].title = Strings.captureTabText
        items[1].image = UIImage(systemName: Strings.tabCaptureIcon)
        items[2].title = Strings.accountTabText
        items[2].image = UIImage(systemName: Strings.tabAccountIcon)
    }
    
}


//MARK: - Tab Bar Controller Delegate

extension TabBarViewController: UITabBarControllerDelegate {
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print("Im selected!")
    }
    
}

