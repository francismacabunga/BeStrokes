//
//  LandingPageViewController.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 11/10/20.
//

import UIKit

class LandingPageViewController: UIPageViewController {
    
    //MARK: - Constants / Variables
    
    weak var landingPageVCDelegate: LandingPageVCDelegate?
    private var currentIndex = 0
    private let landingPage = LandingPage()
    
    
    //MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDatasourceAndDelegate()
        setInitialVC()
        
    }
    
    
    //MARK: - Design Elements
    
    required init?(coder aDecoder: NSCoder) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    func setInitialVC() {
        if let firstContent = landingPageContentViewController(at: 0) {
            setViewControllers([firstContent], direction: .forward, animated: true, completion: nil)
        }
    }
    
    
    //MARK: - Page View Controller Process
    
    func setDatasourceAndDelegate() {
        dataSource = self
        delegate = self
    }
    
    func landingPageContentViewController(at index: Int) -> LandingPageContentViewController? {
        let images = landingPage.fetchData().imageArray
        let headings = landingPage.fetchData().headingArray
        let subheadings = landingPage.fetchData().subheadingArray
        let indexIsValid = landingPage.checkIfIndexIsValid(index: index, imagesCount: images.count)
        if !indexIsValid {
            return nil
        }
        let storyboard = UIStoryboard(name: Strings.guestStoryboard, bundle: nil)
        let landingPageContentViewController = storyboard.instantiateViewController(withIdentifier: Strings.landingPageContentVC) as! LandingPageContentViewController
        landingPageContentViewController.imageFileName = images[index]
        landingPageContentViewController.headingLabelText = headings[index]
        landingPageContentViewController.subheadingText = subheadings[index]
        landingPageContentViewController.index = index
        return landingPageContentViewController
    }
    
}


//MARK: - Page View Controller Data Source

extension LandingPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = (viewController as! LandingPageContentViewController).index
        let newIndex = landingPage.minusOneTo(index)
        return landingPageContentViewController(at: newIndex)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = (viewController as! LandingPageContentViewController).index
        let newIndex = landingPage.plusOneTo(index)
        return landingPageContentViewController(at: newIndex)
    }
    
}


//MARK: - Page View Controller Delegate

extension LandingPageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            let pageIndex = pageViewController.viewControllers?.first as! LandingPageContentViewController
            currentIndex = pageIndex.index
            landingPageVCDelegate?.getValueOf(currentIndex)
        }
    }
    
}


//MARK: - Protocols

protocol LandingPageVCDelegate: AnyObject {
    func getValueOf(_ index: Int)
}
