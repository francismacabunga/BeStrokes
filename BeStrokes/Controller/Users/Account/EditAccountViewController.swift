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
    @IBOutlet weak var editAccountSaveButton: UIButton!
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
        editAccountWarningLabel.isHidden = true
        editAccountLoadingIndicatorView.isHidden = true
        Utilities.setDesignOn(navigationBar: editAccountNavigationBar, isDarkMode: true)
        Utilities.setDesignOn(view: view, backgroundColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1))
        Utilities.setDesignOn(stackView: editAccountStackView, backgroundColor: .clear)
        Utilities.setDesignOn(view: editAccountHeadingContentView, backgroundColor: .clear)
        Utilities.setDesignOn(view: editAccountSaveButtonContentView, backgroundColor: .clear)
        Utilities.setDesignOn(label: editAccountHeadingLabel, font: Strings.defaultFontBold, fontSize: 35, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), numberofLines: 0, textAlignment: .left, lineBreakMode: .byWordWrapping, text: Strings.editAccountHeadingText)
        Utilities.setDesignOn(imageView: editAccountImageView, isCircular: true)
        Utilities.setDesignOn(imageView: editAccountCameraIconImageView, image: UIImage(named: Strings.cameraImage))
        Utilities.setDesignOn(label: editAccountWarningLabel, font: Strings.defaultFontBold, fontSize: 15, fontColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), numberofLines: 0, textAlignment: .center, lineBreakMode: .byWordWrapping, backgroundColor: #colorLiteral(red: 0.9673412442, green: 0.0823205933, blue: 0.006666854955, alpha: 1))
        Utilities.setDesignOn(label: editAccountFirstNameLabel, font: Strings.defaultFontBold, fontSize: 15, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), numberofLines: 1, textAlignment: .left, text: Strings.firstNameTextField)
        Utilities.setDesignOn(label: editAccountLastNameLabel, font: Strings.defaultFontBold, fontSize: 15, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), numberofLines: 1, textAlignment: .left, text: Strings.lastNameTextField)
        Utilities.setDesignOn(label: editAccountEmailLabel, font: Strings.defaultFontBold, fontSize: 15, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), numberofLines: 1, textAlignment: .left, text: Strings.emailTextField)
        Utilities.setDesignOn(textField: editAccountFirstNameTextField, font: Strings.defaultFont, fontSize: 15, autocorrectionType: .default, isSecureTextEntry: false, keyboardType: .default, textContentType: .name, textColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), placeholderTextColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), isCircular: true)
        Utilities.setDesignOn(textField: editAccountLastNameTextField, font: Strings.defaultFont, fontSize: 15, autocorrectionType: .default, isSecureTextEntry: false, keyboardType: .default, textContentType: .name, textColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), placeholderTextColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), isCircular: true)
        Utilities.setDesignOn(textField: editAccountEmailTextField, font: Strings.defaultFont, fontSize: 15, autocorrectionType: .no, isSecureTextEntry: false, keyboardType: .emailAddress, textContentType: .emailAddress, textColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), placeholderTextColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), isCircular: true)
        Utilities.setDesignOn(button: editAccountSaveButton, title: Strings.saveButtonText, font: Strings.defaultFontBold, fontSize: 20, titleColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), isCircular: true)
        Utilities.setDesignOn(activityIndicatorView: editAccountLoadingIndicatorView, size: .medium, backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        Utilities.animateButton(button: editAccountSaveButton)
    }
    
    func showAlert() {
        let alert = UIAlertController(title: Strings.editAccountAlertTitle, message: Strings.editAccountAlertMessage, preferredStyle: .alert)
        present(alert, animated: true)
    }
    
    func showWarningLabel(with error: Error? = nil, customizedWarning: String? = nil) {
        if error != nil {
            editAccountWarningLabel.text = error!.localizedDescription
        }
        if customizedWarning != nil {
            editAccountWarningLabel.text = customizedWarning!
        }
        UIView.animate(withDuration: 0.2) { [self] in
            editAccountWarningLabel.isHidden = false
        }
    }
    
    func showLoadingButton() {
        editAccountSaveButton.isHidden = true
        editAccountLoadingIndicatorView.startAnimating()
        editAccountLoadingIndicatorView.isHidden = false
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
    
    func transitionToLandingVC() {
        showAlert()
        editAccountLoadingIndicatorView.isHidden = true
        editAccountSaveButton.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [self] in
            user.signOutUser()
            let storyboard = UIStoryboard(name: Strings.mainStoryboard, bundle: nil)
            let landingVC = storyboard.instantiateViewController(identifier: Strings.landingVC)
            view.window?.rootViewController = landingVC
            view.window?.makeKeyAndVisible()
        }
    }
    
    func setData() {
        user.getSignedInUserData { [self] (result) in
            userID = result.userID
            profilePic = result.profilePic
            email = result.email
            DispatchQueue.main.async { [self] in
                editAccountImageView.kf.setImage(with: URL(string: result.profilePic)!)
                editAccountFirstNameTextField.text = result.firstName
                editAccountLastNameTextField.text = result.lastname
                editAccountEmailTextField.text = result.email
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
    
    @IBAction func editAccountSaveButton(_ sender: UIButton) {
        showLoadingButton()
        user.isEmailVerified { [self] (error, result) in
            if error != nil {
                showWarningLabel(with: error!)
                return
            }
            guard let isEmailVerified = result else {return}
            if isEmailVerified {
                processUpdateAccount()
                let initialEmail = email
                let newEmail = editAccountEmailLabel.text
                if initialEmail == newEmail {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        dismiss(animated: true)
                    }
                }
            } else {
                showWarningLabel(customizedWarning: Strings.editAccountEmailVerficationErrorLabel)
                return
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
    
    func processUpdateAccount() {
        let firstName = editAccountFirstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let lastName = editAccountLastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let email = editAccountEmailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let initialUserEmail = Auth.auth().currentUser?.email else {return}
        if firstName != "" && lastName != "" && email != "" {
            if editedImage != nil {
                user.uploadProfilePic(with: editedImage!, using: userID) { [self] (error, imageString) in
                    if error != nil {
                        showWarningLabel(with: error!)
                        return
                    }
                    guard let chosenPic = imageString else {return}
                    updateAccount(using: firstName!, lastName!, email!, chosenPic, initialUserEmail)
                }
            } else {
                updateAccount(using: firstName!, lastName!, email!, profilePic, initialUserEmail)
            }
        } else {
            showWarningLabel(customizedWarning: Strings.editAccountTextFieldErrorLabel)
        }
    }
    
    func updateAccount(using firstName: String, _ lastName: String, _ email: String, _ profilePic: String, _ initialUserEmail: String) {
        user.updateUserData(firstName, lastName, email, profilePic) { [self] (error) in
            if error != nil {
                showWarningLabel(with: error!)
                return
            }
            if initialUserEmail != email {
                user.sendEmailVerification { [self] (error, isEmailVerificationSent) in
                    if error != nil {
                        showWarningLabel(with: error!)
                        return
                    }
                    if isEmailVerificationSent {
                        transitionToLandingVC()
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
        dismissKeyboard()
        processUpdateAccount()
        return true
    }
    
    // Checks the current text field you're at before tapping to a new one
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text == "" {
            UIView.animate(withDuration: 0.2) { [self] in
                editAccountWarningLabel.text = Strings.editAccountTextFieldErrorLabel
                editAccountWarningLabel.isHidden = false
            }
            return false
        } else {
            return true
        }
    }
    
}

