//
//  UserViewModel.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 1/5/21.
//

import Foundation
import Firebase

struct UserViewModel {
    
    let documentID: String
    let userID: String
    let firstName: String
    let lastname: String
    let email: String
    let profilePic: String
    
    init(_ user: UserModel) {
        self.documentID = user.documentID
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
    
    func storeData(with dictionary: [String : String], completion: @escaping (Error?, Bool?) -> Void) {
        let documentReference = db.collection(Strings.userCollection).document()
        let documentID = documentReference.documentID
        documentReference.setData([Strings.userDocumentIDField : documentID]) { (error) in
            if error != nil {
                completion(error, nil)
                return
            }
            documentReference.updateData(dictionary) { (error) in
                if error != nil {
                    completion(error, nil)
                    return
                }
                completion(nil, true)
                return
            }
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
    
    func checkIfUserIsSignedIn(completion: @escaping (AuthErrorCode?, Bool) -> Void) {
        if user != nil {
            print("The user is signed in!")
            user!.reload { (error) in
                if error != nil {
                    guard let NSError = error as NSError? else {return}
                    if let error = AuthErrorCode(rawValue: NSError.code) {
                        completion(error, true)
                        return
                    }
                }
                print("Valid token")
                completion(nil, false)
                return
            }
        } else {
            print("The user is not signed in!")
            completion(nil, true)
            return
        }
    }
    
    func getSignedInUserData(completion: @escaping (Error?, Bool?, UserViewModel?) -> Void) {
        if user != nil {
            let signedInUserID = user!.uid
            db.collection(Strings.userCollection).whereField(Strings.userIDField, isEqualTo: signedInUserID).addSnapshotListener { (snapshot, error) in
                if error != nil {
                    // Show error
                    completion(error, true, nil)
                    return
                }
                guard let result = snapshot?.documents.first else {return}
                let userViewModel = UserViewModel(UserModel(documentID: result[Strings.userDocumentIDField] as! String,
                                                            userID: result[Strings.userIDField] as! String,
                                                            firstName: result[Strings.userFirstNameField] as! String,
                                                            lastName: result[Strings.userLastNameField] as! String,
                                                            email: result[Strings.userEmailField] as! String,
                                                            profilePic: result[Strings.userProfilePicField] as! String))
                completion(nil, true, userViewModel)
                return
            }
        } else {
            // Show error no user is signed in!
            completion(nil, false, nil)
            return
        }
    }
    
    func isEmailVerified(completion: @escaping (Error?, Bool?, Bool?) -> Void) {
        guard let signedInUser = user else {
            completion(nil, false, nil)
            return
        }
        signedInUser.reload { (error) in
            if error != nil {
                completion(error!, true, nil)
            }
            if signedInUser.isEmailVerified {
                completion(nil, true, true)
            } else {
                completion(nil, true, false)
            }
        }
    }
    
    func updateUserData(_ firstName: String, _ lastName: String, _ email: String, _ profilePicURL: String, completion: @escaping (Error?, Bool?, Bool?) -> Void) {
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
            db.collection(Strings.userCollection).whereField(Strings.userIDField, isEqualTo: signedInUserID).getDocuments { (snapshot, error) in
                if error != nil {
                    completion(error, true, false)
                    return
                }
                guard let result = snapshot?.documents.first else {return}
                let documentID = result[Strings.userDocumentIDField] as! String
                signedInUser.updateEmail(to: email) { (error) in
                    if error != nil {
                        completion(error, true, false)
                        return
                    }
                    db.collection(Strings.userCollection).document(documentID).updateData([Strings.userFirstNameField : firstName,
                                                                                           Strings.userLastNameField : lastName,
                                                                                           Strings.userEmailField : email,
                                                                                           Strings.userProfilePicField : profilePicURL])
                    completion(nil, true, true)
                }
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    //MARK: - FOR CHECKING
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func uploadProfilePic(with image: UIImage, using userID: String, completion: @escaping(Error?, String?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.4) else {return}
        let storagePath = Storage.storage().reference(forURL: Strings.firebaseStoragePath)
        let profilePicStoragePath = storagePath.child(Strings.firebaseProfilePicStoragePath).child(userID)
        let imageMetadata = StorageMetadata()
        imageMetadata.contentType = Strings.metadataContentType
        profilePicStoragePath.putData(imageData, metadata: imageMetadata) { (storageMetadata, error) in
            if error != nil {
                // Show error
                completion(error, nil)
                return
            }
            profilePicStoragePath.downloadURL { (url, error) in
                if error != nil {
                    // Show error
                    completion(error, nil)
                    return
                }
                guard let imageString = url?.absoluteString else {return}
                completion(nil, imageString)
            }
        }
    }
    
    
    
    
    
    func signOutUser() -> Bool? {
        if user != nil {
            do {
                try Auth.auth().signOut()
                return true
            } catch {
                // Show error message
                return false
            }
        } else {
            // Show error no user is signed in!
            return Bool()
        }
    }
    
    
    
    
    
    
    
}





