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
    private let landingPageViewModel = LandingPageViewModel()
    
    
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
        if let vc = landingPageViewModel.landingPageContentVC(at: 0) {
            setViewControllers([vc], direction: .forward, animated: true)
        }
    }
    
    
    //MARK: - Data Source And Delegate
    
    func setDatasourceAndDelegate() {
        dataSource = self
        delegate = self
    }
    
}


//MARK: - Page View Controller Data Source

extension LandingPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = (viewController as! LandingPageContentViewController).index
        let newIndex = landingPageViewModel.minusOneTo(index)
        return landingPageViewModel.landingPageContentVC(at: newIndex)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = (viewController as! LandingPageContentViewController).index
        let newIndex = landingPageViewModel.plusOneTo(index)
        return landingPageViewModel.landingPageContentVC(at: newIndex)
    }
    
}


//MARK: - Page View Controller Delegate

extension LandingPageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            let pageIndex = pageViewController.viewControllers?.first as! LandingPageContentViewController
            landingPageVCDelegate?.getValueOf(pageIndex.index)
        }
    }
    
}


//MARK: - Protocols

protocol LandingPageVCDelegate: AnyObject {
    func getValueOf(_ index: Int)
}
