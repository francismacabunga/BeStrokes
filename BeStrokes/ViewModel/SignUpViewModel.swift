//
//  SignUpViewModel.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 5/24/21.
//

import Foundation
import UIKit

struct SignUpViewModel {
    
    private let service = Service()
    var editedImage: UIImage? = nil
    var imageIsChanged = false
    private var profilePicValidated = false
    private var textFieldsValidated = false
    
    mutating func validateProfilePic(completion: @escaping (Bool) -> Void) {
        if imageIsChanged {
            profilePicValidated = true
            completion(true)
        }
        else {
            profilePicValidated = false
            completion(false)
        }
    }
    
    mutating func validateTextFields(_ firstNameTF: String?,
                                     _ lastNameTF: String?,
                                     _ emailTF: String?,
                                     _ passwordTF: String?,
                                     completion: @escaping (Bool?, Bool?) -> Void)
    {
        if firstNameTF == "" || lastNameTF == "" || emailTF == "" || passwordTF == "" {
            textFieldsValidated = false
            completion(false, nil)
        }
        if passwordTF != "" {
            guard let inputtedPassword = passwordTF?.trimmingCharacters(in: .whitespacesAndNewlines) else {return}
            let isPasswordValid = check(inputtedPassword)
            if isPasswordValid {
                textFieldsValidated = true
                completion(nil, true)
            } else {
                textFieldsValidated = false
                completion(nil, false)
            }
        }
    }
    
    func check(_ password: String) -> Bool {
        let passwordTest = NSPredicate(format: Strings.regexFormat, Strings.validationType)
        return passwordTest.evaluate(with: password)
    }
    
    func signUpUser(using firstName: String?,
                    _ lastName: String?,
                    _ email: String?,
                    _ password: String,
                    completion: @escaping (Error?, Bool?, Bool?, Bool?, Bool?, Bool?) -> Void)
    {
        if textFieldsValidated && profilePicValidated {
            completion(nil, true, nil, nil, nil, nil)
            var userData = [Strings.userFirstNameField : firstName!.trimmingCharacters(in: .whitespacesAndNewlines),
                            Strings.userLastNameField : lastName!.trimmingCharacters(in: .whitespacesAndNewlines),
                            Strings.userEmailField : email!.trimmingCharacters(in: .whitespacesAndNewlines)]
            service.createUser(with: userData[Strings.userEmailField]!, and: password) { (error, authResult) in
                if error != nil {
                    completion(error, nil, false, nil, nil, nil)
                    return
                }
                guard let authResult = authResult else {return}
                completion(nil, nil, true, nil, nil, nil)
                service.uploadProfilePic(with: editedImage!, using: authResult.user.uid) { (error, profilePic) in
                    if error != nil {
                        completion(error, nil, nil, false, nil, nil)
                        return
                    }
                    guard let profilePic = profilePic else {return}
                    userData[Strings.userIDField] = authResult.user.uid
                    userData[Strings.userProfilePicField] = profilePic
                    service.storeData(using: authResult.user.uid, with: userData) { (error, isFinishedStoring) in
                        if error != nil {
                            completion(error, nil, nil, nil, false, nil)
                            return
                        }
                        if isFinishedStoring {
                            service.sendEmailVerification { (error, _, isEmailVerificationSent) in
                                if error != nil {
                                    completion(error, nil, nil, nil, nil, false)
                                    return
                                }
                                if isEmailVerificationSent {
                                    UserDefaults.standard.setValue(true, forKey: Strings.userFirstTimeLoginKey)
                                    completion(error, nil, nil, nil, nil, true)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func homeVC() -> TabBarViewController {
        let tabBarVC = Utilities.transition(to: Strings.tabBarVC, onStoryboard: Strings.userStoryboard, canAccessDestinationProperties: true) as! TabBarViewController
        tabBarVC.selectedViewController = tabBarVC.viewControllers?[0]
        return tabBarVC
    }
    
}
