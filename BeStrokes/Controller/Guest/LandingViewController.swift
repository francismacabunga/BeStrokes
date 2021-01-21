//
//  LandingViewController.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 11/10/20.
//

import UIKit
import Firebase

class LandingViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var landingPageControl: UIPageControl!
    @IBOutlet weak var landingSignUpLabel: UILabel!
    @IBOutlet weak var landingSignUpButton: UIButton!
    @IBOutlet weak var landingGetStartedButton: UIButton!
    @IBOutlet weak var landingLoginButton: UIButton!
    @IBAction func unwindToLandingVC(segue: UIStoryboardSegue) {}
    
    
    //MARK: - Constants / Variables
    
    private var alertControllerErrorMessage: String?
    private lazy var user = User()
    
    
    //MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDesignElements()
        checkIfUserIsSignedIn()
        
    }
    
    
    //MARK: - Design Elements
    
    func setDesignElements() {
        Utilities.setDesignOn(view: view, backgroundColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1))
        Utilities.setDesignOn(button: landingGetStartedButton, title: Strings.getStartedButtonText, font: Strings.defaultFontBold, fontSize: 20, titleColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), isCircular: true)
        Utilities.setDesignOn(button: landingLoginButton, title: Strings.loginButtonText, font: Strings.defaultFontBold, fontSize: 20, titleColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), isCircular: true)
        Utilities.setDesignOn(button: landingSignUpButton, title: Strings.signUpButtonText, font: Strings.defaultFontBold, fontSize: 13, titleColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        Utilities.setDesignOn(label: landingSignUpLabel, font: Strings.defaultFontMedium, fontSize: 13, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), numberofLines: 1, text: Strings.landingSignupText)
        Utilities.setDesign(pageControl: landingPageControl, pageIndicatorColor: #colorLiteral(red: 0.8, green: 0.8039215686, blue: 0.8196078431, alpha: 1), currentPageColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    func showAlert(with errorMessage: String?) {
        let alert = UIAlertController(title: errorMessage, message: Strings.homeAlertMessage, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: Strings.homeAlertAction, style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let landingPageVC = segue.destination as? LandingPageViewController {
            landingPageVC.LandingPageViewControllerDelegate = self
        }
    }
    
    
    //MARK: - Checking of Signed In User Process
    
    func checkIfUserIsSignedIn() {
        user.checkIfUserIsSignedIn { [self] (authErrorCode, invalidUser) in
            if invalidUser {
                if authErrorCode != nil {
                    switch authErrorCode! {
                    case .invalidCredential: showAlert(with: Strings.homeInvalidCErrorAlertTitle)
                    case .invalidUserToken: showAlert(with: Strings.homeInvalidUTErrorAlertTitle)
                    case .invalidCustomToken: showAlert(with: Strings.homeInvalidCTErrorAlertTitle)
                    case .userTokenExpired: showAlert(with: Strings.homeUserTEErrorAlertTitle)
                    case .userDisabled: showAlert(with: Strings.homeUserDErrorAlertTitle)
                    case .userNotFound: showAlert(with: Strings.homeUserNFErrorAlertTitle)
                    case .customTokenMismatch: showAlert(with: Strings.homeCustomTMErrorAlertTitle)
                    default: showAlert(with: Strings.homeCallDErrorAlertTitle)
                    }
                }
            } else {
                let storyboard = UIStoryboard(name: Strings.userStoryboard, bundle: nil)
                let homeVC = storyboard.instantiateViewController(identifier: Strings.tabBarVC)
                self.view.window?.rootViewController = homeVC
                self.view.window?.makeKeyAndVisible()
            }
        }
    }
    
    
    //MARK: - Buttons
    
    @IBAction func getStartedButton(_ sender: UIButton) {
        Utilities.animateButton(button: sender)
    }
    
}


//MARK: - Landing Page View Controller Delegate

extension LandingViewController: LandingPageViewControllerDelegate {
    
    func getValueOf(_ index: Int) {
        landingPageControl.currentPage = index
    }
    
}
