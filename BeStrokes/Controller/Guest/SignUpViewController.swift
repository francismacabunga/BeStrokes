//
//  SignUpViewController.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 11/3/20.
//

import UIKit
import CropViewController
import Firebase

class SignUpViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var signUpNavigationBar: UINavigationBar!
    @IBOutlet weak var signUpScrollView: UIScrollView!
    @IBOutlet weak var signUpContentView: UIView!
    @IBOutlet weak var signUpHeadingStackView: UIStackView!
    @IBOutlet weak var signUpImageContentView: UIView!
    @IBOutlet weak var signUpTextFieldsStackView: UIStackView!
    @IBOutlet weak var signUpHeadingLabel: UILabel!
    @IBOutlet weak var signUpWarning1Label: UILabel!
    @IBOutlet weak var signUpWarning2Label: UILabel!
    @IBOutlet weak var signUpImageView: UIImageView!
    @IBOutlet weak var signUpFirstNameTextField: UITextField!
    @IBOutlet weak var signUpLastNameTextField: UITextField!
    @IBOutlet weak var signUpEmailTextField: UITextField!
    @IBOutlet weak var signUpPasswordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var signUpLoadingIndicatorView: UIActivityIndicatorView!
    
    
    //MARK: - Constants / Variables
    
    private let imagePicker = UIImagePickerController()
    private var editedImage: UIImage? = nil
    private var imageIsChanged = false
    private let user = User()
    
    
    //MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDesignElements()
        registerGestures()
        setDatasourceAndDelegate()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        signUpFirstNameTextField.becomeFirstResponder()
    }
    
    
    //MARK: - Design Elements
    
    func setDesignElements() {
        Utilities.setDesignOn(view: signUpContentView, backgroundColor: .clear)
        Utilities.setDesignOn(stackView: signUpHeadingStackView, backgroundColor: .clear)
        Utilities.setDesignOn(view: signUpImageContentView, backgroundColor: .clear, isCircular: true)
        Utilities.setDesignOn(stackView: signUpTextFieldsStackView, backgroundColor: .clear)
        Utilities.setDesignOn(imageView: signUpImageView, image: UIImage(named: Strings.signUpDefaultImage), isCircular: true)
        Utilities.setDesignOn(label: signUpHeadingLabel, fontName: Strings.defaultFontBold, fontSize: 35, numberofLines: 0, textAlignment: .left, lineBreakMode: .byWordWrapping, text: Strings.signUpHeadingText)
        Utilities.setDesignOn(label: signUpWarning1Label, fontName: Strings.defaultFontBold, fontSize: 15, numberofLines: 0, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), isHidden: true)
        Utilities.setDesignOn(label: signUpWarning2Label, fontName: Strings.defaultFontBold, fontSize: 15, numberofLines: 0, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), isHidden: true)
        Utilities.setDesignOn(textField: signUpFirstNameTextField, fontName: Strings.defaultFont, fontSize: 15, autocorrectionType: .default, isSecureTextEntry: false, keyboardType: .default, textContentType: .name, capitalization: .words, placeholder: Strings.firstNameTextField, placeholderTextColor: #colorLiteral(red: 0.5411764706, green: 0.5411764706, blue: 0.5411764706, alpha: 1), isCircular: true)
        Utilities.setDesignOn(textField: signUpLastNameTextField, fontName: Strings.defaultFont, fontSize: 15, autocorrectionType: .default, isSecureTextEntry: false, keyboardType: .default, textContentType: .name, capitalization: .words, placeholder: Strings.lastNameTextField, placeholderTextColor: #colorLiteral(red: 0.5411764706, green: 0.5411764706, blue: 0.5411764706, alpha: 1), isCircular: true)
        Utilities.setDesignOn(textField: signUpEmailTextField, fontName: Strings.defaultFont, fontSize: 15, autocorrectionType: .no, isSecureTextEntry: false, keyboardType: .emailAddress, textContentType: .emailAddress, placeholder: Strings.emailTextField, placeholderTextColor: #colorLiteral(red: 0.5411764706, green: 0.5411764706, blue: 0.5411764706, alpha: 1), isCircular: true)
        Utilities.setDesignOn(textField: signUpPasswordTextField, fontName: Strings.defaultFont, fontSize: 15, autocorrectionType: .no, isSecureTextEntry: true, keyboardType: .default, textContentType: .password, placeholder: Strings.passwordTextField, placeholderTextColor: #colorLiteral(red: 0.5411764706, green: 0.5411764706, blue: 0.5411764706, alpha: 1), isCircular: true)
        Utilities.setDesignOn(activityIndicatorView: signUpLoadingIndicatorView, size: .medium, isHidden: true)
        Utilities.setDesignOn(button: signUpButton, title: Strings.signUpButtonText, fontName: Strings.defaultFontBold, fontSize: 20, isCircular: true)
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
            Utilities.setDesignOn(navigationBar: signUpNavigationBar, isDarkMode: true)
            Utilities.setDesignOn(view: view, backgroundColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1))
            Utilities.setDesignOn(scrollView: signUpScrollView, indicatorColor: .black)
            Utilities.setDesignOn(label: signUpHeadingLabel, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
            Utilities.setDesignOn(textField: signUpFirstNameTextField, textColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), backgroundColor: .white)
            Utilities.setDesignOn(textField: signUpLastNameTextField, textColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), backgroundColor: .white)
            Utilities.setDesignOn(textField: signUpEmailTextField, textColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), backgroundColor: .white)
            Utilities.setDesignOn(textField: signUpPasswordTextField, textColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), backgroundColor: .white)
            Utilities.setDesignOn(button: signUpButton, titleColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), backgroundColor: .white)
            Utilities.setDesignOn(activityIndicatorView: signUpLoadingIndicatorView, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
            Utilities.setShadowOn(view: signUpImageContentView, isHidden: false, shadowColor: #colorLiteral(red: 0.6948884352, green: 0.6939979255, blue: 0.7095529112, alpha: 1), shadowOpacity: 1, shadowOffset: .zero, shadowRadius: 2)
            Utilities.setShadowOn(textField: signUpFirstNameTextField, isHidden: false, borderStyle: UITextField.BorderStyle.none, shadowColor: #colorLiteral(red: 0.6948884352, green: 0.6939979255, blue: 0.7095529112, alpha: 1), shadowOpacity: 1, shadowOffset: .zero, shadowRadius: 2)
            Utilities.setShadowOn(textField: signUpLastNameTextField, isHidden: false, borderStyle: UITextField.BorderStyle.none, shadowColor: #colorLiteral(red: 0.6948884352, green: 0.6939979255, blue: 0.7095529112, alpha: 1), shadowOpacity: 1, shadowOffset: .zero, shadowRadius: 2)
            Utilities.setShadowOn(textField: signUpEmailTextField, isHidden: false, borderStyle: UITextField.BorderStyle.none, shadowColor: #colorLiteral(red: 0.6948884352, green: 0.6939979255, blue: 0.7095529112, alpha: 1), shadowOpacity: 1, shadowOffset: .zero, shadowRadius: 2)
            Utilities.setShadowOn(textField: signUpPasswordTextField, isHidden: false, borderStyle: UITextField.BorderStyle.none, shadowColor: #colorLiteral(red: 0.6948884352, green: 0.6939979255, blue: 0.7095529112, alpha: 1), shadowOpacity: 1, shadowOffset: .zero, shadowRadius: 2)
            Utilities.setShadowOn(button: signUpButton, isHidden: false, shadowColor: #colorLiteral(red: 0.6948884352, green: 0.6939979255, blue: 0.7095529112, alpha: 1), shadowOpacity: 1, shadowOffset: .zero, shadowRadius: 2)
        }
    }
    
    @objc func setDarkMode() {
        UIView.animate(withDuration: 0.3) { [self] in
            Utilities.setDesignOn(navigationBar: signUpNavigationBar, isDarkMode: false)
            Utilities.setDesignOn(view: view, backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
            Utilities.setDesignOn(scrollView: signUpScrollView, indicatorColor: .white)
            Utilities.setDesignOn(label: signUpHeadingLabel, fontColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1))
            Utilities.setDesignOn(textField: signUpFirstNameTextField, textColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), backgroundColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1))
            Utilities.setDesignOn(textField: signUpLastNameTextField, textColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), backgroundColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1))
            Utilities.setDesignOn(textField: signUpEmailTextField, textColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), backgroundColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1))
            Utilities.setDesignOn(textField: signUpPasswordTextField, textColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), backgroundColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1))
            Utilities.setDesignOn(button: signUpButton, titleColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), backgroundColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1))
            Utilities.setDesignOn(activityIndicatorView: signUpLoadingIndicatorView, color: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1))
            Utilities.setShadowOn(view: signUpImageContentView, isHidden: true)
            Utilities.setShadowOn(textField: signUpFirstNameTextField, isHidden: true)
            Utilities.setShadowOn(textField: signUpLastNameTextField, isHidden: true)
            Utilities.setShadowOn(textField: signUpEmailTextField, isHidden: true)
            Utilities.setShadowOn(textField: signUpPasswordTextField, isHidden: true)
            Utilities.setShadowOn(button: signUpButton, isHidden: true)
        }
    }
    
    func setSignUpButtonTappedAnimation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [self] in
            signUpButton.isHidden = true
            signUpLoadingIndicatorView.isHidden = false
            signUpLoadingIndicatorView.startAnimating()
        }
    }
    
    func setSignUpButtonTransitionAnimation() {
        signUpLoadingIndicatorView.isHidden = true
        signUpButton.setTitle(Strings.signUpButtonTransitionText, for: .normal)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [self] in
            signUpButton.isHidden = false
            signUpButton.isEnabled = false
        }
    }
    
    func setSignUpButtonToOriginalDesign() {
        signUpLoadingIndicatorView.isHidden = true
        signUpButton.isHidden = false
    }
    
    func dismissKeyboard() {
        signUpFirstNameTextField.endEditing(true)
        signUpLastNameTextField.endEditing(true)
        signUpEmailTextField.endEditing(true)
        signUpPasswordTextField.endEditing(true)
    }
    
    func setPlaceholderErrorDesign(on firstName: UITextField, _ lastName: UITextField, _ email: UITextField, _ password: UITextField) {
        Utilities.setDesignOn(textField: firstName, fontName: Strings.defaultFont, fontSize: 15, autocorrectionType: .default, isSecureTextEntry: false, keyboardType: .default, textContentType: .name, placeholder: Strings.signUpFirstNameTextFieldErrorLabel, placeholderTextColor: #colorLiteral(red: 0.9673412442, green: 0.0823205933, blue: 0.006666854955, alpha: 1))
        Utilities.setDesignOn(textField: lastName, fontName: Strings.defaultFont, fontSize: 15, autocorrectionType: .default, isSecureTextEntry: false, keyboardType: .default, textContentType: .name, placeholder: Strings.signUpLastNameTextFieldErrorLabel, placeholderTextColor: #colorLiteral(red: 0.9673412442, green: 0.0823205933, blue: 0.006666854955, alpha: 1))
        Utilities.setDesignOn(textField: email, fontName: Strings.defaultFont, fontSize: 15, autocorrectionType: .no, isSecureTextEntry: false, keyboardType: .emailAddress, textContentType: .emailAddress, placeholder: Strings.signUpEmailTextFieldErrorLabel, placeholderTextColor: #colorLiteral(red: 0.9673412442, green: 0.0823205933, blue: 0.006666854955, alpha: 1))
        Utilities.setDesignOn(textField: password, fontName: Strings.defaultFont, fontSize: 15, autocorrectionType: .no, isSecureTextEntry: true, keyboardType: .default, textContentType: .password, placeholder: Strings.signUpPasswordTextFieldErrorLabel, placeholderTextColor: #colorLiteral(red: 0.9673412442, green: 0.0823205933, blue: 0.006666854955, alpha: 1))
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
    
    func presentCropViewController(_ imagePicked: UIImage) {
        let cropViewController = CropViewController(croppingStyle: .circular, image: imagePicked)
        cropViewController.delegate = self
        dismiss(animated: true)
        present(cropViewController, animated: true, completion: nil)
    }
    
    func transitionToHomeVC() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [self] in
            let storyboard = UIStoryboard(name: Strings.userStoryboard, bundle: nil)
            let homeVC = storyboard.instantiateViewController(identifier: Strings.tabBarVC)
            view.window?.rootViewController = homeVC
            view.window?.makeKeyAndVisible()
        }
    }
    
    
    //MARK: - UIGestureHandlers
    
    func registerGestures() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler))
        signUpImageView.isUserInteractionEnabled = true
        signUpImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func tapGestureHandler() {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    //MARK: - Buttons
    
    @IBAction func signUpButton(_ sender: UIButton) {
        Utilities.animate(button: sender)
        validateProfilePicture()
        validateTextFields()
        signUpAccount()
        dismissKeyboard()
    }
    
    
    //MARK: - Sign Up Process
    
    func setDatasourceAndDelegate() {
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        signUpFirstNameTextField.delegate = self
        signUpLastNameTextField.delegate = self
        signUpEmailTextField.delegate = self
        signUpPasswordTextField.delegate = self
    }
    
    func validateProfilePicture() -> Bool {
        if imageIsChanged {
            return true
        } else {
            showWarningLabel(on: signUpWarning2Label, customizedWarning: Strings.signUpProfilePictureErrorLabel, isASuccessMessage: false)
            return false
        }
    }
    
    func validateTextFields() -> Bool {
        if signUpFirstNameTextField.text == "" || signUpLastNameTextField.text == "" || signUpEmailTextField.text == "" || signUpPasswordTextField.text == "" {
            setPlaceholderErrorDesign(on: signUpFirstNameTextField, signUpLastNameTextField, signUpEmailTextField, signUpPasswordTextField)
            return false
        }
        if signUpPasswordTextField.text != "" {
            guard let password = signUpPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {return false}
            let passwordValid = user.isPasswordValid(password)
            if passwordValid {
                signUpWarning1Label.isHidden = true
                return true
            } else {
                showWarningLabel(on: signUpWarning1Label, customizedWarning: Strings.signUpPasswordErrorLabel, isASuccessMessage: false)
                return false
            }
        }
        return Bool()
    }
    
    func userData() -> [String : String] {
        let firstName = signUpFirstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let lastName = signUpLastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let email = signUpEmailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = signUpPasswordTextField.text
        let userDataDictionary = [Strings.userFirstNameField: firstName!,
                                  Strings.userLastNameField: lastName!,
                                  Strings.userEmailField: email!,
                                  Strings.userPasswordField: password!]
        return userDataDictionary
    }
    
    func signUpAccount() {
        if validateTextFields() && validateProfilePicture() {
            let userDataDictionary = userData()
            setSignUpButtonTappedAnimation()
            user.createUser(with: userDataDictionary[Strings.userEmailField]!, userDataDictionary[Strings.userPasswordField]!) { [self] (error, authResult) in
                guard let error = error else {
                    guard let authResult = authResult else {return}
                    UIView.animate(withDuration: 0.2) { [self] in
                        signUpWarning1Label.isHidden = true
                    }
                    uploadUserData(using: authResult, with: userDataDictionary)
                    return
                }
                showWarningLabel(on: signUpWarning1Label, with: error, isASuccessMessage: false)
                setSignUpButtonToOriginalDesign()
            }
        }
    }
    
    func uploadUserData(using authResult: AuthDataResult, with userDataDictionary: [String : String]) {
        user.uploadProfilePic(with: editedImage!, using: authResult.user.uid) { [self] (error, profilePic) in
            if error != nil {
                showWarningLabel(on: signUpWarning1Label, with: error!, isASuccessMessage: false)
                setSignUpButtonToOriginalDesign()
                return
            }
            guard let profilePic = profilePic else {return}
            let dictionary = [Strings.userIDField : authResult.user.uid,
                              Strings.userFirstNameField : userDataDictionary[Strings.userFirstNameField]!,
                              Strings.userLastNameField : userDataDictionary[Strings.userLastNameField]!,
                              Strings.userEmailField : userDataDictionary[Strings.userEmailField]!,
                              Strings.userProfilePicField : profilePic]
            user.storeData(using: authResult.user.uid, with: dictionary) { (error, isFinishedStoring) in
                guard let error = error else {
                    if isFinishedStoring {
                        sendEmailVerification()
                    }
                    return
                }
                showWarningLabel(on: signUpWarning1Label, with: error, isASuccessMessage: false)
                setSignUpButtonToOriginalDesign()
            }
        }
    }
    
    func sendEmailVerification() {
        user.sendEmailVerification { [self] (error, isEmailVerificationSent) in
            guard let error = error else {
                if isEmailVerificationSent {
                    showWarningLabel(on: signUpWarning1Label, customizedWarning: Strings.signUpProcessSuccessfulLabel, isASuccessMessage: true)
                    setSignUpButtonTransitionAnimation()
                    transitionToHomeVC()
                }
                return
            }
            showWarningLabel(on: signUpWarning1Label, with: error, isASuccessMessage: false)
            setSignUpButtonToOriginalDesign()
        }
    }
    
}


//MARK: - Image Picker & Navigation Delegate

extension SignUpViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imagePicked = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        presentCropViewController(imagePicked)
    }
    
}


//MARK: - Crop View Controller Delegate

extension SignUpViewController: CropViewControllerDelegate {
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        editedImage = image
        signUpImageView.image = image
        imageIsChanged = true
        signUpWarning2Label.isHidden = true
        let viewController = cropViewController.children.first!
        viewController.modalTransitionStyle = .coverVertical
        viewController.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
}


//MARK: - Text Field Delegate

extension SignUpViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        signUpAccount()
        return true
    }
    
}
