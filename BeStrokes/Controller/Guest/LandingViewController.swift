//
//  LandingViewController.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 11/10/20.
//

import UIKit

class LandingViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var landingSignupStackView: UIStackView!
    @IBOutlet weak var landingPageControl: UIPageControl!
    @IBOutlet weak var landingGetStartedButton: UIButton!
    @IBOutlet weak var landingLoginButton: UIButton!
    @IBOutlet weak var landingSignUpButton: UIButton!
    @IBOutlet weak var landingSignUpLabel: UILabel!
    @IBAction func unwindToLandingVC(segue: UIStoryboardSegue) {}
    
    
    //MARK: - Constants / Variables
    
    private let landingPageViewModel = LandingPageViewModel()
    
    
    //MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDesignElements()
        landingPageViewModel.resetTabKeysValues()
        
    }
    
    
    //MARK: - Design Elements
    
    func setDesignElements() {
        Utilities.setDesignOn(view: view, backgroundColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1))
        Utilities.setDesignOn(stackView: landingSignupStackView, backgroundColor: .clear)
        Utilities.setDesignOn(button: landingGetStartedButton, title: Strings.getStartedButtonText, fontName: Strings.defaultFontBold, fontSize: 20, titleColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), isCircular: true)
        Utilities.setDesignOn(button: landingLoginButton, title: Strings.loginButtonText, fontName: Strings.defaultFontBold, fontSize: 20, titleColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), isCircular: true)
        Utilities.setDesignOn(button: landingSignUpButton, title: Strings.signUpButtonText, fontName: Strings.defaultFontBold, fontSize: 13, titleColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        Utilities.setDesignOn(label: landingSignUpLabel, fontName: Strings.defaultFontMedium, fontSize: 13, numberofLines: 1, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), text: Strings.landingSignupText)
        Utilities.setDesignOn(pageControl: landingPageControl, pageIndicatorColor: #colorLiteral(red: 0.8, green: 0.8039215686, blue: 0.8196078431, alpha: 1), currentPageColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let landingPageVC = segue.destination as? LandingPageViewController {
            landingPageVC.landingPageVCDelegate = self
        }
    }
    
    
    //MARK: - Buttons
    
    @IBAction func getStartedButton(_ sender: UIButton) {
        Utilities.animate(button: sender)
        let captureVC = landingPageViewModel.captureVC()
        present(captureVC, animated: true)
    }
    
}


//MARK: - Landing Page View Controller Delegate

extension LandingViewController: LandingPageVCDelegate {
    
    func getValueOf(_ index: Int) {
        landingPageControl.currentPage = index
    }
    
}
