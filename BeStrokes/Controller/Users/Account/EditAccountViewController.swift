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
    @IBOutlet weak var editAccountSaveButtonContentView: UIView!
    @IBOutlet weak var editAccountHeadingLabel: UILabel!
    @IBOutlet weak var editAccountImageView: UIImageView!
    @IBOutlet weak var editAccountCameraIconImageView: UIImageView!
    @IBOutlet weak var editAccount1Label: UILabel!
    @IBOutlet weak var editAccount2Label: UILabel!
    @IBOutlet weak var editAccount3Label: UILabel!
    @IBOutlet weak var editAccount4Label: UILabel!
    @IBOutlet weak var editAccount1TextField: UITextField!
    @IBOutlet weak var editAccount2TextField: UITextField!
    @IBOutlet weak var editAccount3TextField: UITextField!
    @IBOutlet weak var editAccountSaveButtonLabel: UIButton!
    
    
    //MARK: - Constants / Variables
    
    var userViewModel: UserViewModel!
    private let user = User()
    private let imagePicker = UIImagePickerController()
    private var editedImage: UIImage?
    
    
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
        editAccount4Label.isHidden = true
        Utilities.setDesignOn(navigationBar: editAccountNavigationBar, isDarkMode: true)
        Utilities.setDesignOn(view: view, backgroundColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1))
        Utilities.setDesignOn(stackView: editAccountStackView, backgroundColor: .clear)
        Utilities.setDesignOn(view: editAccountHeadingContentView, backgroundColor: .clear)
        Utilities.setDesignOn(view: editAccountSaveButtonContentView, backgroundColor: .clear)
        Utilities.setDesignOn(label: editAccountHeadingLabel, font: Strings.defaultFontBold, fontSize: 35, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), numberofLines: 0, textAlignment: .left, lineBreakMode: .byWordWrapping, text: Strings.editAccountHeadingText)
        Utilities.setDesignOn(imageView: editAccountImageView, isPerfectCircle: true)
        Utilities.setDesignOn(imageView: editAccountCameraIconImageView, image: UIImage(named: Strings.cameraImage))
        Utilities.setDesignOn(label: editAccount1Label, font: Strings.defaultFontBold, fontSize: 15, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), numberofLines: 1, textAlignment: .left, text: Strings.firstNameTextField)
        Utilities.setDesignOn(label: editAccount2Label, font: Strings.defaultFontBold, fontSize: 15, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), numberofLines: 1, textAlignment: .left, text: Strings.lastNameTextField)
        Utilities.setDesignOn(label: editAccount3Label, font: Strings.defaultFontBold, fontSize: 15, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), numberofLines: 1, textAlignment: .left, text: Strings.emailTextField)
        Utilities.setDesignOn(label: editAccount4Label, font: Strings.defaultFontBold, fontSize: 15, fontColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), numberofLines: 0, textAlignment: .center, lineBreakMode: .byWordWrapping, backgroundColor: #colorLiteral(red: 0.970628202, green: 0.08276668936, blue: 0.005421592388, alpha: 1))
        Utilities.setDesignOn(textField: editAccount1TextField, font: Strings.defaultFont, fontSize: 15, textColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), placeholderTextColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), isCircular: true)
        Utilities.setDesignOn(textField: editAccount2TextField, font: Strings.defaultFont, fontSize: 15, textColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), placeholderTextColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), isCircular: true)
        Utilities.setDesignOn(textField: editAccount3TextField, font: Strings.defaultFont, fontSize: 15, textColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), placeholderTextColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), isCircular: true)
        Utilities.setDesignOn(button: editAccountSaveButtonLabel, title: Strings.saveButtonText, font: Strings.defaultFontBold, fontSize: 20, titleColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), isCircular: true, backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
    }
    
    func dismissKeyboard() {
        editAccount1TextField.endEditing(true)
        editAccount2TextField.endEditing(true)
        editAccount3TextField.endEditing(true)
    }
    
    func setData() {
        DispatchQueue.main.async { [self] in
            editAccountImageView.kf.setImage(with: URL(string: userViewModel.profilePic))
            editAccount1TextField.text = userViewModel.firstName
            editAccount2TextField.text = userViewModel.lastname
            editAccount3TextField.text = userViewModel.email
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
        if user.isEmailVerified() {
            updateAccountProcess()
        } else {
            // Show error message
            UIView.animate(withDuration: 0.2) { [self] in
                editAccount4Label.text = Strings.editAccountEmailVerficationErrorLabel
                editAccount4Label.isHidden = false
            }
        }
    }
    
    
    //MARK: - Edit Account Process
    
    func setDataSourceAndDelegate() {
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        editAccount1TextField.delegate = self
        editAccount2TextField.delegate = self
        editAccount3TextField.delegate = self
    }
    
    func updateAccountProcess() {
        let firstName = editAccount1TextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let lastName = editAccount2TextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let email = editAccount3TextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if firstName != "" && lastName != "" && email != "" {
            if editedImage != nil {
                user.uploadProfilePic(with: editedImage!, using: userViewModel.userID) { [self] (imageString) in
                    user.updateUserData(firstName!, lastName!, email!, imageString)
                }
            } else {
                user.updateUserData(firstName!, lastName!, email!, userViewModel.profilePic)
            }
        } else {
            UIView.animate(withDuration: 0.2) { [self] in
                editAccount4Label.text = Strings.editAccountTextFieldErrorLabel
                editAccount4Label.isHidden = false
            }
        }
    }
    
}


//MARK: - Image Picker Delegate / Crop View Controller Delegate

extension EditAccountViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate, CropViewControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imagePicked = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            presentCropViewController(with: imagePicked)
        }
    }
    
    func presentCropViewController(with imagePicked: UIImage) {
        let cropViewController = CropViewController(croppingStyle: .circular, image: imagePicked)
        cropViewController.delegate = self
        dismiss(animated: true)
        present(cropViewController, animated: true, completion: nil)
    }
    
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
        updateAccountProcess()
        return true
    }
    
    // Checks the current text field you're at before tapping to a new one
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text == "" {
            UIView.animate(withDuration: 0.2) { [self] in
                editAccount4Label.text = Strings.editAccountTextFieldErrorLabel
                editAccount4Label.isHidden = false
            }
            return false
        } else {
            return true
        }
    }
    
}

