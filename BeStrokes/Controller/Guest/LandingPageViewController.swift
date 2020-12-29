//
//  LandingPageViewController.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 11/10/20.
//

import UIKit

protocol LandingPageViewControllerDelegate {
    
    func getValueOfCurrent(index: Int)
    
}

class LandingPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var collectionOfImages = ["Lion",
                              "Shirt",
                              "Dancing"]
    var collectionOfHeadings = ["BeStrokes",
                                "Make it stick",
                                "Show it off"]
    var collectionOfSubheadings = ["Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer cursus odio a purus.",
                                   "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer cursus odio a purus.",
                                   "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer cursus odio a purus."]
    var currentIndex = 0
    var LandingPageViewControllerDelegate: LandingPageViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        if let firstContent = landingPageContentViewController(at: 0) {
            setViewControllers([firstContent], direction: .forward, animated: true, completion: nil)
        }
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! LandingPageContentViewController).index
        index -= 1
        return landingPageContentViewController(at: index)
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! LandingPageContentViewController).index
        index += 1
        return landingPageContentViewController(at: index)
        
    }
    
    func landingPageContentViewController(at index: Int) -> LandingPageContentViewController? {
        
        if index >= collectionOfHeadings.count || index < 0 {
            return nil
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let landingPageContentViewController = storyboard.instantiateViewController(withIdentifier: "LandingPageContentViewController") as? LandingPageContentViewController {
            
            landingPageContentViewController.imageFileName = collectionOfImages[index]
            landingPageContentViewController.headingLabelText = collectionOfHeadings[index]
            landingPageContentViewController.subheadingText = collectionOfSubheadings[index]
            landingPageContentViewController.index = index
            return landingPageContentViewController
            
        }
        
        return nil
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if completed {
            let pageIndex = pageViewController.viewControllers?.first as!LandingPageContentViewController
            currentIndex = pageIndex.index
            LandingPageViewControllerDelegate?.getValueOfCurrent(index: currentIndex)
        }
        
    }
    
}
