//
//  EditAccountViewController.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 1/10/21.
//

import UIKit
import CropViewController
import Kingfisher

class EditAccountViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var editAccountNavigationBar: UINavigationBar!
    @IBOutlet weak var editAccountScrollView: UIScrollView!
    @IBOutlet weak var editAccountStackView: UIStackView!
    @IBOutlet weak var editAccountHeadingContentView: UIView!
    @IBOutlet weak var editAccountImageContentView: UIView!
    @IBOutlet weak var editAccountSaveButtonContentView: UIView!
    @IBOutlet weak var editAccountHeadingLabel: UILabel!
    @IBOutlet weak var editAccountWarningLabel: UILabel!
    @IBOutlet weak var editAccountFirstNameLabel: UILabel!
    @IBOutlet weak var editAccountLastNameLabel: UILabel!
    @IBOutlet weak var editAccountEmailLabel: UILabel!
    @IBOutlet weak var editAccountImageView: UIImageView!
    @IBOutlet weak var editAccountCameraIconImageView: UIImageView!
    @IBOutlet weak var editAccountFirstNameTextField: UITextField!
    @IBOutlet weak var editAccountLastNameTextField: UITextField!
    @IBOutlet weak var editAccountEmailTextField: UITextField!
    @IBOutlet weak var editAccountButton: UIButton!
    @IBOutlet weak var editAccountLoadingIndicatorView: UIActivityIndicatorView!
    
    
    //MARK: - Constants / Variables
    
    private let service = Firebase()
    private let imagePicker = UIImagePickerController()
    private var editedImage: UIImage?
    private var userID = String()
    private var profilePic = String()
    private var initialUserEmail = String()
    private var isCroppingDone = false
    
    
    //MARK: - View Controller Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setDesignElements()
        registerGestures()
        setDataSourceAndDelegate()
        setData()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        UserDefaults.standard.setValue(false, forKey: Strings.isEditAccountVCLoadedKey)
        UserDefaults.standard.setValue(true, forKey: Strings.isAccountVCLoadedKey)
        
    }
    
    
    //MARK: - Design Elements
    
    func setDesignElements() {
        Utilities.setDesignOn(scrollView: editAccountScrollView, indicatorColor: .black, keyboardDismissMode: .onDrag)
        Utilities.setDesignOn(view: view, backgroundColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1))
        Utilities.setDesignOn(view: editAccountHeadingContentView, backgroundColor: .clear)
        Utilities.setDesignOn(view: editAccountImageContentView, backgroundColor: .clear, isCircular: true)
        Utilities.setShadowOn(view: editAccountImageContentView, isHidden: false, shadowColor: #colorLiteral(red: 0.6948884352, green: 0.6939979255, blue: 0.7095529112, alpha: 1), shadowOpacity: 1, shadowOffset: .zero, shadowRadius: 5)
        Utilities.setDesignOn(view: editAccountSaveButtonContentView, backgroundColor: .clear)
        Utilities.setDesignOn(stackView: editAccountStackView, backgroundColor: .clear)
        Utilities.setDesignOn(navigationBar: editAccountNavigationBar, isDarkMode: true)
        Utilities.setDesignOn(imageView: editAccountImageView, isCircular: true)
        if !isCroppingDone {
            Utilities.setDesignOn(imageView: editAccountCameraIconImageView, image: UIImage(named: Strings.cameraImage))
        }
        Utilities.setDesignOn(label: editAccountHeadingLabel, fontName: Strings.defaultFontBold, fontSize: 35, numberofLines: 0, textAlignment: .left, lineBreakMode: .byWordWrapping, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), text: Strings.editAccountHeadingText)
        Utilities.setDesignOn(label: editAccountWarningLabel, fontName: Strings.defaultFontBold, fontSize: 15, numberofLines: 0, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), isHidden: true)
        Utilities.setDesignOn(label: editAccountFirstNameLabel, fontName: Strings.defaultFontBold, fontSize: 15, numberofLines: 1, textAlignment: .left, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), text: Strings.firstNameTextField)
        Utilities.setDesignOn(label: editAccountLastNameLabel, fontName: Strings.defaultFontBold, fontSize: 15, numberofLines: 1, textAlignment: .left, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), text: Strings.lastNameTextField)
        Utilities.setDesignOn(label: editAccountEmailLabel, fontName: Strings.defaultFontBold, fontSize: 15, numberofLines: 1, textAlignment: .left, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), text: Strings.emailTextField)
        Utilities.setDesignOn(textField: editAccountFirstNameTextField, fontName: Strings.defaultFont, fontSize: 15, autocorrectionType: .default, isSecureTextEntry: false, keyboardType: .default, textContentType: .name, capitalization: .words, isCircular: true)
        Utilities.setDesignOn(textField: editAccountLastNameTextField, fontName: Strings.defaultFont, fontSize: 15, autocorrectionType: .default, isSecureTextEntry: false, keyboardType: .default, textContentType: .name, capitalization: .words, isCircular: true)
        Utilities.setDesignOn(textField: editAccountEmailTextField, fontName: Strings.defaultFont, fontSize: 15, autocorrectionType: .no, isSecureTextEntry: false, keyboardType: .emailAddress, textContentType: .emailAddress, isCircular: true)
        Utilities.setDesignOn(button: editAccountButton, title: Strings.saveButtonText, fontName: Strings.defaultFontBold, fontSize: 20, isCircular: true)
        Utilities.setDesignOn(activityIndicatorView: editAccountLoadingIndicatorView, size: .medium, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), isStartAnimating: false, isHidden: true)
        NotificationCenter.default.addObserver(self, selector: #selector(setLightMode), name: Utilities.setLightModeAppearance, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setDarkMode), name: Utilities.setDarkModeAppearance, object: nil)
        UserDefaults.standard.setValue(true, forKey: Strings.isEditAccountVCLoadedKey)
        UserDefaults.standard.setValue(false, forKey: Strings.isAccountVCLoadedKey)
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
            Utilities.setDesignOn(textField: editAccountFirstNameTextField, textColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), backgroundColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), placeholderTextColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
            Utilities.setDesignOn(textField: editAccountLastNameTextField, textColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), backgroundColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), placeholderTextColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
            Utilities.setDesignOn(textField: editAccountEmailTextField, textColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), backgroundColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), placeholderTextColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
            Utilities.setShadowOn(textField: editAccountFirstNameTextField, isHidden: false, borderStyle: UITextField.BorderStyle.none, shadowColor: #colorLiteral(red: 0.6948884352, green: 0.6939979255, blue: 0.7095529112, alpha: 1), shadowOpacity: 1, shadowOffset: .zero, shadowRadius: 2)
            Utilities.setShadowOn(textField: editAccountLastNameTextField, isHidden: false, borderStyle: UITextField.BorderStyle.none, shadowColor: #colorLiteral(red: 0.6948884352, green: 0.6939979255, blue: 0.7095529112, alpha: 1), shadowOpacity: 1, shadowOffset: .zero, shadowRadius: 2)
            Utilities.setShadowOn(textField: editAccountEmailTextField, isHidden: false, borderStyle: UITextField.BorderStyle.none, shadowColor: #colorLiteral(red: 0.6948884352, green: 0.6939979255, blue: 0.7095529112, alpha: 1), shadowOpacity: 1, shadowOffset: .zero, shadowRadius: 2)
            Utilities.setShadowOn(button: editAccountButton, isHidden: false, shadowColor: #colorLiteral(red: 0.6948884352, green: 0.6939979255, blue: 0.7095529112, alpha: 1), shadowOpacity: 1, shadowOffset: .zero, shadowRadius: 2)
            Utilities.setDesignOn(button: editAccountButton, titleColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), backgroundColor: .white)
        }
    }
    
    @objc func setDarkMode() {
        UIView.animate(withDuration: 0.3) { [self] in
            Utilities.setDesignOn(textField: editAccountFirstNameTextField, textColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), placeholderTextColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
            Utilities.setDesignOn(textField: editAccountLastNameTextField, textColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), placeholderTextColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
            Utilities.setDesignOn(textField: editAccountEmailTextField, textColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), placeholderTextColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
            Utilities.setShadowOn(textField: editAccountFirstNameTextField, isHidden: true)
            Utilities.setShadowOn(textField: editAccountLastNameTextField, isHidden: true)
            Utilities.setShadowOn(textField: editAccountEmailTextField, isHidden: true)
            Utilities.setShadowOn(button: editAccountButton, isHidden: true)
            Utilities.setDesignOn(button: editAccountButton, titleColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        }
    }
    
    func setEditAccountButtonToOriginalDesign() {
        Utilities.setDesignOn(activityIndicatorView: editAccountLoadingIndicatorView, isStartAnimating: false, isHidden: true)
        editAccountButton.isHidden = false
        Utilities.setDesignOn(button: editAccountButton, title: Strings.saveButtonText, fontName: Strings.defaultFontBold, fontSize: 20, titleColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), isCircular: true)
    }
    
    func dismissKeyboard() {
        editAccountFirstNameTextField.endEditing(true)
        editAccountLastNameTextField.endEditing(true)
        editAccountEmailTextField.endEditing(true)
    }
    
    func showLoadingButton() {
        editAccountButton.isHidden = true
        Utilities.setDesignOn(activityIndicatorView: editAccountLoadingIndicatorView, isStartAnimating: true, isHidden: false)
    }
    
    func showAlertController(alertMessage: String,
                             withHandler: Bool)
    {
        if UserDefaults.standard.bool(forKey: Strings.isEditAccountVCLoadedKey) {
            if self.presentedViewController as? UIAlertController == nil {
                if withHandler {
                    let alertWithHandler = Utilities.showAlert(alertTitle: Strings.errorAlert, alertMessage: alertMessage, alertActionTitle1: Strings.dismissAlert, forSingleActionTitleWillItUseHandler: true) { [weak self] in
                        guard let self = self else {return}
                        DispatchQueue.main.async {
                            _ = Utilities.transition(from: self.view, to: Strings.landingVC, onStoryboard: Strings.guestStoryboard, canAccessDestinationProperties: false)
                        }
                    }
                    present(alertWithHandler!, animated: true)
                    return
                }
                let alert = Utilities.showAlert(alertTitle: Strings.errorAlert, alertMessage: alertMessage, alertActionTitle1: Strings.dismissAlert, forSingleActionTitleWillItUseHandler: false) {}
                present(alert!, animated: true)
            }
        }
    }
    
    func presentCropViewController(with imagePicked: UIImage) {
        let cropViewController = CropViewController(croppingStyle: .circular, image: imagePicked)
        cropViewController.delegate = self
        dismiss(animated: true)
        present(cropViewController, animated: true, completion: nil)
    }
    
    
    //MARK: - Buttons
    
    @IBAction func editAccountSaveButton(_ sender: UIButton) {
        Utilities.animate(button: sender)
        let buttonCurrentTitle = sender.currentTitle
        let field = userInfo()
        if field[Strings.userFirstNameField] != "" &&  field[Strings.userLastNameField] != "" && field[Strings.userEmailField] != "" {
            if buttonCurrentTitle != Strings.resendButtonText {
                checkIfEmailIsVerified(using: field[Strings.userFirstNameField]!!, field[Strings.userLastNameField]!!, field[Strings.userEmailField]!!, field[Strings.userInitialUserEmail]!!)
            } else {
                sendEmailVerification(with: Strings.editAccountSuccessfullySentEmailVerificationLabel)
            }
        } else {
            Utilities.showWarningLabel(on: editAccountWarningLabel, customizedWarning: Strings.editAccountTextFieldErrorLabel, isASuccessMessage: false)
        }
    }
    
    func returnButtonTapped() {
        let field = userInfo()
        if field[Strings.userFirstNameField] != "" &&  field[Strings.userLastNameField] != "" && field[Strings.userEmailField] != "" {
            checkIfEmailIsVerified(using: field[Strings.userFirstNameField]!!, field[Strings.userLastNameField]!!, field[Strings.userEmailField]!!, field[Strings.userInitialUserEmail]!!)
        } else {
            Utilities.showWarningLabel(on: editAccountWarningLabel, customizedWarning: Strings.editAccountTextFieldErrorLabel, isASuccessMessage: false)
        }
    }
    
    
    //MARK: - UIGestureHandlers
    
    func registerGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler))
        Utilities.setDesignOn(imageView: editAccountImageView, isUserInteractionEnabled: true, gestureRecognizer: tapGesture)
    }
    
    @objc func tapGestureHandler() {
        present(imagePicker, animated: true)
    }
    
    
    //MARK: - Fetching of User Data
    
    func setData() {
        service.getSignedInUserData { [weak self] (error, isUserSignedIn, userData) in
            guard let self = self else {return}
            if !isUserSignedIn {
                guard let error = error else {return}
                DispatchQueue.main.async {
                    self.showAlertController(alertMessage: error.localizedDescription, withHandler: true)
                }
                return
            }
            if error != nil {
                DispatchQueue.main.async {
                    self.showAlertController(alertMessage: error!.localizedDescription, withHandler: false)
                }
                return
            }
            guard let userData = userData else {return}
            DispatchQueue.main.async {
                self.userID = userData.userID
                self.profilePic = userData.profilePic
                self.initialUserEmail = userData.email
                self.editAccountImageView.kf.setImage(with: URL(string: userData.profilePic)!)
                self.editAccountFirstNameTextField.text = userData.firstName
                self.editAccountLastNameTextField.text = userData.lastname
                self.editAccountEmailTextField.text = userData.email
            }
        }
    }
    
    
    //MARK: - Edit Account Process
    
    func setDataSourceAndDelegate() {
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        editAccountFirstNameTextField.delegate = self
        editAccountLastNameTextField.delegate = self
        editAccountEmailTextField.delegate = self
    }
    
    func userInfo() -> [String : String?] {
        let firstName = editAccountFirstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let lastName = editAccountLastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let email = editAccountEmailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let userDataDictionary = [Strings.userFirstNameField: firstName,
                                  Strings.userLastNameField: lastName,
                                  Strings.userEmailField: email,
                                  Strings.userInitialUserEmail: initialUserEmail]
        return userDataDictionary
    }
    
    func checkIfEmailIsVerified(using firstName: String,
                                _ lastName: String,
                                _ email: String,
                                _ initialUserEmail: String)
    {
        service.isEmailVerified { [weak self] (error, isUserSignedIn, isEmailVerified) in
            guard let self = self else {return}
            if !isUserSignedIn {
                guard let error = error else {return}
                DispatchQueue.main.async {
                    self.showAlertController(alertMessage: error.localizedDescription, withHandler: true)
                    self.setEditAccountButtonToOriginalDesign()
                }
                return
            }
            if error != nil {
                DispatchQueue.main.async {
                    Utilities.showWarningLabel(on: self.editAccountWarningLabel, with: error!, isASuccessMessage: false)
                    self.setEditAccountButtonToOriginalDesign()
                }
                return
            }
            if isEmailVerified {
                DispatchQueue.main.async {
                    self.showLoadingButton()
                    self.uploadProfilePic(using: firstName, lastName, email, initialUserEmail)
                }
            } else {
                DispatchQueue.main.async {
                    Utilities.showWarningLabel(on: self.editAccountWarningLabel, customizedWarning: Strings.editAccountEmailVerficationErrorLabel, isASuccessMessage: false)
                    Utilities.setDesignOn(button: self.editAccountButton, title: Strings.resendButtonText, fontName: Strings.defaultFontBold, fontSize: 20, titleColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), backgroundColor: #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1), isCircular: true)
                }
            }
        }
    }
    
    func sendEmailVerification(with successLabel: String) {
        service.sendEmailVerification { [weak self] (error, isUserSignedIn, isEmailVerificationSent) in
            guard let self = self else {return}
            if !isUserSignedIn {
                guard let error = error else {return}
                DispatchQueue.main.async {
                    self.showAlertController(alertMessage: error.localizedDescription, withHandler: true)
                }
                return
            }
            if error != nil {
                DispatchQueue.main.async {
                    Utilities.showWarningLabel(on: self.editAccountWarningLabel, with: error!, isASuccessMessage: false)
                    Utilities.setDesignOn(button: self.editAccountButton, title: Strings.resendButtonText, fontName: Strings.defaultFontBold, fontSize: 20, titleColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), backgroundColor: #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1), isCircular: true)
                }
                return
            }
            if isEmailVerificationSent {
                DispatchQueue.main.async {
                    self.setEditAccountButtonToOriginalDesign()
                    Utilities.showWarningLabel(on: self.editAccountWarningLabel, customizedWarning: successLabel, isASuccessMessage: true)
                    NotificationCenter.default.post(name: Utilities.reloadUserData, object: nil)
                    NotificationCenter.default.post(name: Utilities.reloadProfilePic, object: nil)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.dismiss(animated: true)
                }
            }
        }
    }
    
    func uploadProfilePic(using firstName: String,
                          _ lastName: String,
                          _ email: String,
                          _ initialUserEmail: String)
    {
        if editedImage != nil {
            service.uploadProfilePic(with: editedImage!, using: userID) { [weak self] (error, chosenPic) in
                guard let self = self else {return}
                guard let error = error else {
                    guard let chosenPic = chosenPic else {return}
                    self.updateUserData(using: firstName, lastName, email, chosenPic, initialUserEmail)
                    return
                }
                DispatchQueue.main.async {
                    Utilities.showWarningLabel(on: self.editAccountWarningLabel, with: error, isASuccessMessage: false)
                }
            }
        } else {
            updateUserData(using: firstName, lastName, email, profilePic, initialUserEmail)
        }
    }
    
    func updateUserData(using firstName: String,
                        _ lastName: String,
                        _ email: String,
                        _ profilePic: String,
                        _ initialUserEmail: String)
    {
        if initialUserEmail != email {
            service.updateUserData(firstName, lastName, email, profilePic) { [weak self] (error, isUserSignedIn, isUpdateFinished) in
                guard let self = self else {return}
                if !isUserSignedIn {
                    guard let error = error else {return}
                    DispatchQueue.main.async {
                        self.showAlertController(alertMessage: error.localizedDescription, withHandler: true)
                        self.setEditAccountButtonToOriginalDesign()
                    }
                    return
                }
                if error != nil {
                    DispatchQueue.main.async {
                        Utilities.showWarningLabel(on: self.editAccountWarningLabel, with: error!, isASuccessMessage: false)
                        self.setEditAccountButtonToOriginalDesign()
                    }
                    return
                }
                if isUpdateFinished {
                    self.sendEmailVerification(with: Strings.editAccountProcessSuccessfulLabel)
                }
            }
        } else {
            service.updateUserData(firstName, lastName, email, profilePic) { [weak self] (error, isUserSignedIn, isUpdateFinished) in
                guard let self = self else {return}
                if !isUserSignedIn {
                    guard let error = error else {return}
                    DispatchQueue.main.async {
                        self.showAlertController(alertMessage: error.localizedDescription, withHandler: true)
                        self.setEditAccountButtonToOriginalDesign()
                    }
                    return
                }
                if error != nil {
                    DispatchQueue.main.async {
                        Utilities.showWarningLabel(on: self.editAccountWarningLabel, with: error!, isASuccessMessage: false)
                        self.setEditAccountButtonToOriginalDesign()
                    }
                    return
                }
                if isUpdateFinished {
                    DispatchQueue.main.async {
                        self.setEditAccountButtonToOriginalDesign()
                        NotificationCenter.default.post(name: Utilities.reloadUserData, object: nil)
                        NotificationCenter.default.post(name: Utilities.reloadProfilePic, object: nil)
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.dismiss(animated: true)
                    }
                }
            }
        }
    }
    
}


//MARK: - Image Picker & Navigation Controller Delegate

extension EditAccountViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imagePicked = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        presentCropViewController(with: imagePicked)
    }
    
}


//MARK: - Crop View Controller Delegate

extension EditAccountViewController: CropViewControllerDelegate {
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        isCroppingDone = true
        editAccountImageView.isHidden = true
        editedImage = image
        Utilities.setDesignOn(imageView: editAccountCameraIconImageView, image: image, isCircular: true)
        Utilities.dismiss(cropViewController)
    }
    
    func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
        Utilities.dismiss(cropViewController)
    }
    
}


//MARK: - Text Field Delegate

extension EditAccountViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        returnButtonTapped()
        dismissKeyboard()
        return true
    }
    
}
