//
//  LoginViewModel.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 5/27/21.
//

import Foundation
import Firebase

struct LoginViewModel {
    
    private let auth = Auth.auth()
    
    func loginUser(with emailTextField: String,
                   passwordTextField: String,
                   completion: @escaping (Error?, Bool) -> Void)
    {
        let email = emailTextField.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.trimmingCharacters(in: .whitespacesAndNewlines)
        signInUser(with: email, and: password) { (error, _) in
            if error != nil {
                completion(error, false)
                return
            }
            completion(nil, true)
        }
    }
    
    func signInUser(with email: String,
                    and password: String,
                    completion: @escaping (Error?, AuthDataResult?) -> Void)
    {
        auth.signIn(withEmail: email, password: password) { (authResult, error) in
            guard let error = error else {
                completion(nil, authResult)
                return
            }
            completion(error, nil)
        }
    }
    
    func homeVC() -> TabBarViewController {
        let tabBarVC = Utilities.transition(to: Strings.tabBarVC, onStoryboard: Strings.userStoryboard, canAccessDestinationProperties: true) as! TabBarViewController
        tabBarVC.selectedViewController = tabBarVC.viewControllers?[0]
        return tabBarVC
    }
    
    func transitionToHomeVC(with vc: LoginViewController) {
        vc.view.window?.rootViewController = homeVC()
        vc.view.window?.makeKeyAndVisible()
    }
    
}
