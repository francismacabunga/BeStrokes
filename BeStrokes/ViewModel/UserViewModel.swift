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
    
    private let user = Auth.auth().currentUser
    private let db = Firestore.firestore()
    
    func getSignedInUserData(completion: @escaping(UserViewModel) -> Void) {
        if user != nil {
            let signedInUserID = user!.uid
            db.collection(Strings.userCollection).whereField(Strings.userIDField, isEqualTo: signedInUserID).addSnapshotListener { (snapshot, error) in
                if error != nil {
                    // Show error
                }
                guard let result = snapshot?.documents.first else {return}
                let userViewModel = UserViewModel(UserModel(documentID: result[Strings.userDocumentIDField] as! String,
                                                            userID: result[Strings.userIDField] as! String,
                                                            firstName: result[Strings.userFirstNameField] as! String,
                                                            lastName: result[Strings.userLastNameField] as! String,
                                                            email: result[Strings.userEmailField] as! String,
                                                            profilePic: result[Strings.userProfilePicField] as! String))
                completion(userViewModel)
            }
        } else {
            // Show error no user is signed in!
        }
    }
    
    func isEmailVerified(completion: @escaping (Bool) -> Void) {
        if user != nil {
            user?.reload(completion: { (error) in
                if error != nil {
                    // Show error
                }
                if user!.isEmailVerified {
                    completion(true)
                } else {
                    completion(false)
                }
            })
        } else {
            // Showb error no user is signed in!
        }
    }
    
    func sendEmailVerification(completion: @escaping (Bool) -> Void) {
        if user != nil {
            user!.sendEmailVerification { (error) in
                if error != nil {
                    // Show error
                    completion(false)
                }
                completion(true)
            }
        } else {
            // Show error no user is signed in!
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
    
    func updateUserData(_ firstName: String, _ lastName: String, _ email: String, _ profilePicURL: String, completion: @escaping (Bool) -> Void) {
        if user != nil {
            user!.reload(completion: { (error) in
                if error != nil {
                    // Show error
                }
                let isEmailVerified = user!.isEmailVerified
                if isEmailVerified {
                    let signedInUserID = user!.uid
                    let initialUserEmail = user!.email
                    db.collection(Strings.userCollection).whereField(Strings.userIDField, isEqualTo: signedInUserID).getDocuments { (snapshot, error) in
                        if error != nil {
                            // Show error
                        }
                        guard let result = snapshot?.documents.first else {return}
                        let documentID = result[Strings.userDocumentIDField] as! String
                        user!.updateEmail(to: email, completion: { (error) in
                            if error != nil {
                                // Show error
                            }
                            // Password successfully changed
                            print("Email changed")
                            db.collection(Strings.userCollection)
                                .document(documentID)
                                .updateData([Strings.userFirstNameField : firstName,
                                             Strings.userLastNameField : lastName,
                                             Strings.userEmailField : email,
                                             Strings.userProfilePicField : profilePicURL])
                            if initialUserEmail != email {
                                sendEmailVerification { (result) in
                                    if result {
                                        completion(true)
                                    } else {
                                        completion(false)
                                    }
                                }
                            }
                        })
                    }
                } else {
                    // Email is not verified
                    print("Email is not verified")
                }
            })
        } else {
            // Show error no user is signed in!
        }
    }
    
    func uploadProfilePic(with image: UIImage, using userID: String, completion: @escaping(String) -> Void) {
        if user != nil {
            guard let imageData = image.jpegData(compressionQuality: 0.4) else {return}
            let storagePath = Storage.storage().reference(forURL: Strings.firebaseStoragePath)
            let profilePicStoragePath = storagePath.child(Strings.firebaseProfilePicStoragePath).child(userID)
            let imageMetadata = StorageMetadata()
            imageMetadata.contentType = Strings.metadataContentType
            profilePicStoragePath.putData(imageData, metadata: imageMetadata) { (storageMetadata, error) in
                if error != nil {
                    // Show error
                }
                profilePicStoragePath.downloadURL { (url, error) in
                    if error != nil {
                        // Show error
                    }
                    guard let imageString = url?.absoluteString else {return}
                    completion(imageString)
                }
            }
        } else {
            // Show error no user is signed in!
        }
    }
    
}





