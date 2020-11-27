//
//  LoginController.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 11/3/20.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        designElements()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        emailTextField.becomeFirstResponder()
        
    }
    
    func designElements() {
        
        errorLabel.isHidden = true
        UIScrollView.appearance().indicatorStyle = .white
        
        Utilities.putDesignOn(whitePopupHeadingLabel: headingLabel)
        Utilities.putDesignOn(errorLabel: errorLabel)
        Utilities.putDesignOn(textField: emailTextField, placeholder: Strings.emailPlaceholder)
        Utilities.putDesignOn(textField: passwordTextField, placeholder: Strings.passwordPlaceholder)
        Utilities.putDesignOn(forgotPasswordButton: forgotPasswordButton)
        Utilities.putDesignOn(whiteButton: loginButton)
        
    }
    
    @IBAction func forgotPasswordButton(_ sender: UIButton) {
        
        Utilities.animateButton(button: sender)
        
    }
    
    @IBAction func loginButton(_ sender: UIButton) {
        
        Utilities.animateButton(button: sender)
        emailTextField.endEditing(true)
        passwordTextField.endEditing(true)
        processLogin()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        emailTextField.endEditing(true)
        passwordTextField.endEditing(true)
        processLogin()
        return true
        
    }
    
    func processLogin() {
        
        if let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
            
            Auth.auth().signIn(withEmail: email, password: password) { [self] (authResult, error) in
                if error != nil {
                    
                    Utilities.showAnimatedError(on: errorLabel, withError: error, withCustomizedString: nil)
                    
                } else {
                    
                    print("The user entered the right credentials! Logging in...")
                    //Transition to Homescreen
                    let HomeViewController = Utilities.transitionTo(storyboardName: Strings.userStoryboard, identifier: Strings.tabBarStoryboardID)
                    view.window?.rootViewController = HomeViewController
                    view.window?.makeKeyAndVisible()
                    
                }
            }
        }
    }
    
}


