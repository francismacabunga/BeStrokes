//
//  LoginViewModel.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 5/27/21.
//

import Foundation

struct LoginViewModel {
    
    private let service = Service()
    
    func loginUser(with emailTextField: String,
                   passwordTextField: String,
                   completion: @escaping (Error?, Bool) -> Void)
    {
        let email = emailTextField.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.trimmingCharacters(in: .whitespacesAndNewlines)
        service.signInUser(with: email, and: password) { (error, _) in
            if error != nil {
                completion(error, false)
                return
            }
            completion(nil, true)
        }
    }
    
    func homeVC() -> TabBarViewController {
        let tabBarVC = Utilities.transition(to: Strings.tabBarVC, onStoryboard: Strings.userStoryboard, canAccessDestinationProperties: true) as! TabBarViewController
        tabBarVC.selectedViewController = tabBarVC.viewControllers?[0]
        return tabBarVC
    }
    
}
