//
//  PageViewController.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 11/8/20.
//

import UIKit

class PageViewController: UIPageViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        
        if let showFirstController = listOfViewControllers.first {
            setViewControllers([showFirstController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
        

    }
    
     lazy var listOfViewControllers: [UIViewController] = {
        return [storyboardID(named: "firstSB"),
                storyboardID(named: "secondSB")]
     }()
    
    
    func storyboardID(named sbID: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: sbID)
    }
    
}




extension PageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        // We are getting the first controller out of the array
        guard let viewControllerIndex = listOfViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return listOfViewControllers.last
            //return nil
        }
        
        guard listOfViewControllers.count > previousIndex else {
            return nil
        }
        
        return listOfViewControllers[previousIndex]
        
    }
    
    
    
    
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = listOfViewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let afterIndex = viewControllerIndex + 1
        
        // Part where either you can loop the controllers or once it reached the end then its just not gonna go anymore
        guard listOfViewControllers.count > afterIndex else {
            return listOfViewControllers.first
//            return nil
        }
        

        
        return listOfViewControllers[afterIndex]
        
    }
    
}









