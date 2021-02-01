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
    
    @IBOutlet weak var landingSignupStackView: UIStackView!
    @IBOutlet weak var landingSignUpLabel: UILabel!
    @IBOutlet weak var landingSignUpButton: UIButton!
    @IBOutlet weak var landingLoginButton: UIButton!
    @IBOutlet weak var landingGetStartedButton: UIButton!
    @IBOutlet weak var landingPageControl: UIPageControl!
    @IBAction func unwindToLandingVC(segue: UIStoryboardSegue) {}
    
    
    //MARK: - Constants / Variables
    
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
        Utilities.setDesignOn(stackView: landingSignupStackView, backgroundColor: .clear)
        Utilities.setDesignOn(button: landingGetStartedButton, title: Strings.getStartedButtonText, font: Strings.defaultFontBold, fontSize: 20, titleColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), isCircular: true)
        Utilities.setDesignOn(button: landingLoginButton, title: Strings.loginButtonText, font: Strings.defaultFontBold, fontSize: 20, titleColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), isCircular: true)
        Utilities.setDesignOn(button: landingSignUpButton, title: Strings.signUpButtonText, font: Strings.defaultFontBold, fontSize: 13, titleColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        Utilities.setDesignOn(label: landingSignUpLabel, font: Strings.defaultFontMedium, fontSize: 13, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), numberofLines: 1, text: Strings.landingSignupText)
        Utilities.setDesign(pageControl: landingPageControl, pageIndicatorColor: #colorLiteral(red: 0.8, green: 0.8039215686, blue: 0.8196078431, alpha: 1), currentPageColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    func showInvalidUserAlert(using errorMessage: String?) {
        let alert = UIAlertController(title: errorMessage, message: Strings.landingAlertMessage, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: Strings.landingAlertAction, style: .cancel, handler: nil)
        alert.addAction(dismissAction)
        present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let landingPageVC = segue.destination as? LandingPageViewController {
            landingPageVC.landingPageVCDelegate = self
        }
    }
    
    func transitionToHomeVC() {
        let storyboard = UIStoryboard(name: Strings.userStoryboard, bundle: nil)
        let homeVC = storyboard.instantiateViewController(identifier: Strings.tabBarVC)
        self.view.window?.rootViewController = homeVC
        self.view.window?.makeKeyAndVisible()
    }
    
    
    //MARK: - Checking of Signed In User Process
    
    func checkIfUserIsSignedIn() {
        user.checkIfUserIsSignedIn { [self] (authErrorCode, isUserSignedIn, isUserInvalid) in
            if isUserSignedIn {
                print("User is signed in!")
                guard let authErrorCode = authErrorCode else {
                    print("Valid Token!")
                    transitionToHomeVC()
                    return
                }
                print("Invalid user!")
                switch authErrorCode {
                case .invalidCredential: showInvalidUserAlert(using: Strings.landingInvalidCErrorAlertTitle)
                case .invalidUserToken: showInvalidUserAlert(using: Strings.landingInvalidUTErrorAlertTitle)
                case .invalidCustomToken: showInvalidUserAlert(using: Strings.landingInvalidCTErrorAlertTitle)
                case .userTokenExpired: showInvalidUserAlert(using: Strings.landingUserTEErrorAlertTitle)
                case .userDisabled: showInvalidUserAlert(using: Strings.landingUserDErrorAlertTitle)
                case .userNotFound: showInvalidUserAlert(using: Strings.landingUserNFErrorAlertTitle)
                case .customTokenMismatch: showInvalidUserAlert(using: Strings.landingCustomTMErrorAlertTitle)
                default: showInvalidUserAlert(using: Strings.landingCallDErrorAlertTitle)
                }
            }
            print("User is not signed in!")
        }
    }
    
    
    //MARK: - Buttons
    
    @IBAction func getStartedButton(_ sender: UIButton) {
        Utilities.animateButton(button: sender)
    }
    
}


//MARK: - Landing Page View Controller Delegate

extension LandingViewController: LandingPageVCDelegate {
    
    func getValueOf(_ index: Int) {
        landingPageControl.currentPage = index
    }
    
}
