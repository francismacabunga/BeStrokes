//
//  UserViewModel.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 1/5/21.
//

import Foundation
import Firebase

struct UserViewModel {
    
    let userID: String
    let firstName: String
    let lastname: String
    let email: String
    let profilePic: String
    
    init(_ user: UserModel) {
        self.userID = user.userID
        self.firstName = user.firstName
        self.lastname = user.lastName
        self.email = user.email
        self.profilePic = user.profilePic
    }
    
}

struct User {
    
    private let db = Firestore.firestore()
    private let user = Auth.auth().currentUser
    
    func isPasswordValid(_ password: String) -> Bool {
        let passwordTest = NSPredicate(format: Strings.regexFormat, Strings.validationType)
        return passwordTest.evaluate(with: password)
    }
    
    func createUser(with email: String, _ password: String, completion: @escaping (Error?, AuthDataResult?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if error != nil {
                completion(error, nil)
                return
            }
            completion(nil, authResult)
            return
        }
    }
    
    func storeData(using userID: String, with dictionary: [String : String], completion: @escaping (Error?, Bool) -> Void) {
        db.collection(Strings.userCollection).document(userID).setData(dictionary) { (error) in
            if error != nil {
                completion(error, false)
                return
            }
            completion(nil, true)
            return
        }
    }
    
    func sendEmailVerification(completion: @escaping (Error?, Bool) -> Void) {
        Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
            if error != nil {
                completion(error, false)
                return
            }
            completion(nil, true)
            return
        })
    }
    
    func signInUser(with email: String, _ password: String, completion: @escaping (Error?, AuthDataResult?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if error != nil {
                completion(error, nil)
                return
            }
            completion(nil, authResult)
            return
        }
    }
    
    func forgotPassword(with email: String, completion: @escaping (Error?, Bool) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if error != nil {
                completion(error, false)
                return
            }
            completion(nil, true)
            return
        }
    }
    
    func checkIfUserIsSignedIn(completion: @escaping (AuthErrorCode?, Bool, Bool?) -> Void) {
        guard let signedInUser = user else {
            completion(nil, false, nil)
            return
        }
        signedInUser.reload { (error) in
            if error != nil {
                guard let NSError = error as NSError? else {return}
                if let error = AuthErrorCode(rawValue: NSError.code) {
                    completion(error, true, true)
                    return
                }
            }
            completion(nil, true, false)
            return
        }
    }
    
    func getSignedInUserData(completion: @escaping (Error?, Bool, UserViewModel?) -> Void) {
        guard let signedInUser = user else {
            completion(nil, false, nil)
            return
        }
        let signedInUserID = signedInUser.uid
        db.collection(Strings.userCollection).whereField(Strings.userIDField, isEqualTo: signedInUserID).addSnapshotListener { (snapshot, error) in
            if error != nil {
                completion(error, true, nil)
                return
            }
            guard let result = snapshot?.documents.first else {return}
            let userViewModel = UserViewModel(UserModel(userID: result[Strings.userIDField] as! String,
                                                        firstName: result[Strings.userFirstNameField] as! String,
                                                        lastName: result[Strings.userLastNameField] as! String,
                                                        email: result[Strings.userEmailField] as! String,
                                                        profilePic: result[Strings.userProfilePicField] as! String))
            completion(nil, true, userViewModel)
            return
        }
    }
    
    func isEmailVerified(completion: @escaping (Error?, Bool, Bool?) -> Void) {
        guard let signedInUser = user else {
            completion(nil, false, nil)
            return
        }
        signedInUser.reload { (error) in
            if error != nil {
                completion(error!, true, nil)
                return
            }
            if signedInUser.isEmailVerified {
                completion(nil, true, true)
                return
            } else {
                completion(nil, true, false)
                return
            }
        }
    }
    
    func updateUserData(_ firstName: String, _ lastName: String, _ email: String, _ profilePicURL: String, completion: @escaping (Error?, Bool, Bool) -> Void) {
        guard let signedInUser = user else {
            completion(nil, false, false)
            return
        }
        signedInUser.reload { (error) in
            if error != nil {
                completion(error, true, false)
                return
            }
            let signedInUserID = signedInUser.uid
            signedInUser.updateEmail(to: email) { (error) in
                if error != nil {
                    completion(error, true, false)
                    return
                }
                db.collection(Strings.userCollection).document(signedInUserID).updateData([Strings.userFirstNameField : firstName,
                                                                                           Strings.userLastNameField : lastName,
                                                                                           Strings.userEmailField : email,
                                                                                           Strings.userProfilePicField : profilePicURL])
                completion(nil, true, true)
                return
            }
        }
    }
    
    func uploadProfilePic(with image: UIImage, using userID: String, completion: @escaping (Error?, String?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.4) else {return}
        let storagePath = Storage.storage().reference(forURL: Strings.firebaseStoragePath)
        let profilePicStoragePath = storagePath.child(Strings.firebaseProfilePicStoragePath).child(userID)
        let imageMetadata = StorageMetadata()
        imageMetadata.contentType = Strings.metadataContentType
        profilePicStoragePath.putData(imageData, metadata: imageMetadata) { (storageMetadata, error) in
            if error != nil {
                completion(error, nil)
                return
            }
            profilePicStoragePath.downloadURL { (url, error) in
                if error != nil {
                    completion(error, nil)
                    return
                }
                guard let imageString = url?.absoluteString else {return}
                completion(nil, imageString)
                return
            }
        }
    }
    
    func signOutUser(completion: @escaping (Bool) -> Void) -> Bool {
        guard let _ = user else {
            completion(false)
            return false
        }
        do {
            try Auth.auth().signOut()
            completion(true)
            return true
        } catch {
            completion(true)
            return false
        }
    }
    
}





