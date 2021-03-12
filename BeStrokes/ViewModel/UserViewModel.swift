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

struct UserData {
    
    private let db = Firestore.firestore()
    private let auth = Auth.auth()
    
    func isPasswordValid(_ password: String) -> Bool {
        let passwordTest = NSPredicate(format: Strings.regexFormat, Strings.validationType)
        return passwordTest.evaluate(with: password)
    }
    
    func createUser(with email: String,
                    _ password: String,
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
    
    func storeData(using userID: String,
                   with dictionary: [String : String],
                   completion: @escaping (Error?, Bool) -> Void)
    {
        db.collection(Strings.userCollection).document(userID).setData(dictionary) { (error) in
            guard let error = error else {
                completion(nil, true)
                return
            }
            completion(error, false)
        }
    }
    
    func sendEmailVerification(completion: @escaping (Error?, Bool) -> Void) {
        checkIfUserIsValid { (authErrorCode, error, user) in
            if error != nil {
                completion(error, false)
                return
            }
            guard let signedInUser = user else {return}
            signedInUser.sendEmailVerification { (error) in
                guard let error = error else {
                    completion(nil, true)
                    return
                }
                completion(error, false)
            }
        }
    }
    
    func signInUser(with email: String,
                    _ password: String,
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
    
    func forgotPassword(with email: String, completion: @escaping (Error?, Bool) -> Void) {
        auth.sendPasswordReset(withEmail: email) { (error) in
            guard let error = error else {
                completion(nil, true)
                return
            }
            completion(error, false)
        }
    }
    
    func checkIfUserIsValid(completion: @escaping (AuthErrorCode?, Error?, User?) -> Void) {
        guard let signedInUser = auth.currentUser else {
            completion(nil, nil, nil)
            return
        }
        signedInUser.reload { (error) in
            guard let error = error else {
                completion(nil, nil, signedInUser)
                return
            }
            let NSError = error as NSError
            guard let authErrorCode = AuthErrorCode(rawValue: NSError.code) else {return}
            completion(authErrorCode, error, nil)
        }
    }
    
    func getSignedInUserData(completion: @escaping (Error?, Bool, UserViewModel?) -> Void) {
        checkIfUserIsValid { (authErrorCode, error, user) in
            if error != nil {
                completion(error, false, nil)
                return
            }
            guard let signedInUser = user else {return}
            db.collection(Strings.userCollection).whereField(Strings.userIDField, isEqualTo: signedInUser.uid).addSnapshotListener { (snapshot, error) in
                guard let error = error else {
                    guard let userData = snapshot?.documents.first else {return}
                    let userViewModel = UserViewModel(UserModel(userID: userData[Strings.userIDField] as! String,
                                                                firstName: userData[Strings.userFirstNameField] as! String,
                                                                lastName: userData[Strings.userLastNameField] as! String,
                                                                email: userData[Strings.userEmailField] as! String,
                                                                profilePic: userData[Strings.userProfilePicField] as! String))
                    completion(nil, true, userViewModel)
                    return
                }
                completion(error, true, nil)
            }
        }
    }
    
    func isEmailVerified(completion: @escaping (Error?, Bool, Bool?) -> Void) {
        checkIfUserIsValid { (authErrorCode, error, user) in
            guard let error = error else {
                guard let signedInUser = user else {return}
                if signedInUser.isEmailVerified {
                    completion(nil, true, true)
                } else {
                    completion(nil, true, false)
                }
                return
            }
            completion(error, false, nil)
        }
    }
    
    func updateUserData(_ firstName: String,
                        _ lastName: String,
                        _ email: String,
                        _ profilePicURL: String,
                        completion: @escaping (Error?, Bool, Bool?) -> Void)
    {
        checkIfUserIsValid { (authErrorCode, error, user) in
            if error != nil {
                completion(error, false, nil)
                return
            }
            guard let signedInUser = user else {return}
            signedInUser.updateEmail(to: email) { (error) in
                if error != nil {
                    completion(error, true, false)
                    return
                }
                db.collection(Strings.userCollection).document(signedInUser.uid).updateData([Strings.userFirstNameField : firstName,
                                                                                             Strings.userLastNameField : lastName,
                                                                                             Strings.userEmailField : email,
                                                                                             Strings.userProfilePicField : profilePicURL]) { (error) in
                    guard let error = error else {
                        completion(nil, true, true)
                        return
                    }
                    completion(error, true, false)
                }
            }
        }
    }
    
    func uploadProfilePic(with image: UIImage,
                          using userID: String,
                          completion: @escaping (Error?, String?) -> Void)
    {
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
                guard let error = error else {
                    guard let imageString = url?.absoluteString else {return}
                    completion(nil, imageString)
                    return
                }
                completion(error, nil)
            }
        }
    }
    
    func signOutUser(completion: @escaping (Error?, Bool?) -> Void) {
        checkIfUserIsValid { (authErrorCode, error, user) in
            if error != nil {
                completion(error, nil)
                return
            }
            guard let _ = user else {return}
            do {
                try auth.signOut()
                completion(nil, true)
            } catch {
                completion(nil, false)
            }
        }
    }
    
}





