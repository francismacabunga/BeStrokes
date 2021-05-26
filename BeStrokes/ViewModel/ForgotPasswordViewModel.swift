//
//  ForgotPasswordViewModel.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 5/27/21.
//

import Foundation

struct ForgotPasswordViewModel {
    
    private let service = Service()
    
    func forgotPassword(using emailTextField: String, completion: @escaping (Error?, Bool) -> Void) {
        let email = emailTextField.trimmingCharacters(in: .whitespacesAndNewlines)
        service.forgotPassword(with: email) { (error, _) in
            if error != nil {
                completion(error, false)
                return
            }
            completion(nil, true)
        }
    }
    
}
