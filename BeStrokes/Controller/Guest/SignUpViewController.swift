//
//  SignupController.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 11/3/20.
//

import UIKit
import CropViewController

class SignUpViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var signUpNavigationBar: UINavigationBar!
    @IBOutlet weak var signUpContentView: UIView!
    @IBOutlet weak var signUpHeadingStackView: UIStackView!
    @IBOutlet weak var signUpTextFieldsStackView: UIStackView!
    @IBOutlet weak var signUpHeadingLabel: UILabel!
    @IBOutlet weak var signUpImageView: UIImageView!
    @IBOutlet weak var signUpWarning1Label: UILabel!
    @IBOutlet weak var signUpWarning2Label: UILabel!
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
        UIScrollView.appearance().indicatorStyle = .white
        signUpLoadingIndicatorView.isHidden = true
        signUpWarning1Label.isHidden = true
        signUpWarning2Label.isHidden = true
        Utilities.setDesignOn(view: view, backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        Utilities.setDesignOn(view: signUpContentView, backgroundColor: .clear)
        Utilities.setDesignOn(stackView: signUpHeadingStackView, backgroundColor: .clear)
        Utilities.setDesignOn(stackView: signUpTextFieldsStackView, backgroundColor: .clear)
        Utilities.setDesignOn(navigationBar: signUpNavigationBar, isDarkMode: false)
        Utilities.setDesignOn(imageView: signUpImageView, image: UIImage(named: Strings.signUpDefaultIcon), isCircular: true)
        Utilities.setDesignOn(label: signUpHeadingLabel, font: Strings.defaultFontBold, fontSize: 35, fontColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), numberofLines: 0, textAlignment: .left, lineBreakMode: .byWordWrapping, text: Strings.signUpHeadingText)
        Utilities.setDesignOn(textField: signUpFirstNameTextField, font: Strings.defaultFont, fontSize: 15, autocorrectionType: .default, isSecureTextEntry: false, keyboardType: .default, textContentType: .name, textColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), backgroundColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), placeholder: Strings.firstNameTextField, placeholderTextColor: #colorLiteral(red: 0.5411764706, green: 0.5411764706, blue: 0.5411764706, alpha: 1), isCircular: true)
        Utilities.setDesignOn(textField: signUpLastNameTextField, font: Strings.defaultFont, fontSize: 15, autocorrectionType: .default, isSecureTextEntry: false, keyboardType: .default, textContentType: .name, textColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), backgroundColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), placeholder: Strings.lastNameTextField, placeholderTextColor: #colorLiteral(red: 0.5411764706, green: 0.5411764706, blue: 0.5411764706, alpha: 1), isCircular: true)
        Utilities.setDesignOn(textField: signUpEmailTextField, font: Strings.defaultFont, fontSize: 15, autocorrectionType: .no, isSecureTextEntry: false, keyboardType: .emailAddress, textContentType: .emailAddress, textColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), backgroundColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), placeholder: Strings.emailTextField, placeholderTextColor: #colorLiteral(red: 0.5411764706, green: 0.5411764706, blue: 0.5411764706, alpha: 1), isCircular: true)
        Utilities.setDesignOn(textField: signUpPasswordTextField, font: Strings.defaultFont, fontSize: 15, autocorrectionType: .no, isSecureTextEntry: true, keyboardType: .default, textContentType: .password, textColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), backgroundColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), placeholder: Strings.passwordTextField, placeholderTextColor: #colorLiteral(red: 0.5411764706, green: 0.5411764706, blue: 0.5411764706, alpha: 1), isCircular: true)
        Utilities.setDesignOn(activityIndicatorView: signUpLoadingIndicatorView, size: .medium, backgroundColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1))
        Utilities.setDesignOn(button: signUpButton, title: Strings.signUpButtonText, font: Strings.defaultFontBold, fontSize: 20, titleColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), backgroundColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), isCircular: true)
    }
    
    func presentCropViewController(_ imagePicked: UIImage) {
        let cropViewController = CropViewController(croppingStyle: .circular, image: imagePicked)
        cropViewController.delegate = self
        dismiss(animated: true)
        present(cropViewController, animated: true, completion: nil)
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
        Utilities.animateButton(button: sender)
        validateProfilePicture()
        validateTextFields()
        processSignUp()
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
            Utilities.setDesignOn(textField: signUpFirstNameTextField, font: Strings.defaultFont, fontSize: 15, autocorrectionType: .default, isSecureTextEntry: false, keyboardType: .default, textContentType: .name, placeholder: Strings.signUpFirstNameTextFieldErrorLabel, placeholderTextColor: #colorLiteral(red: 0.9673412442, green: 0.0823205933, blue: 0.006666854955, alpha: 1))
            Utilities.setDesignOn(textField: signUpLastNameTextField, font: Strings.defaultFont, fontSize: 15, autocorrectionType: .default, isSecureTextEntry: false, keyboardType: .default, textContentType: .name, placeholder: Strings.signUpLastNameTextFieldErrorLabel, placeholderTextColor: #colorLiteral(red: 0.9673412442, green: 0.0823205933, blue: 0.006666854955, alpha: 1))
            Utilities.setDesignOn(textField: signUpEmailTextField, font: Strings.defaultFont, fontSize: 15, autocorrectionType: .no, isSecureTextEntry: false, keyboardType: .emailAddress, textContentType: .emailAddress, placeholder: Strings.signUpEmailTextFieldErrorLabel, placeholderTextColor: #colorLiteral(red: 0.9673412442, green: 0.0823205933, blue: 0.006666854955, alpha: 1))
            Utilities.setDesignOn(textField: signUpPasswordTextField, font: Strings.defaultFont, fontSize: 15, autocorrectionType: .no, isSecureTextEntry: true, keyboardType: .default, textContentType: .password, placeholder: Strings.signUpPasswordTextFieldErrorLabel, placeholderTextColor: #colorLiteral(red: 0.9673412442, green: 0.0823205933, blue: 0.006666854955, alpha: 1))
        } else {
            if signUpPasswordTextField.text != "" {
                if let password = signUpPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
                    let passwordValid = user.isPasswordValid(password)
                    if passwordValid {
                        return true
                    } else {
                        showWarningLabel(on: signUpWarning1Label, customizedWarning: Strings.signUpPasswordErrorLabel, isASuccessMessage: false)
                        return false
                    }
                }
            }
        }
        return false
    }
    
    func processSignUp() {
        if validateTextFields() && validateProfilePicture() {
            if let firstName = signUpFirstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
               let lastName = signUpLastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
               let email = signUpEmailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
               let password = signUpPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
                setSignUpButtonTappedAnimation()
                user.createUser(with: email, password) { [self] (error, authResult) in
                    if error != nil {
                        showWarningLabel(on: signUpWarning1Label, with: error!, isASuccessMessage: false)
                        setSignUpButtonToOriginalDesign()
                        return
                    }
                    guard let result = authResult else {return}
                    let userID = result.user.uid
                    UIView.animate(withDuration: 0.2) { [self] in
                        signUpWarning1Label.isHidden = true
                    }
                    user.uploadProfilePic(with: editedImage!, using: userID) { (error, imageString) in
                        if error != nil {
                            showWarningLabel(on: signUpWarning1Label, with: error!, isASuccessMessage: false)
                            setSignUpButtonToOriginalDesign()
                            return
                        }
                        guard let profilePic = imageString else {return}
                        let dictionary = [Strings.userIDField : userID, Strings.userFirstNameField : firstName, Strings.userLastNameField : lastName, Strings.userEmailField : email, Strings.userProfilePicField : profilePic]
                        user.storeData(using: userID, with: dictionary) { (error, isFinishedStoring) in
                            if error != nil {
                                showWarningLabel(on: signUpWarning1Label, with: error!, isASuccessMessage: false)
                                setSignUpButtonToOriginalDesign()
                                return
                            }
                            if isFinishedStoring {
                                user.sendEmailVerification { (error, isEmailVerificationSent) in
                                    if error != nil {
                                        showWarningLabel(on: signUpWarning1Label, with: error!, isASuccessMessage: false)
                                        setSignUpButtonToOriginalDesign()
                                        return
                                    }
                                    if isEmailVerificationSent {
                                        showWarningLabel(on: signUpWarning1Label, customizedWarning: Strings.signUpProcessSuccessfulLabel, isASuccessMessage: true)
                                        setSignUpButtonTransitionAnimation()
                                        transitionToHomeVC()
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
}


//MARK: - Image Picker & Navigation Delegate

extension SignUpViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imagePicked = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            presentCropViewController(imagePicked)
        }
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
        processSignUp()
        return true
    }
    
}
