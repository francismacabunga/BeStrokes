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
    
    private var userViewModel: UserViewModel?
    private let userData = UserData()
    private let imagePicker = UIImagePickerController()
    private var editedImage: UIImage?
    private lazy var userID = String()
    private lazy var profilePic = String()
    private lazy var initialUserEmail = String()
    
    
    //MARK: - View Controller Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UserDefaults.standard.setValue(true, forKey: Strings.isEditAccountVCLoadedKey)
        UserDefaults.standard.setValue(false, forKey: Strings.isAccountVCLoadedKey)
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
        Utilities.setDesignOn(scrollView: editAccountScrollView, indicatorColor: .black)
        Utilities.setDesignOn(view: view, backgroundColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1))
        Utilities.setDesignOn(view: editAccountHeadingContentView, backgroundColor: .clear)
        Utilities.setDesignOn(view: editAccountImageContentView, backgroundColor: .clear, isCircular: true)
        Utilities.setShadowOn(view: editAccountImageContentView, isHidden: false, shadowColor: #colorLiteral(red: 0.6948884352, green: 0.6939979255, blue: 0.7095529112, alpha: 1), shadowOpacity: 1, shadowOffset: .zero, shadowRadius: 5)
        Utilities.setDesignOn(view: editAccountSaveButtonContentView, backgroundColor: .clear)
        Utilities.setDesignOn(stackView: editAccountStackView, backgroundColor: .clear)
        Utilities.setDesignOn(navigationBar: editAccountNavigationBar, isDarkMode: true)
        Utilities.setDesignOn(imageView: editAccountImageView, isCircular: true)
        Utilities.setDesignOn(imageView: editAccountCameraIconImageView, image: UIImage(named: Strings.cameraImage), isCircular: true)
        Utilities.setDesignOn(label: editAccountHeadingLabel, fontName: Strings.defaultFontBold, fontSize: 35, numberofLines: 0, textAlignment: .left, lineBreakMode: .byWordWrapping, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), text: Strings.editAccountHeadingText)
        Utilities.setDesignOn(label: editAccountWarningLabel, fontName: Strings.defaultFontBold, fontSize: 15, numberofLines: 0, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), isHidden: true)
        Utilities.setDesignOn(label: editAccountFirstNameLabel, fontName: Strings.defaultFontBold, fontSize: 15, numberofLines: 1, textAlignment: .left, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), text: Strings.firstNameTextField)
        Utilities.setDesignOn(label: editAccountLastNameLabel, fontName: Strings.defaultFontBold, fontSize: 15, numberofLines: 1, textAlignment: .left, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), text: Strings.lastNameTextField)
        Utilities.setDesignOn(label: editAccountEmailLabel, fontName: Strings.defaultFontBold, fontSize: 15, numberofLines: 1, textAlignment: .left, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), text: Strings.emailTextField)
        Utilities.setDesignOn(textField: editAccountFirstNameTextField, fontName: Strings.defaultFont, fontSize: 15, autocorrectionType: .default, isSecureTextEntry: false, keyboardType: .default, textContentType: .name, capitalization: .words, isCircular: true)
        Utilities.setDesignOn(textField: editAccountLastNameTextField, fontName: Strings.defaultFont, fontSize: 15, autocorrectionType: .default, isSecureTextEntry: false, keyboardType: .default, textContentType: .name, capitalization: .words, isCircular: true)
        Utilities.setDesignOn(textField: editAccountEmailTextField, fontName: Strings.defaultFont, fontSize: 15, autocorrectionType: .no, isSecureTextEntry: false, keyboardType: .emailAddress, textContentType: .emailAddress, isCircular: true)
        Utilities.setDesignOn(button: editAccountButton, title: Strings.saveButtonText, fontName: Strings.defaultFontBold, fontSize: 20, isCircular: true)
        Utilities.setDesignOn(activityIndicatorView: editAccountLoadingIndicatorView, size: .medium, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), isHidden: true)
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
    
    func setData() {
        userData.getSignedInUserData { [self] (error, isUserSignedIn, userData) in
            if !isUserSignedIn {
                guard let error = error else {return}
                showAlertController(alertMessage: error.localizedDescription, withHandler: true)
                return
            }
            if error != nil {
                showAlertController(alertMessage: error!.localizedDescription, withHandler: false)
                return
            }
            guard let userData = userData else {return}
            userID = userData.userID
            profilePic = userData.profilePic
            initialUserEmail = userData.email
            DispatchQueue.main.async { [self] in
                editAccountImageView.kf.setImage(with: URL(string: userData.profilePic)!)
                editAccountFirstNameTextField.text = userData.firstName
                editAccountLastNameTextField.text = userData.lastname
                editAccountEmailTextField.text = userData.email
            }
        }
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
    
    func showLoadingButton() {
        editAccountButton.isHidden = true
        editAccountLoadingIndicatorView.startAnimating()
        editAccountLoadingIndicatorView.isHidden = false
    }
    
    func setEditAccountButtonToOriginalDesign() {
        editAccountLoadingIndicatorView.isHidden = true
        editAccountButton.isHidden = false
        Utilities.setDesignOn(button: editAccountButton, title: Strings.saveButtonText, fontName: Strings.defaultFontBold, fontSize: 20, titleColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), isCircular: true)
    }
    
    func dismissKeyboard() {
        editAccountFirstNameTextField.endEditing(true)
        editAccountLastNameTextField.endEditing(true)
        editAccountEmailTextField.endEditing(true)
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
    
    func showAlertController(alertMessage: String, withHandler: Bool) {
        if UserDefaults.standard.bool(forKey: Strings.isEditAccountVCLoadedKey) {
            if self.presentedViewController as? UIAlertController == nil {
                if withHandler {
                    let alertWithHandler = Utilities.showAlert(alertTitle: Strings.errorAlert, alertMessage: alertMessage, alertActionTitle1: Strings.dismissAlert, forSingleActionTitleWillItUseHandler: true) {
                        _ = Utilities.transition(from: self.view, to: Strings.landingVC, onStoryboard: Strings.guestStoryboard, canAccessDestinationProperties: false)
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
    
    
    //MARK: - UIGestureHandlers
    
    func registerGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler))
        editAccountImageView.isUserInteractionEnabled = true
        editAccountImageView.addGestureRecognizer(tapGesture)
    }
    
    @objc func tapGestureHandler() {
        present(imagePicker, animated: true)
    }
    
    
    //MARK: - Buttons
    
    func returnButtonTapped() {
        let field = userInfo()
        if field[Strings.userFirstNameField] != "" &&  field[Strings.userLastNameField] != "" && field[Strings.userEmailField] != "" {
            checkIfEmailIsVerified(using: field[Strings.userFirstNameField]!!, field[Strings.userLastNameField]!!, field[Strings.userEmailField]!!, field[Strings.userInitialUserEmail]!!)
        } else {
            showWarningLabel(on: editAccountWarningLabel, customizedWarning: Strings.editAccountTextFieldErrorLabel, isASuccessMessage: false)
        }
    }
    
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
            showWarningLabel(on: editAccountWarningLabel, customizedWarning: Strings.editAccountTextFieldErrorLabel, isASuccessMessage: false)
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
    
    func sendEmailVerification(with successLabel: String) {
        userData.sendEmailVerification { [self] (error, isUserSignedIn, isEmailVerificationSent) in
            if !isUserSignedIn {
                guard let error = error else {return}
                showAlertController(alertMessage: error.localizedDescription, withHandler: true)
                return
            }
            if error != nil {
                showWarningLabel(on: editAccountWarningLabel, with: error!, isASuccessMessage: false)
                Utilities.setDesignOn(button: editAccountButton, title: Strings.resendButtonText, fontName: Strings.defaultFontBold, fontSize: 20, titleColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), backgroundColor: #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1), isCircular: true)
                return
            }
            if isEmailVerificationSent {
                showWarningLabel(on: editAccountWarningLabel, customizedWarning: successLabel, isASuccessMessage: true)
                setEditAccountButtonToOriginalDesign()
            }
        }
    }
    
    func checkIfEmailIsVerified(using firstName: String, _ lastName: String, _ email: String, _ initialUserEmail: String) {
        userData.isEmailVerified { [self] (error, isUserSignedIn, isEmailVerified) in
            if !isUserSignedIn {
                guard let error = error else {return}
                showAlertController(alertMessage: error.localizedDescription, withHandler: true)
                setEditAccountButtonToOriginalDesign()
                return
            }
            if error != nil {
                showWarningLabel(on: editAccountWarningLabel, with: error!, isASuccessMessage: false)
                setEditAccountButtonToOriginalDesign()
                return
            }
            if isEmailVerified {
                showLoadingButton()
                updateAccount(using: firstName, lastName, email, initialUserEmail)
            } else {
                showWarningLabel(on: editAccountWarningLabel, customizedWarning: Strings.editAccountEmailVerficationErrorLabel, isASuccessMessage: false)
                Utilities.setDesignOn(button: editAccountButton, title: Strings.resendButtonText, fontName: Strings.defaultFontBold, fontSize: 20, titleColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), backgroundColor: #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1), isCircular: true)
            }
        }
    }
    
    func updateAccount(using firstName: String, _ lastName: String, _ email: String, _ initialUserEmail: String) {
        if editedImage != nil {
            userData.uploadProfilePic(with: editedImage!, using: userID) { [self] (error, chosenPic) in
                guard let error = error else {
                    guard let chosenPic = chosenPic else {return}
                    updateAccountProcess(using: firstName, lastName, email, chosenPic, initialUserEmail)
                    return
                }
                showWarningLabel(on: editAccountWarningLabel, with: error, isASuccessMessage: false)
            }
        } else {
            updateAccountProcess(using: firstName, lastName, email, profilePic, initialUserEmail)
        }
    }
    
    func updateAccountProcess(using firstName: String, _ lastName: String, _ email: String, _ profilePic: String, _ initialUserEmail: String) {
        if initialUserEmail != email {
            userData.updateUserData(firstName, lastName, email, profilePic) { [self] (error, isUserSignedIn, isUpdateFinished) in
                if !isUserSignedIn {
                    guard let error = error else {return}
                    showAlertController(alertMessage: error.localizedDescription, withHandler: true)
                    setEditAccountButtonToOriginalDesign()
                    return
                }
                if error != nil {
                    showWarningLabel(on: editAccountWarningLabel, with: error!, isASuccessMessage: false)
                    setEditAccountButtonToOriginalDesign()
                    return
                }
                if isUpdateFinished {
                    sendEmailVerification(with: Strings.editAccountProcessSuccessfulLabel)
                }
            }
        } else {
            userData.updateUserData(firstName, lastName, email, profilePic) { [self] (error, isUserSignedIn, isUpdateFinished) in
                if !isUserSignedIn {
                    guard let error = error else {return}
                    showAlertController(alertMessage: error.localizedDescription, withHandler: true)
                    setEditAccountButtonToOriginalDesign()
                    return
                }
                if error != nil {
                    showWarningLabel(on: editAccountWarningLabel, with: error!, isASuccessMessage: false)
                    setEditAccountButtonToOriginalDesign()
                    return
                }
                if isUpdateFinished {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        setEditAccountButtonToOriginalDesign()
                        NotificationCenter.default.post(name: Utilities.reloadUserData, object: nil)
                        NotificationCenter.default.post(name: Utilities.reloadProfilePic, object: nil)
                        dismiss(animated: true)
                    }
                }
            }
        }
    }
    
}


//MARK: - Image Picker & Navigation Delegate

extension EditAccountViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imagePicked = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        presentCropViewController(with: imagePicked)
    }
    
}


//MARK: - Crop View Controller Delegate

extension EditAccountViewController: CropViewControllerDelegate {
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        editAccountImageView.image = image
        editedImage = image
        let viewController = cropViewController.children.first!
        viewController.modalTransitionStyle = .coverVertical
        viewController.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
}


//MARK: - Text Field Delegate

extension EditAccountViewController: UITextFieldDelegate {
    
    // Exact moment when "return" button on keyboard is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        returnButtonTapped()
        dismissKeyboard()
        return true
    }
    
}

