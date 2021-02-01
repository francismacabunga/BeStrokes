//
//  LoginViewController.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 11/3/20.
//

import UIKit

class LoginViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var loginNavigationBar: UINavigationBar!
    @IBOutlet weak var loginContentView: UIView!
    @IBOutlet weak var loginHeadingStackView: UIStackView!
    @IBOutlet weak var loginTextFieldsStackView: UIStackView!
    @IBOutlet weak var loginForgotPasswordButtonStackView: UIStackView!
    @IBOutlet weak var loginForgotPasswordButtonSpacerView: UIView!
    @IBOutlet weak var loginHeadingLabel: UILabel!
    @IBOutlet weak var loginImageView: UIImageView!
    @IBOutlet weak var loginWarningLabel: UILabel!
    @IBOutlet weak var loginEmailTextField: UITextField!
    @IBOutlet weak var loginPasswordTextField: UITextField!
    @IBOutlet weak var loginForgotPasswordButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginLoadingIndicatorView: UIActivityIndicatorView!
    
    
    //MARK: - Constants / Variables
    
    private let user = User()
    
    
    //MARK: - View Controller Life Cyle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDesignElements()
        setDatasourceAndDelegate()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loginEmailTextField.becomeFirstResponder()
    }
    
    
    //MARK: - Design Elements
    
    func setDesignElements() {
        UIScrollView.appearance().indicatorStyle = .white
        loginWarningLabel.isHidden = true
        loginLoadingIndicatorView.isHidden = true
        Utilities.setDesignOn(view: view, backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        Utilities.setDesignOn(view: loginContentView, backgroundColor: .clear)
        Utilities.setDesignOn(stackView: loginHeadingStackView, backgroundColor: .clear)
        Utilities.setDesignOn(stackView: loginTextFieldsStackView, backgroundColor: .clear)
        Utilities.setDesignOn(stackView: loginForgotPasswordButtonStackView, backgroundColor: .clear)
        Utilities.setDesignOn(view: loginForgotPasswordButtonSpacerView, backgroundColor: .clear)
        Utilities.setDesignOn(navigationBar: loginNavigationBar, isDarkMode: false)
        Utilities.setDesignOn(label: loginHeadingLabel, font: Strings.defaultFontBold, fontSize: 35, fontColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), numberofLines: 0, textAlignment: .left, lineBreakMode: .byWordWrapping, text: Strings.loginHeadingText)
        Utilities.setDesignOn(imageView: loginImageView, image: UIImage(named: Strings.loginDefaultIcon), isCircular: true)
        Utilities.setDesignOn(textField: loginEmailTextField, font: Strings.defaultFont, fontSize: 15, autocorrectionType: .no, isSecureTextEntry: false, keyboardType: .emailAddress, textContentType: .emailAddress, textColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), backgroundColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), placeholder: Strings.emailTextField, placeholderTextColor: #colorLiteral(red: 0.5411764706, green: 0.5411764706, blue: 0.5411764706, alpha: 1), isCircular: true)
        Utilities.setDesignOn(textField: loginPasswordTextField, font: Strings.defaultFont, fontSize: 15, autocorrectionType: .no, isSecureTextEntry: true, keyboardType: .default, textContentType: .password, textColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), backgroundColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), placeholder: Strings.passwordTextField, placeholderTextColor: #colorLiteral(red: 0.5411764706, green: 0.5411764706, blue: 0.5411764706, alpha: 1), isCircular: true)
        Utilities.setDesignOn(button: loginForgotPasswordButton, title: Strings.forgotPasswordButtonText, font: Strings.defaultFontMedium, fontSize: 15, titleColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1))
        Utilities.setDesignOn(button: loginButton, title: Strings.loginButtonText, font: Strings.defaultFontBold, fontSize: 20, titleColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), backgroundColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), isCircular: true)
        Utilities.setDesignOn(activityIndicatorView: loginLoadingIndicatorView, size: .medium, backgroundColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1))
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
    
    func setLoginButtonTappedAnimation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [self] in
            loginButton.isHidden = true
            loginLoadingIndicatorView.isHidden = false
            loginLoadingIndicatorView.startAnimating()
        }
    }
    
    func setLoginButtonToOriginalDesign() {
        loginLoadingIndicatorView.isHidden = true
        loginButton.isHidden = false
    }
    
    func dismissKeyboard() {
        loginEmailTextField.endEditing(true)
        loginPasswordTextField.endEditing(true)
    }
    
    func transitionToHomeVC() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
            let storyboard = UIStoryboard(name: Strings.userStoryboard, bundle: nil)
            let homeVC = storyboard.instantiateViewController(identifier: Strings.tabBarVC)
            view.window?.rootViewController = homeVC
            view.window?.makeKeyAndVisible()
        }
    }
    
    
    //MARK: - Buttons
    
    @IBAction func loginButton(_ sender: UIButton) {
        Utilities.animateButton(button: sender)
        setLoginButtonTappedAnimation()
        processLogin()
        dismissKeyboard()
    }
    
    
    //MARK: - Login Process
    
    func setDatasourceAndDelegate() {
        loginEmailTextField.delegate = self
        loginPasswordTextField.delegate = self
    }
    
    func processLogin() {
        if let email = loginEmailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), let password = loginPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
            user.signInUser(with: email, password) { [self] (error, authResult) in
                if error != nil {
                    showWarningLabel(on: loginWarningLabel, with: error!, isASuccessMessage: false)
                    setLoginButtonToOriginalDesign()
                    return
                }
                UIView.animate(withDuration: 0.2) {
                    loginWarningLabel.isHidden = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    setLoginButtonToOriginalDesign()
                    transitionToHomeVC()
                }
            }
        }
    }
    
}


//MARK: - Text Field Delegate

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        processLogin()
        dismissKeyboard()
        return true
    }
    
}
