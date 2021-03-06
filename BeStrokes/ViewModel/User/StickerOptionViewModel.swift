//
//  StickerOptionViewModel.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 6/3/21.
//

import Foundation
import Firebase

struct StickerOptionViewModel {
    
    private let firebase = Firebase()
    private let db = Firestore.firestore()
    var heartButtonTapped: Bool?
    
    
    //MARK: - User Defaults
    
    func setUserDefaultsTabKeys() {
        UserDefaults.standard.setValue(true, forKey: Strings.stickerOptionPageKey)
        if UserDefaults.standard.bool(forKey: Strings.homeTabKey) {
            UserDefaults.standard.setValue(false, forKey: Strings.homePageKey)
        }
        if UserDefaults.standard.bool(forKey: Strings.notificationTabKey) {
            UserDefaults.standard.setValue(false, forKey: Strings.notificationPageKey)
        }
        if UserDefaults.standard.bool(forKey: Strings.accountTabKey) {
            UserDefaults.standard.setValue(false, forKey: Strings.accountPageKey)
        }
    }
    
    func setUserDefaultsOnExitButton() {
        UserDefaults.standard.setValue(false, forKey: Strings.stickerOptionPageKey)
        if UserDefaults.standard.bool(forKey: Strings.homeTabKey) {
            UserDefaults.standard.setValue(true, forKey: Strings.homePageKey)
        }
        if UserDefaults.standard.bool(forKey: Strings.accountTabKey) {
            UserDefaults.standard.setValue(true, forKey: Strings.accountPageKey)
        }
    }
    
    
    //MARK: - Design Related Functions
    
    func captureVC(_ stickerViewModel: StickerViewModel?, _ userStickerViewModel: UserStickerViewModel?) -> CaptureViewController {
        UserDefaults.standard.setValue(false, forKey: Strings.stickerOptionPageKey)
        let captureVC = Utilities.transition(to: Strings.captureVC, onStoryboard: Strings.userStoryboard, canAccessDestinationProperties: true) as! CaptureViewController
        captureVC.stickerViewModel = stickerViewModel
        captureVC.userStickerViewModel = userStickerViewModel
        captureVC.captureViewModel.stickerIsPicked = true
        captureVC.modalPresentationStyle = .fullScreen
        return captureVC
    }
    
    
    //MARK: - UIGesture Handlers
    
    func tapToHeartGesture(with tapGesture: UITapGestureRecognizer,
                           on stickerViewModel: StickerViewModel?,
                           _ userStickerViewModel: UserStickerViewModel?,
                           completion: @escaping (Bool, Error?, Bool, Bool?) -> Void)
    {
        guard let heartButtonTapped = heartButtonTapped else {return}
        if heartButtonTapped {
            completion(true, nil, true, nil)
            if stickerViewModel != nil {
                untapHeartButtonUsing(stickerViewModel!) { (error, userIsSignedIn) in
                    if !userIsSignedIn {
                        completion(true, error, false, nil)
                        return
                    }
                    completion(true, error, true, nil)
                }
                return
            }
            if userStickerViewModel != nil {
                untapHeartButtonUsing(userStickerViewModel!) { (error, userIsSignedIn, processIsDone) in
                    if !userIsSignedIn {
                        guard let error = error else {return}
                        completion(true, error, false, nil)
                        return
                    }
                    if error != nil {
                        completion(true, error, true, nil)
                        return
                    }
                    if processIsDone != nil {
                        if processIsDone! {
                            completion(true, nil, true, true)
                        }
                    }
                }
                return
            }
        } else {
            completion(false, nil, true, nil)
            if stickerViewModel != nil {
                tapHeartButtonUsing(stickerViewModel!) { (error, userIsSignedIn) in
                    if !userIsSignedIn {
                        completion(false, error, false, nil)
                        return
                    }
                    completion(false, error, true, nil)
                }
                return
            }
            if userStickerViewModel != nil {
                tapHeartButtonUsing(userStickerViewModel!) { (error, userIsSignedIn) in
                    if !userIsSignedIn {
                        completion(false, error, false, nil)
                        return
                    }
                    completion(false, error, true, nil)
                }
                return
            }
        }
    }
    
