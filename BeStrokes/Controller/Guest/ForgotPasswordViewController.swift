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
    @IBOutlet weak var forgotPasswordScrollView: UIScrollView!
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
    
    private let service = Firebase()
    private let forgotPasswordViewModel = ForgotPasswordViewModel()
    
    
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
        Utilities.setDesignOn(scrollView: forgotPasswordScrollView, keyboardDismissMode: .onDrag)
        Utilities.setDesignOn(view: forgotPasswordContentView, backgroundColor: .clear)
        Utilities.setDesignOn(stackView: forgotPasswordHeadingsStackView, backgroundColor: .clear)
        Utilities.setDesignOn(stackView: forgotPasswordTextFieldStackView, backgroundColor: .clear)
        Utilities.setDesignOn(label: forgotPasswordHeadingLabel, fontName: Strings.defaultFontBold, fontSize: 35, numberofLines: 0, textAlignment: .left, lineBreakMode: .byWordWrapping, text: Strings.forgotPasswordHeadingText)
        Utilities.setDesignOn(label: forgotPasswordSubheadingLabel, fontName: Strings.defaultFontMedium, fontSize: 17, numberofLines: 0, textAlignment: .left, lineBreakMode: .byWordWrapping, text: Strings.forgotPasswordSubheadingText)
        Utilities.setDesignOn(label: forgotPasswordWarningLabel, fontName: Strings.defaultFontBold, fontSize: 15, numberofLines: 0, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), isHidden: true)
        Utilities.setDesignOn(textField: forgotPasswordEmailTextField, fontName: Strings.defaultFont, fontSize: 15, autocorrectionType: .no, isSecureTextEntry: false, keyboardType: .emailAddress, textContentType: .emailAddress, placeholder: Strings.emailTextField, placeholderTextColor: #colorLiteral(red: 0.5411764706, green: 0.5411764706, blue: 0.5411764706, alpha: 1), isCircular: true)
        Utilities.setDesignOn(button: forgotPasswordSubmitButton, title: Strings.submitButtonText, fontName: Strings.defaultFontBold, fontSize: 20, isCircular: true)
        Utilities.setDesignOn(button: forgotPasswordDismissButton, title: Strings.dismissButtonText, fontName: Strings.defaultFontBold, fontSize: 20, isCircular: true, isHidden: true)
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
            Utilities.setDesignOn(scrollView: forgotPasswordScrollView, indicatorColor: .black)
            Utilities.setDesignOn(navigationBar: forgotPasswordNavigationBar, isDarkMode: true)
            Utilities.setDesignOn(view: view, backgroundColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1))
            Utilities.setDesignOn(label: forgotPasswordHeadingLabel, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
            Utilities.setDesignOn(label: forgotPasswordSubheadingLabel, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
            Utilities.setDesignOn(imageView: forgotPasswordImageView, image: UIImage(named: Strings.blackKeys), alpha: 0.3)
            Utilities.setDesignOn(textField: forgotPasswordEmailTextField, textColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), backgroundColor: .white)
            Utilities.setDesignOn(button: forgotPasswordSubmitButton, titleColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), backgroundColor: .white)
            Utilities.setDesignOn(button: forgotPasswordDismissButton, titleColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), backgroundColor: .white)
            Utilities.setShadowOn(textField: forgotPasswordEmailTextField, isHidden: false, borderStyle: UITextField.BorderStyle.none, shadowColor: #colorLiteral(red: 0.6948884352, green: 0.6939979255, blue: 0.7095529112, alpha: 1), shadowOpacity: 1, shadowOffset: .zero, shadowRadius: 2)
            Utilities.setShadowOn(button: forgotPasswordSubmitButton, isHidden: false, shadowColor: #colorLiteral(red: 0.6948884352, green: 0.6939979255, blue: 0.7095529112, alpha: 1), shadowOpacity: 1, shadowOffset: .zero, shadowRadius: 2)
            Utilities.setShadowOn(button: forgotPasswordDismissButton, isHidden: false, shadowColor: #colorLiteral(red: 0.6948884352, green: 0.6939979255, blue: 0.7095529112, alpha: 1), shadowOpacity: 1, shadowOffset: .zero, shadowRadius: 2)
        }
    }
    
    @objc func setDarkMode() {
        UIView.animate(withDuration: 0.3) { [self] in
            Utilities.setDesignOn(scrollView: forgotPasswordScrollView, indicatorColor: .white)
            Utilities.setDesignOn(navigationBar: forgotPasswordNavigationBar, isDarkMode: false)
            Utilities.setDesignOn(view: view, backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
            Utilities.setDesignOn(label: forgotPasswordHeadingLabel, fontColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
            Utilities.setDesignOn(label: forgotPasswordSubheadingLabel, fontColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
            Utilities.setDesignOn(imageView: forgotPasswordImageView, image: UIImage(named: Strings.whiteKeys), alpha: 0.3)
            Utilities.setDesignOn(textField: forgotPasswordEmailTextField, textColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), backgroundColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1))
            Utilities.setDesignOn(button: forgotPasswordSubmitButton, titleColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), backgroundColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1))
            Utilities.setDesignOn(button: forgotPasswordDismissButton, titleColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), backgroundColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1))
            Utilities.setShadowOn(textField: forgotPasswordEmailTextField, isHidden: true)
            Utilities.setShadowOn(button: forgotPasswordSubmitButton, isHidden: true)
            Utilities.setShadowOn(button: forgotPasswordDismissButton, isHidden: true)
        }
    }
    
    func showDismissButton() {
        UIView.animate(withDuration: 0.3) { [self] in
            forgotPasswordSubmitButton.isHidden = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [self] in
            UIView.animate(withDuration: 0.2) {
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
        forgotPasswordProcess()
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
    
    func forgotPasswordProcess() {
        forgotPasswordViewModel.forgotPassword(using: forgotPasswordEmailTextField.text!) { [weak self] (error, passwordResetEmailIsSent) in
            guard let self = self else {return}
            DispatchQueue.main.async {
                if error != nil {
                    Utilities.showWarningLabel(on: self.forgotPasswordWarningLabel, with: error, isASuccessMessage: false)
                    return
                }
                if passwordResetEmailIsSent {
                    Utilities.showWarningLabel(on: self.forgotPasswordWarningLabel, customizedWarning: Strings.forgotPasswordProcessSuccessfulLabel, isASuccessMessage: true)
                    self.showDismissButton()
                }
            }
        }
    }
    
}


//MARK: - Text Field Delegate

extension ForgotPasswordViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        forgotPasswordProcess()
        forgotPasswordEmailTextField.endEditing(true)
        return true
    }
    
}
