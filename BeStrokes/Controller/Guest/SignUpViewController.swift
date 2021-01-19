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
    
    @IBOutlet weak var signUpContentView: UIView!
    @IBOutlet weak var signUpHeadingStackView: UIStackView!
    @IBOutlet weak var signUpTextFieldsStackView: UIStackView!
    @IBOutlet weak var signUpNavigationBar: UINavigationBar!
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
    private var user = User()
    
    
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
        Utilities.setDesignOn(label: signUpWarning1Label, font: Strings.defaultFontBold, fontSize: 15, fontColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), numberofLines: 0, textAlignment: .center, lineBreakMode: .byWordWrapping, backgroundColor: #colorLiteral(red: 0.9673412442, green: 0.0823205933, blue: 0.006666854955, alpha: 1))
        Utilities.setDesignOn(label: signUpWarning2Label, font: Strings.defaultFontBold, fontSize: 15, fontColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), numberofLines: 0, textAlignment: .center, lineBreakMode: .byWordWrapping, backgroundColor: #colorLiteral(red: 0.9673412442, green: 0.0823205933, blue: 0.006666854955, alpha: 1))
        Utilities.setDesignOn(textField: signUpFirstNameTextField, font: Strings.defaultFont, fontSize: 15, textColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), backgroundColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), placeholder: Strings.firstNameTextField, placeholderTextColor: #colorLiteral(red: 0.5411764706, green: 0.5411764706, blue: 0.5411764706, alpha: 1), isCircular: true)
        Utilities.setDesignOn(textField: signUpLastNameTextField, font: Strings.defaultFont, fontSize: 15, textColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), backgroundColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), placeholder: Strings.lastNameTextField, placeholderTextColor: #colorLiteral(red: 0.5411764706, green: 0.5411764706, blue: 0.5411764706, alpha: 1), isCircular: true)
        Utilities.setDesignOn(textField: signUpEmailTextField, font: Strings.defaultFont, fontSize: 15, textColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), backgroundColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), placeholder: Strings.emailTextField, placeholderTextColor: #colorLiteral(red: 0.5411764706, green: 0.5411764706, blue: 0.5411764706, alpha: 1), isCircular: true)
        Utilities.setDesignOn(textField: signUpPasswordTextField, font: Strings.defaultFont, fontSize: 15, textColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), backgroundColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), placeholder: Strings.passwordTextField, placeholderTextColor: #colorLiteral(red: 0.5411764706, green: 0.5411764706, blue: 0.5411764706, alpha: 1), isCircular: true)
        Utilities.setDesignOn(activityIndicatorView: signUpLoadingIndicatorView, size: .medium, backgroundColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1))
        Utilities.setDesignOn(button: signUpButton, title: Strings.signUpButtonText, font: Strings.defaultFontBold, fontSize: 20, titleColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), backgroundColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), isCircular: true)
    }
    
    func presentCropViewController(_ imagePicked: UIImage) {
        let cropViewController = CropViewController(croppingStyle: .circular, image: imagePicked)
        cropViewController.delegate = self
        dismiss(animated: true)
        present(cropViewController, animated: true, completion: nil)
    }
    
  
    
 
    
    
    
    func dismissKeyboard() {
        signUpFirstNameTextField.endEditing(true)
        signUpLastNameTextField.endEditing(true)
        signUpEmailTextField.endEditing(true)
        signUpPasswordTextField.endEditing(true)
    }
    
    
    
    func animateSignUpButton() {
        UIView.animate(withDuration: 0.3) { [self] in
            signUpButton.alpha = 0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [self] in
            signUpButton.isHidden = true
//            loadingIcon.isHidden = false
//            loadingIcon.startAnimating()
        }
    }
    
    func animateSignUpButtonToLogin() {
//        loadingIcon.isHidden = true
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
        
        dismissKeyboard()
        validateProfilePicture()
        validateTextFields()
        processSignUp()
        
        
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
 
    
    
    
    func validateTextFields() -> Bool {
        if signUpFirstNameTextField.text == "" || signUpLastNameTextField.text == "" || signUpEmailTextField.text == "" || signUpPasswordTextField.text == "" {
            Utilities.setDesignOn(textField: signUpFirstNameTextField, font: Strings.defaultFont, fontSize: 15, placeholder: Strings.signUpFirstNameTextFieldErrorLabel, placeholderTextColor: #colorLiteral(red: 0.9673412442, green: 0.0823205933, blue: 0.006666854955, alpha: 1))
            Utilities.setDesignOn(textField: signUpLastNameTextField, font: Strings.defaultFont, fontSize: 15, placeholder: Strings.signUpLastNameTextFieldErrorLabel, placeholderTextColor: #colorLiteral(red: 0.9673412442, green: 0.0823205933, blue: 0.006666854955, alpha: 1))
            Utilities.setDesignOn(textField: signUpEmailTextField, font: Strings.defaultFont, fontSize: 15, placeholder: Strings.signUpEmailTextFieldErrorLabel, placeholderTextColor: #colorLiteral(red: 0.9673412442, green: 0.0823205933, blue: 0.006666854955, alpha: 1))
            Utilities.setDesignOn(textField: signUpPasswordTextField, font: Strings.defaultFont, fontSize: 15, placeholder: Strings.signUpPasswordTextFieldErrorLabel, placeholderTextColor: #colorLiteral(red: 0.9673412442, green: 0.0823205933, blue: 0.006666854955, alpha: 1))
        } else {
            if signUpPasswordTextField.text != "" {
                if let password = signUpPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
                    let passwordValid = Utilities.isPasswordValid(password)
                    if passwordValid {
//                        UIView.animate(withDuration: 0.2) { [self] in
//                            signUpWarning1Label.isHidden = true
//                        }
                        return true
                    } else {
                        signUpWarning1Label.text = Strings.signUpPasswordErrorLabel
                        UIView.animate(withDuration: 0.2) { [self] in
                            signUpWarning1Label.isHidden = false
                        }
                        return false
                    }
                }
            }
        }
        return false
    }
    
    func validateProfilePicture() -> Bool {
        if imageIsChanged {
            return true
        } else {
            signUpWarning2Label.text = Strings.signUpProfilePictureErrorLabel
            UIView.animate(withDuration: 0.2) { [self] in
                signUpWarning2Label.isHidden = false
            }
            return false
        }
    }
    
    
    
    func processSignUp() {
        
        
        
        

        if validateTextFields() && validateProfilePicture() {
            print("PROCEED")
            if let firstName = signUpFirstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
               let lastName = signUpLastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
               let email = signUpEmailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
               let password = signUpPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) {

                user.createUser(withEmail: email, password: password) { [self] (error) in
                    if error != nil {
                        signUpWarning1Label.text = error!.localizedDescription
                        UIView.animate(withDuration: 0.2) { [self] in
                            signUpWarning1Label.isHidden = false
                        }
                        return
                    }
                    
                }
                
                
//                user.createUser(withEmail: email, password: lastName) { [self] (result) in
//                    if result {
//                        let userID = user.user!.uid
//                        let documentID = user.usersDocumentID.documentID
//                        user.uploadProfilePic(with: editedImage!, using: userID) { (imageString) in
//                            let dictionary = ["firstName" : firstName, "lastName" : lastName, "email" : email, "password" : password, "profilePic" : imageString, "documentID" : documentID]
//                        }
//                    } else {
//                        // Show error cannot create account now
//                    }
//                }
                
                
                
//                Auth.auth().createUser(withEmail: email, password: password) { [self] (authResult, error) in
//                    if error != nil {
//                        Utilities.showAnimatedError(on: validationMessage, withError: error)
//                    } else {
//                        // Successfuly created an account
//                        animateSignUpButton()
//                        storeDataToDB(firstName, lastName)
//                    }
//                }
                
                
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
        var dictionary = [Strings.firstName: firstName, Strings.lastName: lastName, Strings.userEmailField: userEmail, Strings.UID: userID, Strings.userDocumentIDField: documentID]
        
        // We are setting the selected image in a guarded constant
        guard let imageSelected = editedImage else {return}
        
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
//                Utilities.showAnimatedError(on: validationMessage, withError: error)
            } else {
                
                // After succesfully uploaded we are downloading the image from the storage folder we created above
                profilePicStorageReference.downloadURL { (url, error) in
                    if error != nil {
//                        Utilities.showAnimatedError(on: validationMessage, withError: error)
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
//                Utilities.showAnimatedError(on: validationMessage, withError: error, withCustomizedString: nil)
            } else {
//                Utilities.showAnimatedEmailVerificationSuccessfulySent(validationLabel: validationMessage)
                animateSignUpButtonToLogin()
                transtionToHome()
            }
        })
    }
    
    

    
    
    
}


//MARK: - Image Picker & Navigation Delegate

extension SignUpViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imagePicked = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            presentCropViewController(imagePicked)
        }
        imageIsChanged = true
        UIView.animate(withDuration: 0.2) { [self] in
            signUpWarning2Label.isHidden = true
        }
    }
    
}


//MARK: - Crop View Controller Delegate

extension SignUpViewController: CropViewControllerDelegate {
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        editedImage = image
        signUpImageView.image = image
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