    func untapHeartButtonUsing(_ stickerViewModel: StickerViewModel, completion: @escaping (Error, Bool) -> Void) {
        untapHeartButton(using: stickerViewModel.stickerID) { (error, userIsSignedIn, _) in
            if !userIsSignedIn {
                guard let error = error else {return}
                completion(error, false)
                return
            }
            if error != nil {
                completion(error!, true)
                return
            }
        }
    }
    
    func untapHeartButtonUsing(_ userStickerViewModel: UserStickerViewModel, completion: @escaping (Error?, Bool, Bool?) -> Void) {
        untapHeartButton(using: userStickerViewModel.stickerID) { (error, userIsSignedIn, processIsDone) in
            if !userIsSignedIn {
                guard let error = error else {return}
                completion(error, false, nil)
                return
            }
            if error != nil {
                completion(error, true, nil)
                return
            }
            if UserDefaults.standard.bool(forKey: Strings.accountTabKey) {
                if processIsDone != nil {
                    if processIsDone! {
                        completion(nil, true, true)
                    }
                }
            }
        }
    }
    
    func tapHeartButtonUsing(_ stickerViewModel: StickerViewModel, completion: @escaping (Error, Bool) -> Void) {
        tapHeartButton(using: stickerViewModel.stickerID) { (error, userIsSignedIn) in
            if !userIsSignedIn {
                guard let error = error else {return}
                completion(error, false)
                return
            }
            if error != nil {
                completion(error!, true)
            }
        }
    }
    
    func tapHeartButtonUsing(_ userStickerViewModel: UserStickerViewModel, completion: @escaping (Error, Bool) -> Void) {
        tapHeartButton(using: userStickerViewModel.stickerID) { (error, userIsSignedIn) in
            if !userIsSignedIn {
                guard let error = error else {return}
                completion(error, false)
                return
            }
            if error != nil {
                completion(error!, true)
            }
        }
    }
    
    
    //MARK: - Heart Button Logic Related Functions
    
    func tapHeartButton(using stickerID: String, completion: @escaping (Error?, Bool) -> Void) {
        firebase.getSignedInUserData { (error, userIsSignedIn, userData) in
            if !userIsSignedIn {
                guard let error = error else {return}
                completion(error, false)
                return
            }
            if error != nil {
                completion(error, true)
                return
            }
            guard let userData = userData else {return}
            let userDataDictionary = [Strings.userIDField : userData.userID,
                                      Strings.userFirstNameField : userData.firstName,
                                      Strings.userLastNameField : userData.lastname,
                                      Strings.userEmailField : userData.email]
            db.collection(Strings.stickerCollection).document(stickerID).collection(Strings.lovedByCollection).document(userData.userID).setData(userDataDictionary) { (error) in
                guard let error = error else {return}
                completion(error, true)
            }
            db.collection(Strings.userCollection).document(userData.userID).collection(Strings.stickerCollection).document(stickerID).updateData([Strings.stickerIsLovedField : true]) { (error) in
                guard let error = error else {return}
                completion(error, true)
            }
        }
    }
    
    func untapHeartButton(using stickerID: String, completion: @escaping (Error?, Bool, Bool?) -> Void) {
        firebase.checkIfUserIsSignedIn { (error, userIsSignedIn, user) in
            if !userIsSignedIn {
                guard let error = error else {return}
                completion(error, false, nil)
                return
            }
            guard let signedInUser = user else {return}
            db.collection(Strings.stickerCollection).document(stickerID).collection(Strings.lovedByCollection).document(signedInUser.uid).delete { (error) in
                guard let error = error else {return}
                completion(error, true, false)
            }
            db.collection(Strings.userCollection).document(signedInUser.uid).collection(Strings.stickerCollection).document(stickerID).updateData([Strings.stickerIsLovedField : false]) { (error) in
                guard let error = error else {
                    completion(nil, true, true)
                    return
                }
                completion(error, true, false)
            }
        }
    }
    
}
