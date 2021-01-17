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
    
//    private var landingPageViewController = LandingPageViewController()
    private var alertControllerErrorMessage: String?
    private var user: User?
    
    
    //MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDesignElements()
        showError()
//        landingPageViewController.LandingPageViewControllerDelegate = self
        
        
    }
    
    func setDesignElements() {
        landingPageControl.backgroundColor = .black
        Utilities.setDesignOn(view: view, backgroundColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1))
        Utilities.setDesignOn(button: landingGetStartedButton, title: Strings.getStartedButtonText, font: Strings.defaultFontBold, fontSize: 20, titleColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), isCircular: true)
        Utilities.setDesignOn(button: landingLoginButton, title: Strings.loginButtonText, font: Strings.defaultFontBold, fontSize: 20, titleColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), isCircular: true)
        Utilities.setDesignOn(button: landingSignUpButton, title: Strings.signUpButtonText, font: Strings.defaultFontBold, fontSize: 13, titleColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        Utilities.setDesignOn(label: landingSignUpLabel, font: Strings.defaultFontMedium, fontSize: 13, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), numberofLines: 1, text: Strings.landingSignupText)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }



    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if let embeddedController = segue.destination as? LandingPageViewController {
            // This is done because the UIView is embedded to the LandingPageViewController, this enables you to get access of the properties LandingPageViewController page has
//            landingPageViewController = embeddedController
        }

    }
    
    
        @IBAction func getStartedButton(_ sender: UIButton) {
            Utilities.animateButton(button: sender)
        }
    
        @IBAction func loginButton(_ sender: UIButton) {
            Utilities.animateButton(button: sender)
        }
    
        @IBAction func signUpButton(_ sender: UIButton) {
            Utilities.animateButton(button: sender)
        }
    
    func showError() {

//        user!.checkIfUserIsSignedIn { [self] (authErrorCode) in
//
//            if authErrorCode != nil {
//                switch authErrorCode! {
//                case .invalidCredential: showAlert(with: Strings.invalidCErrorMessage)
//                case .invalidUserToken: showAlert(with: Strings.invalidUTErrorMessage)
//                case .invalidCustomToken: showAlert(with: Strings.invalidCTErrorMessage)
//                case .userTokenExpired: showAlert(with: Strings.userTEErrorMessage)
//                case .userDisabled: showAlert(with: Strings.userDErrorMessage)
//                case .userNotFound: showAlert(with: Strings.userNFErrorMessage)
//                case .customTokenMismatch: showAlert(with: Strings.customTMErrorMessage)
//                default: showAlert(with: Strings.callDErrorMessage)
//                }
//            } else {
//                // Redirect to home screen!
//                let HomeViewController =  Utilities.transitionTo(storyboardName: Strings.userStoryboard, identifier: Strings.tabBarStoryboardID)
//                view.window?.rootViewController = HomeViewController
//                view.window?.makeKeyAndVisible()
//            }
//
//
//
//        }

//                guard let user = Auth.auth().currentUser else {
//                    return
//                }
//                if user == nil {
//                    print("The user is not signed in!")
//                } else {
//                    print("The user is signed in!")
//                    user.reload { [self] (error) in
//                        if error != nil {
//                            if let err = error as NSError? {
//                                if let error = AuthErrorCode(rawValue: err.code) {
//                                    switch error {
//                                    case .invalidCredential: showAlert(with: Strings.invalidCErrorMessage)
//                                    case .invalidUserToken: showAlert(with: Strings.invalidUTErrorMessage)
//                                    case .invalidCustomToken: showAlert(with: Strings.invalidCTErrorMessage)
//                                    case .userTokenExpired: showAlert(with: Strings.userTEErrorMessage)
//                                    case .userDisabled: showAlert(with: Strings.userDErrorMessage)
//                                    case .userNotFound: showAlert(with: Strings.userNFErrorMessage)
//                                    case .customTokenMismatch: showAlert(with: Strings.customTMErrorMessage)
//                                    default: showAlert(with: Strings.callDErrorMessage)
//                                    }
//                                }
//                            }
//                        } else {
//                            print("Valid Token")
//
//                            // Redirect to home screen!
//                            let HomeViewController =  Utilities.transitionTo(storyboardName: Strings.userStoryboard, identifier: Strings.tabBarStoryboardID)
//                            view.window?.rootViewController = HomeViewController
//                            view.window?.makeKeyAndVisible()
//
//                        }
//                    }
//                }


    }
    
    func showAlert(with errorMessage: String?) {

        let alertController = UIAlertController(title: errorMessage, message: Strings.alertControllerMessage, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: Strings.alertActionMessage, style: .cancel, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)

    }
    
}


extension LandingViewController: LandingPageViewControllerDelegate {
    func getValueOf(_ index: Int) {
        landingPageControl.currentPage = index
    }


}
