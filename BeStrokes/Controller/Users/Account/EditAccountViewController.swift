//
//  EditAccountViewController.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 1/10/21.
//

import UIKit
import CropViewController

class EditAccountViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var editAccountNavigationBar: UINavigationBar!
    @IBOutlet weak var editAccountStackView: UIStackView!
    @IBOutlet weak var editAccountHeadingContentView: UIView!
    @IBOutlet weak var editAccountSaveButtonContentView: UIView!
    @IBOutlet weak var editAccountHeadingLabelText: UILabel!
    @IBOutlet weak var editAccountImageView: UIImageView!
    @IBOutlet weak var editAccountCameraIconImageView: UIImageView!
    @IBOutlet weak var editAccountLabel1Text: UILabel!
    @IBOutlet weak var editAccountLabel2Text: UILabel!
    @IBOutlet weak var editAccountLabel3Text: UILabel!
    @IBOutlet weak var editAccountLabel4Text: UILabel!
    @IBOutlet weak var editAccountTextField1: UITextField!
    @IBOutlet weak var editAccountTextField2: UITextField!
    @IBOutlet weak var editAccountTextField3: UITextField!
    @IBOutlet weak var editAccountSaveButtonLabel: UIButton!
    
    
    
    
    
    
    
    
    //MARK: - Constants / Variables
    
    var userViewModel: UserViewModel!
    private let imagePicker = UIImagePickerController()
    private let user = User()
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
        editAccountLabel4Text.isHidden = true
        
        
        
        Utilities.setDesignOn(navigationBar: editAccountNavigationBar, isDarkMode: true)
        Utilities.setDesignOn(view: view, backgroundColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1))
        Utilities.setDesignOn(stackView: editAccountStackView, backgroundColor: .clear)
        Utilities.setDesignOn(view: editAccountHeadingContentView, backgroundColor: .clear)
        Utilities.setDesignOn(view: editAccountSaveButtonContentView, backgroundColor: .clear)
        Utilities.setDesignOn(label: editAccountHeadingLabelText, font: Strings.defaultFontBold, fontSize: 35, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), numberofLines: 0, textAlignment: .left, lineBreakMode: .byWordWrapping, text: "Update Account")
        Utilities.setDesignOn(imageView: editAccountImageView, isPerfectCircle: true)
        Utilities.setDesignOn(imageView: editAccountCameraIconImageView, image: UIImage(named: "Camera"))
        Utilities.setDesignOn(label: editAccountLabel1Text, font: Strings.defaultFontBold, fontSize: 15, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), numberofLines: 1, textAlignment: .left, text: "First Name")
        Utilities.setDesignOn(label: editAccountLabel2Text, font: Strings.defaultFontBold, fontSize: 15, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), numberofLines: 1, textAlignment: .left, text: "Last Name")
        Utilities.setDesignOn(label: editAccountLabel3Text, font: Strings.defaultFontBold, fontSize: 15, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), numberofLines: 1, textAlignment: .left, text: "Email")
        Utilities.setDesignOn(label: editAccountLabel4Text, font: Strings.defaultFontBold, fontSize: 15, fontColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), numberofLines: 0, textAlignment: .center, lineBreakMode: .byWordWrapping, text: "Hello this is a test!", backgroundColor: #colorLiteral(red: 0.970628202, green: 0.08276668936, blue: 0.005421592388, alpha: 1))
        Utilities.setDesignOn(textField: editAccountTextField1, font: Strings.defaultFont, fontSize: 15, textColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), placeholderTextColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), isCircular: true)
        Utilities.setDesignOn(textField: editAccountTextField2, font: Strings.defaultFont, fontSize: 15, textColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), placeholderTextColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), isCircular: true)
        Utilities.setDesignOn(textField: editAccountTextField3, font: Strings.defaultFont, fontSize: 15, textColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), placeholderTextColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), isCircular: true)
        Utilities.setDesignOn(button: editAccountSaveButtonLabel, title: "Save", font: Strings.defaultFontBold, fontSize: 20, titleColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), isCircular: true, backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
    }
    
    func dismissKeyboard() {
        editAccountTextField1.endEditing(true)
        editAccountTextField2.endEditing(true)
        editAccountTextField3.endEditing(true)
    }
    
    func setData() {
        editAccountImageView.kf.setImage(with: URL(string: userViewModel.profilePic))
        //        editAccountTextField1.text = userViewModel.firstName
        //        editAccountTextField2.text = userViewModel.lastname
        //        editAccountTextField3.text = userViewModel.email
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
    
    
    func setDataSourceAndDelegate() {
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        editAccountTextField1.delegate = self
        editAccountTextField2.delegate = self
        editAccountTextField3.delegate = self
    }
    
    
    
    func updateAccountProcess() {
        
        let firstName = editAccountTextField1.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let lastName = editAccountTextField2.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let email = editAccountTextField3.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if firstName != "" && lastName != "" && email != "" {
            print("Completed fields")
            if editedImage != nil {
                print("Nagpalit ng pic")
                user.uploadProfilePic(with: editedImage!, using: userViewModel.userID) { [self] (imageString) in
                    user.updateUserData(firstName!, lastName!, email!, imageString)
                }
            } else {
                print("Hindi nagpalit")
                user.updateUserData(firstName!, lastName!, email!, userViewModel.profilePic)
            }
        } else {
            print("Incomplete fields")
            UIView.animate(withDuration: 0.2) { [self] in
                editAccountLabel4Text.text = "Incomplete fields"
                editAccountLabel4Text.isHidden = false
            }
        }
        
    }
    
    
    
    
    
    
    //MARK: - Buttons
    
    @IBAction func editAccountSaveButton(_ sender: UIButton) {
        
        
        updateAccountProcess()
        
        
        
        
        
    }
    
}


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
            print("Walang pang laman")
            UIView.animate(withDuration: 0.2) { [self] in
                editAccountLabel4Text.text = "Incomplete fields"
                editAccountLabel4Text.isHidden = false
            }
            return false
        } else {
            return true
        }
    }
    
}

