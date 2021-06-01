//
//  ForgotPasswordViewModel.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 5/27/21.
//

import Foundation
import Firebase

struct ForgotPasswordViewModel {
    
    private let auth = Auth.auth()
    
    func forgotPassword(using emailTextField: String, completion: @escaping (Error?, Bool) -> Void) {
        let email = emailTextField.trimmingCharacters(in: .whitespacesAndNewlines)
        forgotPassword(with: email) { (error, _) in
            if error != nil {
                completion(error, false)
                return
            }
            completion(nil, true)
        }
    }
    
    func forgotPassword(with email: String, completion: @escaping (Error?, Bool) -> Void) {
        auth.sendPasswordReset(withEmail: email) { (error) in
            guard let error = error else {
                completion(nil, true)
                return
            }
            completion(error, false)
        }
    }
    
}
