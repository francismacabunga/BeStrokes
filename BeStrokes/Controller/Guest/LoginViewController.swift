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
    @IBOutlet weak var loginImageContentView: UIView!
    @IBOutlet weak var loginForgotPasswordButtonSpacerView: UIView!
    @IBOutlet weak var loginHeadingStackView: UIStackView!
    @IBOutlet weak var loginTextFieldsStackView: UIStackView!
    @IBOutlet weak var loginForgotPasswordButtonStackView: UIStackView!
    @IBOutlet weak var loginHeadingLabel: UILabel!
    @IBOutlet weak var loginWarningLabel: UILabel!
    @IBOutlet weak var loginImageView: UIImageView!
    @IBOutlet weak var loginEmailTextField: UITextField!
    @IBOutlet weak var loginPasswordTextField: UITextField!
    @IBOutlet weak var loginForgotPasswordButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginLoadingIndicatorView: UIActivityIndicatorView!
    
    
    //MARK: - Constants / Variables
    
    private let service = Firebase()
    private let loginViewModel = LoginViewModel()
    
    
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
        Utilities.setDesignOn(scrollView: loginScrollView, keyboardDismissMode: .onDrag)
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
        Utilities.setDesignOn(activityIndicatorView: loginLoadingIndicatorView, size: .medium, isStartAnimating: false, isHidden: true)
        NotificationCenter.default.addObserver(self, selector: #selector(setLightMode), name: Utilities.setLightModeAppearance, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setDarkMode), name: Utilities.setDarkModeAppearance, object: nil)
        checkThemeAppearance()
    }
    
    func checkThemeAppearance() {
        if UserDefaults.standard.bool(forKey: Strings.lightModeKey) {
            setLightMode()
        } else {
            setDarkMode()
        }
    }
    
    @objc func setLightMode() {
        UIView.animate(withDuration: 0.3) { [self] in
            Utilities.setDesignOn(scrollView: loginScrollView, indicatorColor: .black)
            Utilities.setDesignOn(navigationBar: loginNavigationBar, isDarkMode: true)
            Utilities.setDesignOn(view: view, backgroundColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1))
            Utilities.setDesignOn(label: loginHeadingLabel, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
            Utilities.setDesignOn(button: loginForgotPasswordButton, titleColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
            Utilities.setDesignOn(button: loginButton, titleColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), backgroundColor: .white)
            Utilities.setDesignOn(textField: loginEmailTextField, textColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), backgroundColor: .white)
            Utilities.setDesignOn(textField: loginPasswordTextField, textColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), backgroundColor: .white)
            Utilities.setShadowOn(view: loginImageContentView, isHidden: false, shadowColor: #colorLiteral(red: 0.6948884352, green: 0.6939979255, blue: 0.7095529112, alpha: 1), shadowOpacity: 1, shadowOffset: .zero, shadowRadius: 2)
            Utilities.setShadowOn(textField: loginEmailTextField, isHidden: false, borderStyle: UITextField.BorderStyle.none, shadowColor: #colorLiteral(red: 0.6948884352, green: 0.6939979255, blue: 0.7095529112, alpha: 1), shadowOpacity: 1, shadowOffset: .zero, shadowRadius: 2)
            Utilities.setShadowOn(textField: loginPasswordTextField, isHidden: false, borderStyle: UITextField.BorderStyle.none, shadowColor: #colorLiteral(red: 0.6948884352, green: 0.6939979255, blue: 0.7095529112, alpha: 1), shadowOpacity: 1, shadowOffset: .zero, shadowRadius: 2)
            Utilities.setShadowOn(button: loginButton, isHidden: false, shadowColor: #colorLiteral(red: 0.6948884352, green: 0.6939979255, blue: 0.7095529112, alpha: 1), shadowOpacity: 1, shadowOffset: .zero, shadowRadius: 2)
            Utilities.setDesignOn(activityIndicatorView: loginLoadingIndicatorView, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), isStartAnimating: false, isHidden: true)
        }
    }
    
    @objc func setDarkMode() {
        UIView.animate(withDuration: 0.3) { [self] in
            Utilities.setDesignOn(scrollView: loginScrollView, indicatorColor: .white)
            Utilities.setDesignOn(navigationBar: loginNavigationBar, isDarkMode: false)
            Utilities.setDesignOn(view: view, backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
            Utilities.setDesignOn(label: loginHeadingLabel, fontColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1))
            Utilities.setDesignOn(button: loginForgotPasswordButton, titleColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1))
            Utilities.setDesignOn(button: loginButton, titleColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), backgroundColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1))
            Utilities.setDesignOn(textField: loginEmailTextField, textColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), backgroundColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1))
            Utilities.setDesignOn(textField: loginPasswordTextField, textColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), backgroundColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1))
            Utilities.setShadowOn(view: loginImageContentView, isHidden: true)
            Utilities.setShadowOn(textField: loginEmailTextField, isHidden: true)
            Utilities.setShadowOn(textField: loginPasswordTextField, isHidden: true)
            Utilities.setShadowOn(button: loginButton, isHidden: true)
            Utilities.setDesignOn(activityIndicatorView: loginLoadingIndicatorView, color: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), isStartAnimating: false, isHidden: true)
        }
    }
    
    func setLoginButtonToOriginalDesign() {
        Utilities.setDesignOn(activityIndicatorView: loginLoadingIndicatorView, isStartAnimating: false, isHidden: true)
        loginButton.isHidden = false
    }
    
    func setLoginButtonTappedAnimation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [self] in
            loginButton.isHidden = true
            Utilities.setDesignOn(activityIndicatorView: loginLoadingIndicatorView, isStartAnimating: true, isHidden: false)
        }
    }
    
    func dismissKeyboard() {
        loginEmailTextField.endEditing(true)
        loginPasswordTextField.endEditing(true)
    }
    
    func removeWarningLabel() {
        UIView.animate(withDuration: 0.2) { [self] in
            loginWarningLabel.isHidden = true
        }
    }
    
    
    //MARK: - Buttons
    
    @IBAction func loginButton(_ sender: UIButton) {
        Utilities.animate(button: sender)
        loginProcess()
        dismissKeyboard()
    }
    
    
    //MARK: - Login Process
    
    func setDatasourceAndDelegate() {
        loginEmailTextField.delegate = self
        loginPasswordTextField.delegate = self
    }
    
    func loginProcess() {
        loginViewModel.loginUser(with: loginEmailTextField.text!, passwordTextField: loginPasswordTextField.text!) { [weak self] (error, loginIsSuccessful) in
            guard let self = self else {return}
            DispatchQueue.main.async {
                if error != nil {
                    Utilities.showWarningLabel(on: self.loginWarningLabel, with: error, isASuccessMessage: false)
                    self.setLoginButtonToOriginalDesign()
                    return
                }
                if loginIsSuccessful {
                    self.removeWarningLabel()
                    self.setLoginButtonTappedAnimation()
                    self.successfulLogin()
                }
            }
        }
    }
    
    func successfulLogin() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [self] in
            setLoginButtonToOriginalDesign()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                loginViewModel.transitionToHomeVC(with: self)
            }
        }
    }
    
}


//MARK: - Text Field Delegate

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        loginProcess()
        dismissKeyboard()
        return true
    }
    
}
