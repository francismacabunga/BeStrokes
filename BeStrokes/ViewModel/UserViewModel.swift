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
                let documentID = result[Strings.userDocumentIDField] as! String
                let userID = result[Strings.userIDField] as! String
                let firstName = result[Strings.userFirstNameField] as! String
                let lastName = result[Strings.userLastNameField] as! String
                let email = result[Strings.userEmailField] as! String
                let profilePic = result[Strings.userProfilePicField] as! String
                let userViewModel = UserViewModel(UserModel(documentID: documentID,
                                                            userID: userID,
                                                            firstName: firstName,
                                                            lastName: lastName,
                                                            email: email,
                                                            profilePic: profilePic))
                completion(userViewModel)
            }
        } else {
            // Show error no user is signed in!
        }
    }
    
    func isEmailVerified() -> Bool {
        if user != nil {
            if user!.isEmailVerified {
                return true
            } else {
                return false
            }
        }
        return Bool()
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
    
    func updateUserData(_ firstName: String, _ lastName: String, _ email: String, _ profilePicURL: String) {
        if user != nil {
            user!.reload(completion: { (error) in
                if error != nil {
                    // Show error
                }
                let isEmailVerified = user!.isEmailVerified
                if isEmailVerified {
                    let signedInUserID = user!.uid
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





