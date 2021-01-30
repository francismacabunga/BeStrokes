//
//  EditAccountViewController.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 1/10/21.
//

import UIKit
import CropViewController
import Kingfisher
import Firebase

class EditAccountViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var editAccountNavigationBar: UINavigationBar!
    @IBOutlet weak var editAccountStackView: UIStackView!
    @IBOutlet weak var editAccountHeadingContentView: UIView!
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
    
    private var userViewModel: UserViewModel?
    private let user = User()
    private let imagePicker = UIImagePickerController()
    private var editedImage: UIImage?
    private lazy var userID = String()
    private lazy var profilePic = String()
    private lazy var email = String()
    
    
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
        editAccountLoadingIndicatorView.isHidden = true
        editAccountWarningLabel.isHidden = true
        Utilities.setDesignOn(view: view, backgroundColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1))
        Utilities.setDesignOn(view: editAccountHeadingContentView, backgroundColor: .clear)
        Utilities.setDesignOn(view: editAccountSaveButtonContentView, backgroundColor: .clear)
        Utilities.setDesignOn(stackView: editAccountStackView, backgroundColor: .clear)
        Utilities.setDesignOn(navigationBar: editAccountNavigationBar, isDarkMode: true)
        Utilities.setDesignOn(imageView: editAccountImageView, isCircular: true)
        Utilities.setDesignOn(imageView: editAccountCameraIconImageView, image: UIImage(named: Strings.cameraImage))
        Utilities.setDesignOn(label: editAccountHeadingLabel, font: Strings.defaultFontBold, fontSize: 35, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), numberofLines: 0, textAlignment: .left, lineBreakMode: .byWordWrapping, text: Strings.editAccountHeadingText)
        Utilities.setDesignOn(label: editAccountFirstNameLabel, font: Strings.defaultFontBold, fontSize: 15, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), numberofLines: 1, textAlignment: .left, text: Strings.firstNameTextField)
        Utilities.setDesignOn(label: editAccountLastNameLabel, font: Strings.defaultFontBold, fontSize: 15, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), numberofLines: 1, textAlignment: .left, text: Strings.lastNameTextField)
        Utilities.setDesignOn(label: editAccountEmailLabel, font: Strings.defaultFontBold, fontSize: 15, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), numberofLines: 1, textAlignment: .left, text: Strings.emailTextField)
        Utilities.setDesignOn(textField: editAccountFirstNameTextField, font: Strings.defaultFont, fontSize: 15, autocorrectionType: .default, isSecureTextEntry: false, keyboardType: .default, textContentType: .name, textColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), placeholderTextColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), isCircular: true)
        Utilities.setDesignOn(textField: editAccountLastNameTextField, font: Strings.defaultFont, fontSize: 15, autocorrectionType: .default, isSecureTextEntry: false, keyboardType: .default, textContentType: .name, textColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), placeholderTextColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), isCircular: true)
        Utilities.setDesignOn(textField: editAccountEmailTextField, font: Strings.defaultFont, fontSize: 15, autocorrectionType: .no, isSecureTextEntry: false, keyboardType: .emailAddress, textContentType: .emailAddress, textColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), placeholderTextColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), isCircular: true)
        Utilities.setDesignOn(button: editAccountButton, title: Strings.saveButtonText, font: Strings.defaultFontBold, fontSize: 20, titleColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), isCircular: true)
        Utilities.setDesignOn(activityIndicatorView: editAccountLoadingIndicatorView, size: .medium, backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
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
            Utilities.setDesignOn(label: label, font: Strings.defaultFontBold, fontSize: 15, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), numberofLines: 0, textAlignment: .center, lineBreakMode: .byWordWrapping, backgroundColor: #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1))
        } else {
            Utilities.setDesignOn(label: label, font: Strings.defaultFontBold, fontSize: 15, fontColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), numberofLines: 0, textAlignment: .center, lineBreakMode: .byWordWrapping, backgroundColor: #colorLiteral(red: 0.9673412442, green: 0.0823205933, blue: 0.006666854955, alpha: 1))
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
    
    func setResendButtonDesign() {
        Utilities.setDesignOn(button: editAccountButton, title: Strings.resendButtonText, font: Strings.defaultFontBold, fontSize: 20, titleColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), backgroundColor: #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1), isCircular: true)
    }
    
    func setEditAccountButtonToOriginalDesign() {
        editAccountLoadingIndicatorView.isHidden = true
        editAccountButton.isHidden = false
        Utilities.setDesignOn(button: editAccountButton, title: Strings.saveButtonText, font: Strings.defaultFontBold, fontSize: 20, titleColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), isCircular: true)
    }
    
    func presentCropViewController(with imagePicked: UIImage) {
        let cropViewController = CropViewController(croppingStyle: .circular, image: imagePicked)
        cropViewController.delegate = self
        dismiss(animated: true)
        present(cropViewController, animated: true, completion: nil)
    }
    
    func dismissKeyboard() {
        editAccountFirstNameTextField.endEditing(true)
        editAccountLastNameTextField.endEditing(true)
        editAccountEmailTextField.endEditing(true)
    }
    
    func userData() -> [String: String?] {
        let firstName = editAccountFirstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let lastName = editAccountLastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let email = editAccountEmailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let initialUserEmail = Auth.auth().currentUser?.email
        let userDataDictionary = [Strings.userFirstNameField: firstName, Strings.userLastNameField: lastName, Strings.userEmailField: email, Strings.userInitialUserEmail: initialUserEmail]
        return userDataDictionary
    }
    
    func transitionToLandingVC() {
        let storyboard = UIStoryboard(name: Strings.mainStoryboard, bundle: nil)
        let landingVC = storyboard.instantiateViewController(identifier: Strings.landingVC)
        view.window?.rootViewController = landingVC
        view.window?.makeKeyAndVisible()
    }
    
    func setData() {
        user.getSignedInUserData { [self] (error, isUserSignedIn, userData) in
            if error != nil {
                showErrorFetchingAlert(usingError: true, withErrorMessage: error!)
                return
            }
            if !isUserSignedIn {
                showNoSignedInUserAlert()
                return
            }
            guard let userData = userData else {return}
            userID = userData.userID
            profilePic = userData.profilePic
            email = userData.email
            DispatchQueue.main.async { [self] in
                editAccountImageView.kf.setImage(with: URL(string: userData.profilePic)!)
                editAccountFirstNameTextField.text = userData.firstName
                editAccountLastNameTextField.text = userData.lastname
                editAccountEmailTextField.text = userData.email
            }
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
        Utilities.animateButton(button: sender)
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
    
    func checkIfEmailIsVerified(using firstName: String, _ lastName: String, _ email: String, _ initialUserEmail: String) {
        user.isEmailVerified { [self] (error, isUserSignedIn, isEmailVerified) in
            if error != nil {
                showWarningLabel(on: editAccountWarningLabel, with: error!, isASuccessMessage: false)
                setEditAccountButtonToOriginalDesign()
                return
            }
            if !isUserSignedIn {
                showNoSignedInUserAlert()
                setEditAccountButtonToOriginalDesign()
                return
            }
            guard let isEmailVerified = isEmailVerified else {return}
            if isEmailVerified {
                showLoadingButton()
                processUpdateAccount(using: firstName, lastName, email, initialUserEmail)
            } else {
                showWarningLabel(on: editAccountWarningLabel, customizedWarning: Strings.editAccountEmailVerficationErrorLabel, isASuccessMessage: false)
                setResendButtonDesign()
            }
        }
    }
    
    func sendEmailVerification(with successLabel: String) {
        user.sendEmailVerification { [self] (error, isEmailVerificationSent) in
            if error != nil {
                showWarningLabel(on: editAccountWarningLabel, with: error!, isASuccessMessage: false)
                setEditAccountButtonToOriginalDesign()
                return
            }
            if isEmailVerificationSent {
                showWarningLabel(on: editAccountWarningLabel, customizedWarning: successLabel, isASuccessMessage: true)
                setEditAccountButtonToOriginalDesign()
            }
        }
    }
    
    func processUpdateAccount(using firstName: String, _ lastName: String, _ email: String, _ initialUserEmail: String) {
        if editedImage != nil {
            user.uploadProfilePic(with: editedImage!, using: userID) { [self] (error, imageString) in
                if error != nil {
                    showWarningLabel(on: editAccountWarningLabel, with: error!, isASuccessMessage: false)
                    return
                }
                guard let chosenPic = imageString else {return}
                updateAccount(using: firstName, lastName, email, chosenPic, initialUserEmail)
            }
        } else {
            updateAccount(using: firstName, lastName, email, profilePic, initialUserEmail)
        }
    }
    
    func updateAccount(using firstName: String, _ lastName: String, _ email: String, _ profilePic: String, _ initialUserEmail: String) {
        if initialUserEmail != email {
            user.updateUserData(firstName, lastName, email, profilePic) { [self] (error, isUserSignedIn, isUpdateDataFinished) in
                if error != nil {
                    showWarningLabel(on: editAccountWarningLabel, with: error!, isASuccessMessage: false)
                    setEditAccountButtonToOriginalDesign()
                    return
                }
                if !isUserSignedIn {
                    showNoSignedInUserAlert()
                    setEditAccountButtonToOriginalDesign()
                    return
                }
                if isUpdateDataFinished {
                    sendEmailVerification(with: Strings.editAccountProcessSuccessfulLabel)
                }
            }
        } else {
            user.updateUserData(firstName, lastName, email, profilePic) { [self] (error, isUserSignedIn, isUpdateDataFinished) in
                if error != nil {
                    showWarningLabel(on: editAccountWarningLabel, with: error!, isASuccessMessage: false)
                    setEditAccountButtonToOriginalDesign()
                    return
                }
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
            }
        }
    }
    
}


//MARK: - Image Picker & Navigation Delegate

extension EditAccountViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imagePicked = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            presentCropViewController(with: imagePicked)
        }
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

