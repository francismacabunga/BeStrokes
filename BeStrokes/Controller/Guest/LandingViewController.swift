//
//  LandingViewController.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 11/10/20.
//

import UIKit
import Firebase

class LandingViewController: UIViewController, LandingPageViewControllerDelegate {
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var getStartedButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpLabel: UILabel!
    @IBOutlet weak var signUpButton: UIButton!
    @IBAction func unwindToVC1(segue:UIStoryboardSegue) { }
    
    var landingPageViewController = LandingPageViewController()
    var alertControllerErrorMessage: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showError()
        landingPageViewController.LandingPageViewControllerDelegate = self
        designElements()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    func designElements() {
        
        Utilities.putDesignOn(landingButton: getStartedButton)
        Utilities.putDesignOn(landingButton: loginButton)
        Utilities.putDesignOn(signUpLabel: signUpLabel)
        Utilities.putDesignOn(signUpButton: signUpButton)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let embeddedController = segue.destination as? LandingPageViewController {
            // This is done because the UIView is embedded to the LandingPageViewController, this enables you to get access of the properties LandingPageViewController page has
            landingPageViewController = embeddedController
        }
        
    }
    
    func getValueOfCurrent(index: Int) {
        pageControl.currentPage = index
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
        
        guard let user = Auth.auth().currentUser else {
            return
        }
        if user == nil {
            print("The user is not signed in!")
        } else {
            print("The user is signed in!")
            user.reload { [self] (error) in
                if error != nil {
                    if let err = error as NSError? {
                        if let error = AuthErrorCode(rawValue: err.code) {
                            switch error {
                            case .invalidCredential: showAlert(with: Strings.invalidCErrorMessage)
                            case .invalidUserToken: showAlert(with: Strings.invalidUTErrorMessage)
                            case .invalidCustomToken: showAlert(with: Strings.invalidCTErrorMessage)
                            case .userTokenExpired: showAlert(with: Strings.userTEErrorMessage)
                            case .userDisabled: showAlert(with: Strings.userDErrorMessage)
                            case .userNotFound: showAlert(with: Strings.userNFErrorMessage)
                            case .customTokenMismatch: showAlert(with: Strings.customTMErrorMessage)
                            default: showAlert(with: Strings.callDErrorMessage)
                            }
                        }
                    }
                } else {
                    print("Valid Token")
                    
                    // Redirect to fucking home screen!
                    let HomeViewController =  Utilities.transitionTo(storyboardName: Strings.userStoryboard, identifier: Strings.tabBarStoryboardID)
                    view.window?.rootViewController = HomeViewController
                    view.window?.makeKeyAndVisible()
                    
                }
            }
        }
    }
    
    func showAlert(with errorMessage: String?) {
        
        let alertController = UIAlertController(title: errorMessage, message: Strings.alertControllerMessage, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: Strings.alertActionMessage, style: .cancel, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
        
    }
    
}
