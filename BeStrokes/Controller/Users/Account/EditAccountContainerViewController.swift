//
//  EditAccountContainerViewController.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 1/10/21.
//

import UIKit

class EditAccountContainerViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var editAccountNavigationBar: UINavigationBar!
    
    
    //MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDesignElements()
        
    }
    
    
    //MARK: - Design Elements
    
    func setDesignElements() {
        Utilities.setDesignOn(view: view, color: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1))
        Utilities.setDesignOn(navigationBar: editAccountNavigationBar, isDarkMode: true)
    }
    
}
