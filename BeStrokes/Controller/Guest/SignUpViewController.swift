//
//  SignupController.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 11/3/20.
//

import UIKit
import FirebaseAuth
import Firebase
import CropViewController

class SignUpViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var validationMessage: UILabel!
    @IBOutlet weak var extraValidationMessage: UILabel!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loadingIcon: UIActivityIndicatorView!
    @IBOutlet weak var signUpButton: UIButton!
    
    
    //MARK: - Private Constants/Variables
    
    private var chosenImage: UIImage? = nil
    private let imagePicker = UIImagePickerController()
    private var imageIsChanged: Bool?
    
    
    //MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegate()
        designElements()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        firstNameTextField.becomeFirstResponder()
    }
    
    func setDelegate() {
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        imagePicker.delegate = self
        
    }
    
    
    //MARK: - Sign Up Process
    
    @IBAction func signUpButton(_ sender: UIButton) {
        Utilities.animateButton(button: sender)
        dismissKeyboard()
        imageIsValidated()
        textFieldsAreValidated()
        processSignUp()
    }
    
    func imageIsValidated() -> Bool {
        if imageIsChanged! {
            return true
        } else {
            Utilities.showAnimatedError(on: extraValidationMessage, withCustomizedString: Strings.profilePictureErrorMessage)
            return false
        }
    }
    
    func textFieldsAreValidated() -> Bool  {
        
        if firstNameTextField.text == "" || lastNameTextField.text == "" || emailTextField.text == "" || passwordTextField.text == "" {
            Utilities.showError(on: firstNameTextField, with: Strings.firstNameTextFieldErrorMessage)
            Utilities.showError(on: lastNameTextField, with: Strings.lastNameTextFieldErrorMessage)
            Utilities.showError(on: emailTextField, with: Strings.emailTextFieldErrorMessage)
            Utilities.showError(on: passwordTextField, with: Strings.passwordTextFieldErrorMessage)
            validationMessage.isHidden = true
        } else {
            return true
        }
        if passwordTextField.text != "" {
            if let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
                let passwordValid = Utilities.isPasswordValid(password)
                if passwordValid {
                    validationMessage.isHidden = true
                } else {
                    Utilities.showAnimatedError(on: validationMessage, withError: nil, withCustomizedString: Strings.passwordErrorMessage)
                }
            }
        }
        return false
    }
    
    func processSignUp() {
        
        if textFieldsAreValidated() && imageIsValidated() {
            if let firstName = firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
               let lastName = lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
               let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
               let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
                
                Auth.auth().createUser(withEmail: email, password: password) { [self] (authResult, error) in
                    if error != nil {
                        Utilities.showAnimatedError(on: validationMessage, withError: error)
                    } else {
                        // Successfuly created an account
                        animateSignUpButton()
                        storeDataToDB(firstName, lastName)
                    }
                }
            }
        }
    }
    
    func storeDataToDB(_ firstName: String, _ lastName: String) {
        
        guard let user = Auth.auth().currentUser else {return}
        let userID = user.uid
        let userEmail = user.email
        let db = Firestore.firestore()
        let query = db.collection(Strings.collectionName).document()
        let documentID = query.documentID
        var dictionary = [Strings.firstName: firstName, Strings.lastName: lastName, Strings.userEmailField : userEmail, Strings.UID: userID, Strings.userDocumentIDField: documentID]
        
        // We are setting the selected image in a guarded constant
        guard let imageSelected = chosenImage else {return}
        
        // Converting the selected image as a jpeg
        guard let imageData = imageSelected.jpegData(compressionQuality: 0.4) else {return}
        
        // Getting the Firebase storage URL and creating a folder inside of it to store the image
        let storageReference = Storage.storage().reference(forURL: Strings.firebaseStorageReference)
        let profilePicStorageReference = storageReference.child(Strings.profilePictureStorageReference).child(userID)
        
        // Setting propeties to the image
        let metadata = StorageMetadata()
        metadata.contentType = Strings.metadataContentType
        
        // Uploading of the image to the storage
        profilePicStorageReference.putData(imageData, metadata: metadata) { [self] (storageMetadata, error) in
            if error != nil {
                Utilities.showAnimatedError(on: validationMessage, withError: error)
            } else {
                
                // After succesfully uploaded we are downloading the image from the storage folder we created above
                profilePicStorageReference.downloadURL { (url, error) in
                    if error != nil {
                        Utilities.showAnimatedError(on: validationMessage, withError: error)
                    } else {
                        
                        // Changing of the URL to a string to feed it to our dictionary
                        if let imageURLLocation = url?.absoluteString {
                            dictionary[Strings.profilePicture] = imageURLLocation
                            
                            // Finally adding to the DB
                            query.setData(dictionary)
                            sendEmailVerification()
                        }
                    }
                }
            }
        }
    }
    
    func sendEmailVerification() {
        
        Auth.auth().currentUser?.sendEmailVerification(completion: { [self] (error) in
            if error != nil {
                Utilities.showAnimatedError(on: validationMessage, withError: error, withCustomizedString: nil)
            } else {
                Utilities.showAnimatedEmailVerificationSuccessfulySent(validationLabel: validationMessage)
                animateSignUpButtonToLogin()
                transtionToHome()
            }
        })
    }
    
    
    //MARK: - Design Elements
    
    func designElements() {
        
        UIScrollView.appearance().indicatorStyle = .white
        
        Utilities.putDesignOn(whitePopupHeadingLabel: headingLabel)
        Utilities.putDesignOn(errorLabel: validationMessage)
        Utilities.putDesignOn(errorLabel: extraValidationMessage)
        Utilities.putDesignOn(textField: firstNameTextField, placeholder: Strings.firstNamePlaceholder)
        Utilities.putDesignOn(textField: lastNameTextField, placeholder: Strings.lastNamePlaceholder)
        Utilities.putDesignOn(textField: emailTextField, placeholder: Strings.emailPlaceholder)
        Utilities.putDesignOn(textField: passwordTextField, placeholder: Strings.passwordPlaceholder)
        Utilities.putDesignOn(loadingIcon: loadingIcon)
        Utilities.putDesignOn(whiteButton: signUpButton)
        
        hideElements()
        setupProfilePictureIcon()
    }
    
    func setupProfilePictureIcon() {
        avatar.image = UIImage(named: Strings.defaultProfilePicture)
        imageIsChanged = false
        avatar.layer.cornerRadius = avatar.bounds.size.width / 2
        avatar.clipsToBounds = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler))
        avatar.isUserInteractionEnabled = true
        avatar.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func hideElements() {
        loadingIcon.isHidden = true
        validationMessage.isHidden = true
        extraValidationMessage.isHidden = true
    }
    
    @objc func tapGestureHandler() {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func dismissKeyboard() {
        firstNameTextField.endEditing(true)
        lastNameTextField.endEditing(true)
        emailTextField.endEditing(true)
        passwordTextField.endEditing(true)
        
    }
    
    func animateSignUpButton() {
        UIView.animate(withDuration: 0.3) { [self] in
            signUpButton.alpha = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [self] in
            signUpButton.isHidden = true
            loadingIcon.isHidden = false
            loadingIcon.startAnimating()
        }
    }
    
    func animateSignUpButtonToLogin() {
        loadingIcon.isHidden = true
        signUpButton.setTitle(Strings.changeSignUpButtonText, for: .normal)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [self] in
            signUpButton.isHidden = false
            UIView.animate(withDuration: 0.2) {
                signUpButton.alpha = 1
                signUpButton.isEnabled = false
            }
        }
    }
    
    func transtionToHome() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [self] in
            let HomeViewController = Utilities.transitionTo(storyboardName: Strings.userStoryboard, identifier: Strings.tabBarStoryboardID)
            view.window?.rootViewController = HomeViewController
            view.window?.makeKeyAndVisible()
        }
    }
    
}


extension SignUpViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        processSignUp()
        return true
    }
    
}


extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, CropViewControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            presentCropViewController(originalImage)
        }
        extraValidationMessage.isHidden = true
        imageIsChanged = true
    }
    
    func presentCropViewController(_ chosenImage: UIImage) {
        let cropViewController = CropViewController(croppingStyle: .circular, image: chosenImage)
        cropViewController.delegate = self
        dismiss(animated: true)
        present(cropViewController, animated: true, completion: nil)
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        chosenImage = image
        avatar.image = image
        let viewController = cropViewController.children.first!
        viewController.modalTransitionStyle = .coverVertical
        viewController.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
}

