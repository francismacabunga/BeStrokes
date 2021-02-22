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
    @IBOutlet weak var editAccountStackView: UIStackView!
    @IBOutlet weak var editAccountHeadingContentView: UIView!
    @IBOutlet weak var editAccountImageContentView: UIView!
    @IBOutlet weak var editAccountSaveButtonContentView: UIView!
    @IBOutlet weak var editAccountHeadingLabel: UILabel!
    @IBOutlet weak var editAccountImageView: UIImageView!
    @IBOutlet weak var editAccountCameraIconImageView: UIImageView!
    @IBOutlet weak var editAccountWarningLabel: UILabel!
    @IBOutlet weak var editAccountFirstNameLabel: UILabel!
    @IBOutlet weak var editAccountLastNameLabel: UILabel!
    @IBOutlet weak var editAccountEmailLabel: UILabel!
    @IBOutlet weak var editAccountFirstNameTextField: UITextField!
    @IBOutlet weak var editAccountLastNameTextField: UITextField!
    @IBOutlet weak var editAccountEmailTextField: UITextField!
    @IBOutlet weak var editAccountButton: UIButton!
    @IBOutlet weak var editAccountLoadingIndicatorView: UIActivityIndicatorView!
    
    
    //MARK: - Constants / Variables
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private var userViewModel: UserViewModel?
    private let user = User()
    private let imagePicker = UIImagePickerController()
    private var editedImage: UIImage?
    private lazy var userID = String()
    private lazy var profilePic = String()
    private lazy var initialUserEmail = String()
    
    
    //MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDesignElements()
        registerGestures()
        setDataSourceAndDelegate()
        setData()
        
    }
    
    
    //MARK: - Design Elements
    
    func setDesignElements() {
        Utilities.setDesignOn(view: view, backgroundColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1))
        Utilities.setDesignOn(view: editAccountHeadingContentView, backgroundColor: .clear)
        Utilities.setDesignOn(view: editAccountImageContentView, backgroundColor: .clear)
        editAccountImageContentView.layer.shadowColor = #colorLiteral(red: 0.6948884352, green: 0.6939979255, blue: 0.7095529112, alpha: 1)
        editAccountImageContentView.layer.shadowOpacity = 1
        editAccountImageContentView.layer.shadowOffset = .zero
        editAccountImageContentView.layer.shadowRadius = 5
        editAccountImageContentView.layer.masksToBounds = false
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
        Utilities.setDesignOn(button: editAccountButton, title: Strings.saveButtonText, fontName: Strings.defaultFontBold, fontSize: 20, titleColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), isCircular: true)
        Utilities.setDesignOn(activityIndicatorView: editAccountLoadingIndicatorView, size: .medium, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), isHidden: true)
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
        UIView.animate(withDuration: 0.3) { [self] in
            Utilities.setDesignOn(textField: editAccountFirstNameTextField, textColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), backgroundColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), placeholderTextColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
            Utilities.setDesignOn(textField: editAccountLastNameTextField, textColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), backgroundColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), placeholderTextColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
            Utilities.setDesignOn(textField: editAccountEmailTextField, textColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), backgroundColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), placeholderTextColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
            
            editAccountFirstNameTextField.borderStyle = .none
            editAccountFirstNameTextField.layer.shadowOpacity = 1
            editAccountFirstNameTextField.layer.shadowRadius = 2
            editAccountFirstNameTextField.layer.shadowOffset = .zero
            editAccountFirstNameTextField.layer.shadowColor = #colorLiteral(red: 0.6948884352, green: 0.6939979255, blue: 0.7095529112, alpha: 1)
            
            editAccountLastNameTextField.borderStyle = .none
            editAccountLastNameTextField.layer.shadowOpacity = 1
            editAccountLastNameTextField.layer.shadowRadius = 2
            editAccountLastNameTextField.layer.shadowOffset = .zero
            editAccountLastNameTextField.layer.shadowColor = #colorLiteral(red: 0.6948884352, green: 0.6939979255, blue: 0.7095529112, alpha: 1)
            
            editAccountEmailTextField.borderStyle = .none
            editAccountEmailTextField.layer.shadowOpacity = 1
            editAccountEmailTextField.layer.shadowRadius = 2
            editAccountEmailTextField.layer.shadowOffset = .zero
            editAccountEmailTextField.layer.shadowColor = #colorLiteral(red: 0.6948884352, green: 0.6939979255, blue: 0.7095529112, alpha: 1)
            
            editAccountButton.layer.shadowColor = #colorLiteral(red: 0.6948884352, green: 0.6939979255, blue: 0.7095529112, alpha: 1)
            editAccountButton.layer.shadowOpacity = 1
            editAccountButton.layer.shadowOffset = .zero
            editAccountButton.layer.shadowRadius = 2
            editAccountButton.layer.masksToBounds = false
            
            Utilities.setDesignOn(button: editAccountButton, titleColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), backgroundColor: .white)
        }
    }
    
    @objc func setDarkMode() {
        UIView.animate(withDuration: 0.3) { [self] in
            Utilities.setDesignOn(textField: editAccountFirstNameTextField, textColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), placeholderTextColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
            Utilities.setDesignOn(textField: editAccountLastNameTextField, textColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), placeholderTextColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
            Utilities.setDesignOn(textField: editAccountEmailTextField, textColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), placeholderTextColor: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
            
            editAccountFirstNameTextField.layer.shadowOpacity = 0
            editAccountFirstNameTextField.layer.shadowRadius = 0
            editAccountFirstNameTextField.layer.shadowOffset = .zero
            editAccountFirstNameTextField.layer.shadowColor = nil
            
            editAccountLastNameTextField.layer.shadowOpacity = 0
            editAccountLastNameTextField.layer.shadowRadius = 0
            editAccountLastNameTextField.layer.shadowOffset = .zero
            editAccountLastNameTextField.layer.shadowColor = nil
            
            editAccountEmailTextField.layer.shadowOpacity = 0
            editAccountEmailTextField.layer.shadowRadius = 0
            editAccountEmailTextField.layer.shadowOffset = .zero
            editAccountEmailTextField.layer.shadowColor = nil
            
            editAccountButton.layer.shadowColor = nil
            editAccountButton.layer.shadowOpacity = 0
            editAccountButton.layer.shadowOffset = .zero
            editAccountButton.layer.shadowRadius = 0
            editAccountButton.layer.masksToBounds = true
            
            Utilities.setDesignOn(button: editAccountButton, titleColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        }
    }
    
    func showSuccessfullyEditedAccountAlert() {
        let alert = UIAlertController(title: Strings.editAccountAlertTitle, message: Strings.editAccountAlertMessage, preferredStyle: .alert)
        present(alert, animated: true)
    }
    
    func showErrorFetchingAlert(usingError error: Bool, withErrorMessage: Error? = nil, withCustomizedString: String? = nil) {
        var alert = UIAlertController()
        if error {
            alert = UIAlertController(title: Strings.homeAlertTitle, message: withErrorMessage?.localizedDescription, preferredStyle: .alert)
        } else {
            alert = UIAlertController(title: Strings.homeAlertTitle, message: withCustomizedString, preferredStyle: .alert)
        }
        let tryAgainAction = UIAlertAction(title: Strings.homeAlert1Action, style: .default) { [self] (alertAction) in
            dismiss(animated: true)
        }
        alert.addAction(tryAgainAction)
        present(alert, animated: true)
    }
    
    func showNoSignedInUserAlert() {
        let alert = UIAlertController(title: Strings.homeAlertTitle, message: Strings.homeAlertMessage, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: Strings.homeAlert2Action, style: .default) { [self] (alertAction) in
            transitionToLandingVC()
        }
        alert.addAction(dismissAction)
        present(alert, animated: true)
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
    
    func showLoadingButton() {
        editAccountButton.isHidden = true
        editAccountLoadingIndicatorView.startAnimating()
        editAccountLoadingIndicatorView.isHidden = false
    }
    
    func presentCropViewController(with imagePicked: UIImage) {
        let cropViewController = CropViewController(croppingStyle: .circular, image: imagePicked)
        cropViewController.delegate = self
        dismiss(animated: true)
        present(cropViewController, animated: true, completion: nil)
    }
    
    func setResendButtonDesign() {
        Utilities.setDesignOn(button: editAccountButton, title: Strings.resendButtonText, fontName: Strings.defaultFontBold, fontSize: 20, titleColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), backgroundColor: #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1), isCircular: true)
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
    
    func transitionToLandingVC() {
        let storyboard = UIStoryboard(name: Strings.mainStoryboard, bundle: nil)
        let landingVC = storyboard.instantiateViewController(identifier: Strings.landingVC)
        view.window?.rootViewController = landingVC
        view.window?.makeKeyAndVisible()
    }
    
    func userData() -> [String : String?] {
        let firstName = editAccountFirstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let lastName = editAccountLastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let email = editAccountEmailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let userDataDictionary = [Strings.userFirstNameField: firstName,
                                  Strings.userLastNameField: lastName,
                                  Strings.userEmailField: email,
                                  Strings.userInitialUserEmail: initialUserEmail]
        return userDataDictionary
    }
    
    func setData() {
        user.getSignedInUserData { [self] (error, isUserSignedIn, userData) in
            guard let error = error else {
                if !isUserSignedIn {
                    showNoSignedInUserAlert()
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
                return
            }
            showErrorFetchingAlert(usingError: true, withErrorMessage: error)
        }
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
        let field = userData()
        if field[Strings.userFirstNameField] != "" &&  field[Strings.userLastNameField] != "" && field[Strings.userEmailField] != "" {
            checkIfEmailIsVerified(using: field[Strings.userFirstNameField]!!, field[Strings.userLastNameField]!!, field[Strings.userEmailField]!!, field[Strings.userInitialUserEmail]!!)
        } else {
            showWarningLabel(on: editAccountWarningLabel, customizedWarning: Strings.editAccountTextFieldErrorLabel, isASuccessMessage: false)
        }
    }
    
    @IBAction func editAccountSaveButton(_ sender: UIButton) {
        Utilities.animate(button: sender)
        let buttonCurrentTitle = sender.currentTitle
        let field = userData()
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
        user.sendEmailVerification { [self] (error, isEmailVerificationSent) in
            guard let error = error else {
                if isEmailVerificationSent {
                    showWarningLabel(on: editAccountWarningLabel, customizedWarning: successLabel, isASuccessMessage: true)
                    setEditAccountButtonToOriginalDesign()
                }
                return
            }
            showWarningLabel(on: editAccountWarningLabel, with: error, isASuccessMessage: false)
            setResendButtonDesign()
        }
    }
    
    func checkIfEmailIsVerified(using firstName: String, _ lastName: String, _ email: String, _ initialUserEmail: String) {
        user.isEmailVerified { [self] (error, isUserSignedIn, isEmailVerified) in
            guard let error = error else {
                if !isUserSignedIn {
                    showNoSignedInUserAlert()
                    setEditAccountButtonToOriginalDesign()
                    return
                }
                guard let isEmailVerified = isEmailVerified else {return}
                if isEmailVerified {
                    showLoadingButton()
                    updateAccount(using: firstName, lastName, email, initialUserEmail)
                } else {
                    showWarningLabel(on: editAccountWarningLabel, customizedWarning: Strings.editAccountEmailVerficationErrorLabel, isASuccessMessage: false)
                    setResendButtonDesign()
                }
                return
            }
            showWarningLabel(on: editAccountWarningLabel, with: error, isASuccessMessage: false)
            setEditAccountButtonToOriginalDesign()
        }
    }
    
    func updateAccount(using firstName: String, _ lastName: String, _ email: String, _ initialUserEmail: String) {
        if editedImage != nil {
            user.uploadProfilePic(with: editedImage!, using: userID) { [self] (error, chosenPic) in
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
            user.updateUserData(firstName, lastName, email, profilePic) { [self] (error, isUserSignedIn, isUpdateDataFinished) in
                guard let error = error else {
                    if !isUserSignedIn {
                        showNoSignedInUserAlert()
                        setEditAccountButtonToOriginalDesign()
                        return
                    }
                    if isUpdateDataFinished {
                        sendEmailVerification(with: Strings.editAccountProcessSuccessfulLabel)
                    }
                    return
                }
                showWarningLabel(on: editAccountWarningLabel, with: error, isASuccessMessage: false)
                setEditAccountButtonToOriginalDesign()
            }
        } else {
            user.updateUserData(firstName, lastName, email, profilePic) { [self] (error, isUserSignedIn, isUpdateDataFinished) in
                guard let error = error else {
                    if !isUserSignedIn {
                        showNoSignedInUserAlert()
                        setEditAccountButtonToOriginalDesign()
                        return
                    }
                    if isUpdateDataFinished {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            setEditAccountButtonToOriginalDesign()
                            dismiss(animated: true)
                        }
                    }
                    return
                }
                showWarningLabel(on: editAccountWarningLabel, with: error, isASuccessMessage: false)
                setEditAccountButtonToOriginalDesign()
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

