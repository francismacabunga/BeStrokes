//
//  SampleViewController.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 11/18/20.
//

import UIKit

class LoginViewControllerContainer: UIViewController {
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Utilities.putDesignOn(navigationBar: navigationBar)
        
    }
    
}
