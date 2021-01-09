//
//  TabBarViewController.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 12/9/20.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UITabBar.appearance().barTintColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1)
        UITabBar.appearance().tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        if let items = tabBar.items {
            items[0].title = Strings.homeTab
            items[0].image = UIImage(systemName: Strings.tabHomeIcon)
            items[1].title = Strings.captureTab
            items[1].image = UIImage(systemName: Strings.tabCaptureIcon)
            items[2].title = Strings.accountTab
            items[2].image = UIImage(systemName: Strings.tabAccountIcon)
        }
        
    }
    
}
