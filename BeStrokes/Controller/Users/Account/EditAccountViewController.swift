//
//  EditAccountViewController.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 1/10/21.
//

import UIKit

class EditAccountViewController: UIViewController {
    
    //MARK: - IBOutlets
    
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
    
    
    //MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDesignElements()
        
    }
    
    
    //MARK: - Design Elements
    
    func setDesignElements() {
        Utilities.setDesignOn(view: view, backgroundColor: .clear)
        Utilities.setDesignOn(view: contentView, backgroundColor: .clear)
        Utilities.setDesignOn(label: editAccountHeadingLabelText, font: Strings.defaultFontBold, fontSize: 30, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), numberofLines: 1, textAlignment: .center, text: "Update Account")
        Utilities.setDesignOn(imageView: editAccountImageView, image: UIImage(named: "Woman"), isPerfectCircle: true)
        Utilities.setDesignOn(label: editAccountLabel1Text, font: Strings.defaultFontBold, fontSize: 15, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), numberofLines: 1, textAlignment: .left, text: "First Name")
        Utilities.setDesignOn(label: editAccountLabel2Text, font: Strings.defaultFontBold, fontSize: 15, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), numberofLines: 1, textAlignment: .left, text: "First Name")
        Utilities.setDesignOn(label: editAccountLabel3Text, font: Strings.defaultFontBold, fontSize: 15, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), numberofLines: 1, textAlignment: .left, text: "First Name")
        Utilities.setDesignOn(button: editAccountSaveButtonLabel, title: "Save", font: Strings.defaultFontBold, fontSize: 20, titleColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), isCircular: true, backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        Utilities.setDesignOn(textField: editAccountTextField1, font: Strings.defaultFont, fontSize: 15, textColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), placeholder: "  Francis", placeholderTextColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), isCircular: true)
        Utilities.setDesignOn(textField: editAccountTextField2, font: Strings.defaultFont, fontSize: 15, textColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), placeholder: "  Francis", placeholderTextColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), isCircular: true)
        Utilities.setDesignOn(textField: editAccountTextField3, font: Strings.defaultFont, fontSize: 15, textColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), placeholder: "  Francis", placeholderTextColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), isCircular: true)
    }
    
}
