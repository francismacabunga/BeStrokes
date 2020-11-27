//
//  TestViewController.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 11/8/20.
//

import UIKit

class TestViewController: UIViewController, UIPageViewController, UIPageViewControllerDataSource {
    
    
    
    @IBOutlet weak var contentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        <#code#>
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        <#code#>
    }
    
    

    

}
