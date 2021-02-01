//
//  TabBarViewController.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 12/9/20.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    //MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UITabBar.appearance().barTintColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1)
        UITabBar.appearance().tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        guard let items = tabBar.items else {return}
        items[0].title = Strings.homeTabText
        items[0].image = UIImage(systemName: Strings.tabHomeIcon)
        items[1].title = Strings.captureTabText
        items[1].image = UIImage(systemName: Strings.tabCaptureIcon)
        items[2].title = Strings.accountTabText
        items[2].image = UIImage(systemName: Strings.tabAccountIcon)
        
    }
    
}
