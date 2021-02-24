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
    @IBOutlet weak var loginScrollView: UIScrollView!
    @IBOutlet weak var loginContentView: UIView!
    @IBOutlet weak var loginHeadingStackView: UIStackView!
    @IBOutlet weak var loginImageContentView: UIView!
    @IBOutlet weak var loginTextFieldsStackView: UIStackView!
    @IBOutlet weak var loginForgotPasswordButtonStackView: UIStackView!
    @IBOutlet weak var loginForgotPasswordButtonSpacerView: UIView!
    @IBOutlet weak var loginHeadingLabel: UILabel!
    @IBOutlet weak var loginWarningLabel: UILabel!
    @IBOutlet weak var loginImageView: UIImageView!
    @IBOutlet weak var loginEmailTextField: UITextField!
    @IBOutlet weak var loginPasswordTextField: UITextField!
    @IBOutlet weak var loginForgotPasswordButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginLoadingIndicatorView: UIActivityIndicatorView!
    
    
    //MARK: - Constants / Variables
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
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
        Utilities.setDesignOn(view: loginContentView, backgroundColor: .clear)
        Utilities.setDesignOn(stackView: loginHeadingStackView, backgroundColor: .clear)
        Utilities.setDesignOn(view: loginImageContentView, backgroundColor: .clear, isCircular: true)
        Utilities.setDesignOn(stackView: loginTextFieldsStackView, backgroundColor: .clear)
        Utilities.setDesignOn(stackView: loginForgotPasswordButtonStackView, backgroundColor: .clear)
        Utilities.setDesignOn(view: loginForgotPasswordButtonSpacerView, backgroundColor: .clear)
        Utilities.setDesignOn(label: loginHeadingLabel, fontName: Strings.defaultFontBold, fontSize: 35, numberofLines: 0, textAlignment: .left, lineBreakMode: .byWordWrapping, text: Strings.loginHeadingText)
        Utilities.setDesignOn(label: loginWarningLabel, fontName: Strings.defaultFontBold, fontSize: 15, numberofLines: 0, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), isHidden: true)
        Utilities.setDesignOn(imageView: loginImageView, image: UIImage(named: Strings.loginDefaultImage), isCircular: true)
        Utilities.setDesignOn(textField: loginEmailTextField, fontName: Strings.defaultFont, fontSize: 15, autocorrectionType: .no, isSecureTextEntry: false, keyboardType: .emailAddress, textContentType: .emailAddress, placeholder: Strings.emailTextField, placeholderTextColor: #colorLiteral(red: 0.5411764706, green: 0.5411764706, blue: 0.5411764706, alpha: 1), isCircular: true)
        Utilities.setDesignOn(textField: loginPasswordTextField, fontName: Strings.defaultFont, fontSize: 15, autocorrectionType: .no, isSecureTextEntry: true, keyboardType: .default, textContentType: .password, placeholder: Strings.passwordTextField, placeholderTextColor: #colorLiteral(red: 0.5411764706, green: 0.5411764706, blue: 0.5411764706, alpha: 1), isCircular: true)
        Utilities.setDesignOn(button: loginForgotPasswordButton, title: Strings.forgotPasswordButtonText, fontName: Strings.defaultFontMedium, fontSize: 15)
        Utilities.setDesignOn(button: loginButton, title: Strings.loginButtonText, fontName: Strings.defaultFontBold, fontSize: 20, isCircular: true)
        Utilities.setDesignOn(activityIndicatorView: loginLoadingIndicatorView, size: .medium, isHidden: true)
        NotificationCenter.default.addObserver(self, selector: #selector(setLightMode), name: Utilities.setLightModeAppearance, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setDarkMode), name: Utilities.setDarkModeAppearance, object: nil)
        checkThemeAppearance()
    }
    
    func checkThemeAppearance() {
        if appDelegate.isLightModeOn {
            setLightMode()
        } else {
            setDarkMode()
        }
    }
    
    @objc func setLightMode() {
        loginScrollView.indicatorStyle = .black
        UIView.animate(withDuration: 0.3) { [self] in
            Utilities.setDesignOn(navigationBar: loginNavigationBar, isDarkMode: true)
            Utilities.setDesignOn(view: view, backgroundColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1))
            loginHeadingLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            Utilities.setDesignOn(button: loginForgotPasswordButton, titleColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
            Utilities.setDesignOn(button: loginButton, titleColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), backgroundColor: .white)
            Utilities.setDesignOn(textField: loginEmailTextField, textColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), backgroundColor: .white)
            Utilities.setDesignOn(textField: loginPasswordTextField, textColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), backgroundColor: .white)
            
            loginButton.layer.shadowColor = #colorLiteral(red: 0.6948884352, green: 0.6939979255, blue: 0.7095529112, alpha: 1)
            loginButton.layer.shadowOpacity = 1
            loginButton.layer.shadowOffset = .zero
            loginButton.layer.shadowRadius = 2
            loginButton.layer.masksToBounds = false
            
            loginEmailTextField.borderStyle = .none
            loginEmailTextField.layer.shadowOpacity = 1
            loginEmailTextField.layer.shadowRadius = 2
            loginEmailTextField.layer.shadowOffset = .zero
            loginEmailTextField.layer.shadowColor = #colorLiteral(red: 0.6948884352, green: 0.6939979255, blue: 0.7095529112, alpha: 1)
            
            loginPasswordTextField.borderStyle = .none
            loginPasswordTextField.layer.shadowOpacity = 1
            loginPasswordTextField.layer.shadowRadius = 2
            loginPasswordTextField.layer.shadowOffset = .zero
            loginPasswordTextField.layer.shadowColor = #colorLiteral(red: 0.6948884352, green: 0.6939979255, blue: 0.7095529112, alpha: 1)
            
            loginImageContentView.layer.shadowColor = #colorLiteral(red: 0.6948884352, green: 0.6939979255, blue: 0.7095529112, alpha: 1)
            loginImageContentView.layer.shadowOpacity = 1
            loginImageContentView.layer.shadowOffset = .zero
            loginImageContentView.layer.shadowRadius = 2
            loginImageContentView.layer.masksToBounds = false
            
            loginLoadingIndicatorView.color = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }
    
    @objc func setDarkMode() {
        loginScrollView.indicatorStyle = .white
        UIView.animate(withDuration: 0.3) { [self] in
            Utilities.setDesignOn(navigationBar: loginNavigationBar, isDarkMode: false)
            Utilities.setDesignOn(view: view, backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
            loginHeadingLabel.textColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1)
            Utilities.setDesignOn(button: loginForgotPasswordButton, titleColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1))
            Utilities.setDesignOn(button: loginButton, titleColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), backgroundColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1))
            Utilities.setDesignOn(textField: loginEmailTextField, textColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), backgroundColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1))
            Utilities.setDesignOn(textField: loginPasswordTextField, textColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), backgroundColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1))
            
            loginButton.layer.shadowColor = nil
            loginButton.layer.shadowOpacity = 0
            loginButton.layer.shadowOffset = .zero
            loginButton.layer.shadowRadius = 0
            loginButton.layer.masksToBounds = true
            
            loginEmailTextField.layer.shadowOpacity = 0
            loginEmailTextField.layer.shadowRadius = 0
            loginEmailTextField.layer.shadowOffset = .zero
            loginEmailTextField.layer.shadowColor = nil
            
            loginPasswordTextField.layer.shadowOpacity = 0
            loginPasswordTextField.layer.shadowRadius = 0
            loginPasswordTextField.layer.shadowOffset = .zero
            loginPasswordTextField.layer.shadowColor = nil
            
            loginImageContentView.layer.shadowColor = nil
            loginImageContentView.layer.shadowOpacity = 0
            loginImageContentView.layer.shadowOffset = .zero
            loginImageContentView.layer.shadowRadius = 0
            loginImageContentView.layer.masksToBounds = true
        
            loginLoadingIndicatorView.color = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1)
        }
    }
    
    func showWarningLabel(on label: UILabel, with error: Error? = nil, customizedWarning: String? = nil, isASuccessMessage: Bool) {
        if error != nil {
            label.text = error!.localizedDescription
        }
        if customizedWarning != nil {
            label.text = customizedWarning
        }
        if isASuccessMessage {
            Utilities.setDesignOn(label: label, fontName: Strings.defaultFontBold, fontSize: 15, numberofLines: 0, textAlignment: .center, lineBreakMode: .byWordWrapping, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), backgroundColor: #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1))
        } else {
            Utilities.setDesignOn(label: label, fontName: Strings.defaultFontBold, fontSize: 15, numberofLines: 0, textAlignment: .center, lineBreakMode: .byWordWrapping, fontColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), backgroundColor: #colorLiteral(red: 0.9673412442, green: 0.0823205933, blue: 0.006666854955, alpha: 1))
        }
        UIView.animate(withDuration: 0.2) {
            label.isHidden = false
        }
    }
    
    func removeWarningLabel() {
        UIView.animate(withDuration: 0.2) { [self] in
            loginWarningLabel.isHidden = true
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
        Utilities.animate(button: sender)
        processLogin()
        dismissKeyboard()
    }
    
    
    //MARK: - Login Process
    
    func setDatasourceAndDelegate() {
        loginEmailTextField.delegate = self
        loginPasswordTextField.delegate = self
    }
    
    func processLogin() {
        guard let email = loginEmailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {return}
        guard let password = loginPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {return}
        user.signInUser(with: email, password) { [self] (error, authResult) in
            guard let error = error else {
                removeWarningLabel()
                setLoginButtonTappedAnimation()
                loginSuccessful()
                return
            }
            showWarningLabel(on: loginWarningLabel, with: error, isASuccessMessage: false)
            setLoginButtonToOriginalDesign()
        }
    }
    
    func loginSuccessful() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [self] in
            setLoginButtonToOriginalDesign()
            transitionToHomeVC()
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
