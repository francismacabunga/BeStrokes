//
//  SignUpViewModel.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 5/24/21.
//

import Foundation
import Firebase
import UIKit

struct SignUpViewModel {
    
    private let firebase = Firebase()
    private let auth = Auth.auth()
    private var profilePicValidated = false
    private var textFieldsValidated = false
    var editedImage: UIImage? = nil
    var imageIsChanged = false
    
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
            createUser(with: userData[Strings.userEmailField]!, and: password) { (error, authResult) in
                if error != nil {
                    completion(error, nil, false, nil, nil, nil)
                    return
                }
                guard let authResult = authResult else {return}
                completion(nil, nil, true, nil, nil, nil)
                firebase.uploadProfilePic(with: editedImage!, using: authResult.user.uid) { (error, profilePic) in
                    if error != nil {
                        completion(error, nil, nil, false, nil, nil)
                        return
                    }
                    guard let profilePic = profilePic else {return}
                    userData[Strings.userIDField] = authResult.user.uid
                    userData[Strings.userProfilePicField] = profilePic
                    firebase.storeData(using: authResult.user.uid, with: userData) { (error, isFinishedStoring) in
                        if error != nil {
                            completion(error, nil, nil, nil, false, nil)
                            return
                        }
                        if isFinishedStoring {
                            firebase.sendEmailVerification { (error, _, isEmailVerificationSent) in
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
    
    func createUser(with email: String,
                    and password: String,
                    completion: @escaping (Error?, AuthDataResult?) -> Void)
    {
        auth.createUser(withEmail: email, password: password) { (authResult, error) in
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
    
    func transitionToHomeVC(with vc: SignUpViewController) {
        vc.view.window?.rootViewController = homeVC()
        vc.view.window?.makeKeyAndVisible()
    }
    
}
