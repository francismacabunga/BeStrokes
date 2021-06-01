//
//  EditAccountViewModel.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 5/31/21.
//

import Foundation
import UIKit

class EditAccountViewModel {
    
    private let firebase = Firebase()
    private var userInfo = [String]()
    var editedImage: UIImage?
    var userID: String?
    var originalEmail: String?
    var originalProfilePic: String?
    var isCroppingDone = false
    
    
    //MARK: - User Defaults
    
    func setUserDefaultsOnWillAppear() {
        UserDefaults.standard.setValue(true, forKey: Strings.editAccountPageKey)
        UserDefaults.standard.setValue(false, forKey: Strings.accountPageKey)
    }
    
    func setUserDefaultsOnDidDisappear() {
        UserDefaults.standard.setValue(false, forKey: Strings.editAccountPageKey)
        UserDefaults.standard.setValue(true, forKey: Strings.accountPageKey)
    }
    
    
    //MARK: - Edit Account Related Functions
    
    func validateTextFields(_ firstNameTextField: UITextField,
                            _ lastNameTextField: UITextField,
                            _ emailTextField: UITextField) -> [String]?
    {
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) != "" &&
            lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) != "" &&
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            userInfo = [firstNameTextField.text!, lastNameTextField.text!, emailTextField.text!]
            return userInfo
        }
        return nil
    }
    
    func editAccount(with userInfo: [String], completion: @escaping (Error?, Bool, Bool?, Bool?, Bool?, Bool?) -> Void) {
        firebase.isEmailVerified { [weak self] (error, userIsSignedIn, emailIsVerified) in
            guard let self = self else {return}
            if !userIsSignedIn {
                guard let error = error else {return}
                completion(error, false, nil, nil, nil, nil)
                return
            }
            if error != nil {
                completion(error, true, nil, nil, nil, nil)
                return
            }
            if emailIsVerified {
                completion(nil, true, true, nil, nil, nil)
                self.uploadProfilePic { (error, userIsSignedIn, emailVerificationIsSent, updateIsFinished, sendingEmailVerificationFailed) in
                    if !userIsSignedIn {
                        guard let error = error else {return}
                        completion(error, false, nil, nil, nil, nil)
                        return
                    }
                    if error != nil {
                        completion(error, true, nil, nil, nil, nil)
                        return
                    }
                    if emailVerificationIsSent != nil {
                        completion(nil, true, nil, true, nil, nil)
                    }
                    if updateIsFinished != nil {
                        completion(nil, true, nil, nil, true, nil)
                    }
                    if sendingEmailVerificationFailed != nil {
                        completion(nil, true, nil, nil, nil, true)
                    }
                }
            } else {
                completion(nil, true, false, nil, nil, nil)
            }
        }
    }
    
    func uploadProfilePic(completion: @escaping (Error?, Bool, Bool?, Bool?, Bool?) -> Void) {
        if editedImage != nil {
            firebase.uploadProfilePic(with: editedImage!, using: userID!) { [weak self] (error, imageURL) in
                guard let self = self else {return}
                if error != nil {
                    completion(error, true, nil, nil, nil)
                    return
                }
                guard let newProfilePic = imageURL else {return}
                self.updateUserData(using: newProfilePic) { (error, userIsSignedIn, emailVerificationIsSent, updateIsFinished, sendingEmailVerificationFailed) in
                    if !userIsSignedIn {
                        guard let error = error else {return}
                        completion(error, false, nil, nil, nil)
                        return
                    }
                    if error != nil {
                        completion(error, true, nil, nil, nil)
                        return
                    }
                    if emailVerificationIsSent != nil {
                        completion(nil, true, true, nil, nil)
                    }
                    if updateIsFinished != nil {
                        completion(nil, true, nil, true, nil)
                    }
                    if sendingEmailVerificationFailed != nil {
                        completion(nil, true, nil, nil, true)
                    }
                }
            }
        } else {
            self.updateUserData(using: originalProfilePic!) { (error, userIsSignedIn, emailVerificationIsSent, updateIsFinished, sendingEmailVerificationFailed) in
                if !userIsSignedIn {
                    guard let error = error else {return}
                    completion(error, false, nil, nil, nil)
                    return
                }
                if error != nil {
                    completion(error, true, nil, nil, nil)
                    return
                }
                if emailVerificationIsSent != nil {
                    completion(nil, true, true, nil, nil)
                }
                if updateIsFinished != nil {
                    completion(nil, true, nil, true, nil)
                }
            }
        }
    }
    
    func updateUserData(using profilePic: String, completion: @escaping (Error?, Bool, Bool?, Bool?, Bool?) -> Void) {
        let firstName = userInfo[0]
        let lastName = userInfo[1]
        let newEmail = userInfo[2]
        if originalEmail != newEmail {
            firebase.updateUserData(firstName, lastName, newEmail, profilePic) { [weak self] (error, userIsSignedIn, updateIsFinished) in
                guard let self = self else {return}
                if !userIsSignedIn {
                    guard let error = error else {return}
                    completion(error, false, nil, nil, nil)
                    return
                }
                if error != nil {
                    completion(error, true, nil, nil, nil)
                    return
                }
                if updateIsFinished {
                    self.firebase.sendEmailVerification { (error, userIsSignedIn, emailVerificationIsSent) in
                        if !userIsSignedIn {
                            guard let error = error else {return}
                            completion(error, false, nil, nil, nil)
                            return
                        }
                        if error != nil {
                            completion(error, true, nil, nil, true)
                            return
                        }
                        if emailVerificationIsSent {
                            completion(nil, true, true, nil, nil)
                        }
                    }
                }
            }
        } else {
            firebase.updateUserData(firstName, lastName, originalEmail!, profilePic) { (error, userIsSignedIn, updateIsFinished) in
                if !userIsSignedIn {
                    guard let error = error else {return}
                    completion(error, false, nil, nil, nil)
                    return
                }
                if error != nil {
                    completion(error, true, nil, nil, nil)
                    return
                }
                if updateIsFinished {
                    completion(nil, true, nil, true, nil)
                }
            }
        }
    }
    
}
