//
//  ForgotPasswordViewController.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 11/3/20.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var forgotPasswordNavigationBar: UINavigationBar!
    @IBOutlet weak var forgotPasswordContentView: UIView!
    @IBOutlet weak var forgotPasswordHeadingsStackView: UIStackView!
    @IBOutlet weak var forgotPasswordTextFieldStackView: UIStackView!
    @IBOutlet weak var forgotPasswordImageView: UIImageView!
    @IBOutlet weak var forgotPasswordHeadingLabel: UILabel!
    @IBOutlet weak var forgotPasswordSubheadingLabel: UILabel!
    @IBOutlet weak var forgotPasswordWarningLabel: UILabel!
    @IBOutlet weak var forgotPasswordEmailTextField: UITextField!
    @IBOutlet weak var forgotPasswordSubmitButton: UIButton!
    @IBOutlet weak var forgotPasswordDismissButton: UIButton!
    
    
    //MARK: - Constants / Variables
    
    private let user = User()
    
    
    //MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDesignElements()
        setDatasourceAndDelegate()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        forgotPasswordEmailTextField.becomeFirstResponder()
    }
    
    
    //MARK: - Design Elements
    
    func setDesignElements() {
        UIScrollView.appearance().indicatorStyle = .white
        Utilities.setDesignOn(view: view, backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        Utilities.setDesignOn(view: forgotPasswordContentView, backgroundColor: .clear)
        Utilities.setDesignOn(stackView: forgotPasswordHeadingsStackView, backgroundColor: .clear)
        Utilities.setDesignOn(stackView: forgotPasswordTextFieldStackView, backgroundColor: .clear)
        Utilities.setDesignOn(navigationBar: forgotPasswordNavigationBar, isDarkMode: false)
        Utilities.setDesignOn(imageView: forgotPasswordImageView, image: UIImage(named: Strings.forgotPasswordBackgroundImage), alpha: 0.3)
        Utilities.setDesignOn(label: forgotPasswordHeadingLabel, font: Strings.defaultFontBold, fontSize: 35, fontColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), numberofLines: 0, textAlignment: .left, lineBreakMode: .byWordWrapping, text: Strings.forgotPasswordHeadingText)
        Utilities.setDesignOn(label: forgotPasswordSubheadingLabel, font: Strings.defaultFontMedium, fontSize: 17, fontColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), numberofLines: 0, textAlignment: .left, lineBreakMode: .byWordWrapping, text: Strings.forgotPasswordSubheadingText)
        Utilities.setDesignOn(label: forgotPasswordWarningLabel, font: Strings.defaultFontBold, fontSize: 15, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), numberofLines: 0, isHidden: true)
        Utilities.setDesignOn(textField: forgotPasswordEmailTextField, font: Strings.defaultFont, fontSize: 15, autocorrectionType: .no, isSecureTextEntry: false, keyboardType: .emailAddress, textContentType: .emailAddress, textColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), backgroundColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), placeholder: Strings.emailTextField, placeholderTextColor: #colorLiteral(red: 0.5411764706, green: 0.5411764706, blue: 0.5411764706, alpha: 1), isCircular: true)
        Utilities.setDesignOn(button: forgotPasswordSubmitButton, title: Strings.submitButtonText, font: Strings.defaultFontBold, fontSize: 20, titleColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), backgroundColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), isCircular: true)
        Utilities.setDesignOn(button: forgotPasswordDismissButton, title: Strings.dismissButtonText, font: Strings.defaultFontBold, fontSize: 20, titleColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), backgroundColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), isCircular: true, isHidden: true)
    }
    
    func showWarningLabel(on label: UILabel, with error: Error? = nil, customizedWarning: String? = nil, isASuccessMessage: Bool) {
        if error != nil {
            label.text = error!.localizedDescription
        }
        if customizedWarning != nil {
            label.text = customizedWarning
        }
        if isASuccessMessage {
            Utilities.setDesignOn(label: label, font: Strings.defaultFontBold, fontSize: 15, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), numberofLines: 0, textAlignment: .center, lineBreakMode: .byWordWrapping, backgroundColor: #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1))
        } else {
            Utilities.setDesignOn(label: label, font: Strings.defaultFontBold, fontSize: 15, fontColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), numberofLines: 0, textAlignment: .center, lineBreakMode: .byWordWrapping, backgroundColor: #colorLiteral(red: 0.9673412442, green: 0.0823205933, blue: 0.006666854955, alpha: 1))
        }
        UIView.animate(withDuration: 0.2) {
            label.isHidden = false
        }
    }
    
    func showDismissButton() {
        UIView.animate(withDuration: 0.3) { [self] in
            forgotPasswordSubmitButton.isHidden = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            UIView.animate(withDuration: 0.2) { [self] in
                forgotPasswordDismissButton.isHidden = false
            }
        }
    }
    
    func dismissKeyboard() {
        forgotPasswordEmailTextField.endEditing(true)
    }
    
    
    //MARK: - Buttons
    
    @IBAction func forgotPasswordSubmitButton(_ sender: UIButton) {
        Utilities.animate(button: sender)
        processForgotPassword()
        dismissKeyboard()
    }
    
    @IBAction func forgotPasswordDismissButton(_ sender: UIButton) {
        Utilities.animate(button: sender)
        performSegue(withIdentifier: Strings.unwindToLandingVC, sender: self)
    }
    
    
    //MARK: - Forgot Password Process
    
    func setDatasourceAndDelegate() {
        forgotPasswordEmailTextField.delegate = self
    }
    
    func processForgotPassword() {
        guard let email = forgotPasswordEmailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {return}
        user.forgotPassword(with: email) { [self] (error, isPasswordResetSent) in
            guard let error = error else {
                if isPasswordResetSent {
                    showWarningLabel(on: forgotPasswordWarningLabel, customizedWarning: Strings.forgotPasswordProcessSuccessfulLabel, isASuccessMessage: true)
                    showDismissButton()
                }
                return
            }
            showWarningLabel(on: forgotPasswordWarningLabel, with: error, isASuccessMessage: false)
        }
    }
    
}


//MARK: - Text Field Delegate

extension ForgotPasswordViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        forgotPasswordEmailTextField.endEditing(true)
        processForgotPassword()
        return true
    }
    
}
