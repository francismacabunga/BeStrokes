//
//  StickerOptionViewModel.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 6/3/21.
//

import Foundation
import Firebase
import UIKit

struct StickerOptionViewModel {
    
    private let firebase = Firebase()
    private let db = Firestore.firestore()
    var heartButtonTapped: Bool?
    
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
    
    func captureVC(_ stickerViewModel: StickerViewModel?, _ userStickerViewModel: UserStickerViewModel?) -> CaptureViewController {
        let captureVC = Utilities.transition(to: Strings.captureVC, onStoryboard: Strings.userStoryboard, canAccessDestinationProperties: true) as! CaptureViewController
        captureVC.stickerViewModel = stickerViewModel
        captureVC.userStickerViewModel = userStickerViewModel
        captureVC.captureViewModel.stickerIsPicked = true
        captureVC.modalPresentationStyle = .fullScreen
        return captureVC
    }
    
    func tapToHeartGesture(with tapGesture: UITapGestureRecognizer,
                           on stickerViewModel: StickerViewModel?,
                           _ userStickerViewModel: UserStickerViewModel?,
                           completion: @escaping (Bool, Error?, Bool, Bool) -> Void) {
        guard let heartButtonTapped = heartButtonTapped else {return}
        if heartButtonTapped {
            completion(true, nil, true, false)
            if stickerViewModel != nil {
                untapHeartButtonUsing(stickerViewModel!) { (error, userIsSignedIn) in
                    if !userIsSignedIn {
                        completion(true, error, false, false)
                        return
                    }
                    completion(true, error, true, false)
                }
                return
            }
            if userStickerViewModel != nil {
                untapHeartButtonUsing(userStickerViewModel!) { (error, userIsSignedIn, processIsDone) in
                    if !userIsSignedIn {
                        guard let error = error else {return}
                        completion(true, error, false, false)
                        return
                    }
                    if error != nil {
                        completion(true, error, true, false)
                        return
                    }
                    if processIsDone {
                        completion(true, nil, true, true)
                    }
                }
                return
            }
        } else {
            completion(false, nil, true, false)
            if stickerViewModel != nil {
                tapHeartButtonUsing(stickerViewModel!) { (error, userIsSignedIn) in
                    if !userIsSignedIn {
                        completion(false, error, false, false)
                        return
                    }
                    completion(false, error, true, false)
                }
                return
            }
            if userStickerViewModel != nil {
                tapHeartButtonUsing(userStickerViewModel!) { (error, userIsSignedIn) in
                    if !userIsSignedIn {
                        completion(false, error, false, false)
                        return
                    }
                    completion(false, error, true, false)
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
    
    func untapHeartButtonUsing(_ userStickerViewModel: UserStickerViewModel, completion: @escaping (Error?, Bool, Bool) -> Void) {
        if UserDefaults.standard.bool(forKey: Strings.accountTabKey) {
            untapHeartButton(using: userStickerViewModel.stickerID) { (error, userIsSignedIn, processIsDone) in
                if !userIsSignedIn {
                    guard let error = error else {return}
                    completion(error, false, false)
                    return
                }
                if error != nil {
                    completion(error, true, false)
                    return
                }
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
    
    
    
    
    
    
    
    
    func tapHeartButton(using stickerID: String, completion: @escaping (Error?, Bool) -> Void) {
        firebase.getSignedInUserData { (error, isUserSignedIn, userData) in

            if !isUserSignedIn {
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
        firebase.checkIfUserIsSignedIn { (error, isUserSignedIn, user) in
            if !isUserSignedIn {
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
