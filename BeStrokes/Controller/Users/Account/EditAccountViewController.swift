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
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var editAccountHeadingLabelText: UILabel!
    @IBOutlet weak var editAccountImageView: UIImageView!
    @IBOutlet weak var editAccountLabel1Text: UILabel!
    @IBOutlet weak var editAccountLabel2Text: UILabel!
    @IBOutlet weak var editAccountLabel3Text: UILabel!
    @IBOutlet weak var editAccountTextField1: UITextField!
    @IBOutlet weak var editAccountTextField2: UITextField!
    @IBOutlet weak var editAccountTextField3: UITextField!
    @IBOutlet weak var editAccountSaveButtonLabel: UIButton!
    
    
    //MARK: - Constants / Variables
    
    private let imagePicker = UIImagePickerController()
    private let user = User()
    var userViewModel: UserViewModel!
    private let isSaveButtonPressed = false
    
    
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
        Utilities.setDesignOn(navigationBar: editAccountNavigationBar, isDarkMode: true)
        Utilities.setDesignOn(view: view, backgroundColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1))
        Utilities.setDesignOn(view: contentView, backgroundColor: .clear)
        Utilities.setDesignOn(label: editAccountHeadingLabelText, font: Strings.defaultFontBold, fontSize: 30, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), numberofLines: 1, textAlignment: .center, text: "Update Account")
        Utilities.setDesignOn(imageView: editAccountImageView, isPerfectCircle: true)
        Utilities.setDesignOn(label: editAccountLabel1Text, font: Strings.defaultFont, fontSize: 15, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), numberofLines: 1, textAlignment: .left, text: "First Name")
        Utilities.setDesignOn(label: editAccountLabel2Text, font: Strings.defaultFont, fontSize: 15, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), numberofLines: 1, textAlignment: .left, text: "Last Name")
        Utilities.setDesignOn(label: editAccountLabel3Text, font: Strings.defaultFont, fontSize: 15, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), numberofLines: 1, textAlignment: .left, text: "Email")
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
        //        editAccountImageView.kf.setImage(with: userViewModel.profilePic)
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
            user.updateUserData(firstName!, lastName!, email!)
        } else {
            print("Incomplete fields")
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
            return false
        } else {
            return true
        }
    }
    
}

