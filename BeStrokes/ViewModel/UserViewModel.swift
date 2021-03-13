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
        // USING 'checkIfUserIsValid'
        
//        checkIfUserIsValid { (user) in
//            guard let signedInUser = user else {return}
        auth.currentUser?.sendEmailVerification { (error) in
                guard let error = error else {
                    completion(nil, true)
                    return
                }
                completion(error, false)
            }
//        }
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
    
    func checkIfUserIsValid(completion: @escaping (Error?, Bool?) -> Void) {
        guard let signedInUser = auth.currentUser else {
            completion(nil, false)
            return
        }
        signedInUser.reload { (error) in
            guard let error = error else {
                completion(nil, true)
                return
            }
            completion(error, nil)
        }
    }
    
    func getSignedInUserData(completion: @escaping (Error?, Bool, UserViewModel?) -> Void) {
        // USING 'checkIfUserIsValid'
        checkIfUserIsValid { (error, isUserValid) in
            guard let error = error else {
                guard let isUserValid = isUserValid else {return}
                if isUserValid {
                    db.collection(Strings.userCollection).whereField(Strings.userIDField, isEqualTo: auth.currentUser!.uid).addSnapshotListener { (snapshot, error) in
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
                } else {
                    completion(nil, false, nil)
                }
                return
            }
            completion(error, false, nil)
        }
    }
    
    func isEmailVerified(completion: @escaping (Error?, Bool, Bool?) -> Void) {
        // USING 'checkIfUserIsValid'
        
//        checkIfUserIsValid { (user) in
//            guard let signedInUser = user else {return}
        if auth.currentUser!.isEmailVerified {
                completion(nil, true, true)
            } else {
                completion(nil, true, false)
            }
            return
//        }
    }
    
    func updateUserData(_ firstName: String,
                        _ lastName: String,
                        _ email: String,
                        _ profilePicURL: String,
                        completion: @escaping (Error?, Bool, Bool?) -> Void)
    {
        // USING 'checkIfUserIsValid'
        
//        checkIfUserIsValid { (user) in
//            guard let signedInUser = user else {return}
        auth.currentUser?.updateEmail(to: email) { (error) in
                if error != nil {
                    completion(error, true, false)
                    return
                }
            db.collection(Strings.userCollection).document(auth.currentUser!.uid).updateData([Strings.userFirstNameField : firstName,
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
//        }
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
        // USING 'checkIfUserIsValid'
        
//        checkIfUserIsValid { (user) in
        guard let _ = auth.currentUser else {return}
            do {
                try auth.signOut()
                completion(nil, true)
            } catch {
                completion(nil, false)
            }
//        }
    }
    
}





