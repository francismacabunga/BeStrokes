//
//  ForgotPasswordViewControllerContainer.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 11/19/20.
//

import UIKit

class ForgotPasswordViewControllerContainer: UIViewController {
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Utilities.putDesignOn(navigationBar: navigationBar)
        
    }
    
}
