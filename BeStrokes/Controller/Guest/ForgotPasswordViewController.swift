//
//  ForgotPasswordController.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 11/3/20.
//

import UIKit
import Firebase

class ForgotPasswordViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var subHeadingLabel: UILabel!
    @IBOutlet weak var validationMessage: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var dismissButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        designElements()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        emailTextField.becomeFirstResponder()
        
    }
    
    func designElements() {
        
        dismissButton.isHidden = true
        dismissButton.alpha = 0
        validationMessage.isHidden = true
        UIScrollView.appearance().indicatorStyle = .white
        
//        Utilities.putDesignOn(whitePopupHeadingLabel: headingLabel)
        Utilities.putDesignOn(whitePopupSubheadingLabel: subHeadingLabel)
//        Utilities.putDesignOn(errorLabel: validationMessage)
//        Utilities.putDesignOn(textField: emailTextField, placeholder: Strings.emailPlaceholder)
        Utilities.putDesignOn(whiteButton: submitButton)
        Utilities.putDesignOn(whiteButton: dismissButton)
        
    }
    
    @IBAction func submitButton(_ sender: UIButton) {
        
        Utilities.animateButton(button: sender)
        emailTextField.endEditing(true)
        processForgotPassword()
        
    }
    
    @IBAction func dismissButton(_ sender: UIButton) {
        
        Utilities.animateButton(button: sender)
        performSegue(withIdentifier: Strings.unwindToLandingSegue, sender: self)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        emailTextField.endEditing(true)
        processForgotPassword()
        return true
        
    }
    
    func processForgotPassword() {
        
        if let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)  {
            
            Auth.auth().sendPasswordReset(withEmail: email) { [self] (error) in
                if error != nil {
                    
                    Utilities.showAnimatedError(on: validationMessage, withError: error, withCustomizedString: nil)
                    
                } else {
                    
                    Utilities.showAnimatedResetPasswordSuccessMessage(validationLabel: validationMessage)
                    
                    // Animation
                    UIView.animate(withDuration: 0.3) {
                        submitButton.alpha = 0
                    }
                    submitButton.isHidden = true
                    dismissButton.isHidden = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        UIView.animate(withDuration: 0.2) {
                            dismissButton.alpha = 1
                        }
                    }
                }
            }
        }
    }
    
}
