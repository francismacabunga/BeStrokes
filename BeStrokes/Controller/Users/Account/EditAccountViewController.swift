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
        Utilities.setDesignOn(view: view, color: .clear)
        Utilities.setDesignOn(view: contentView, color: .clear)
        Utilities.setDesignOn(editAccountHeadingLabelText, label: "Update Account", font: Strings.defaultFontBold, fontSize: 30, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), textAlignment: .center, numberofLines: 1)
        Utilities.setDesignOn(imageView: editAccountImageView, image: UIImage(named: "Woman"), tintColor: .red, isCircular: true)
        
        Utilities.setDesignOn(editAccountLabel1Text, label: "First Name", font: Strings.defaultFontBold, fontSize: 15, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), textAlignment: .left, numberofLines: 1)
        Utilities.setDesignOn(editAccountLabel2Text, label: "Last Name", font: Strings.defaultFontBold, fontSize: 15, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), textAlignment: .left, numberofLines: 1)
        Utilities.setDesignOn(editAccountLabel3Text, label: "Email", font: Strings.defaultFontBold, fontSize: 15, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), textAlignment: .left, numberofLines: 1)
        
        
    }
    
}
