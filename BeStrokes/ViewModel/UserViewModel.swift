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
    
    func isPasswordValid(_ password: String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    func createUser(with email: String, _ password: String, completion: @escaping (Error?, AuthDataResult?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if error != nil {
                completion(error, nil)
                return
            }
            completion(nil, authResult)
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
        })
    }
    
    func checkIfUserIsSignedIn(completion: @escaping (AuthErrorCode?, Bool) -> Void) {
        if user != nil {
            print("The user is signed in!")
            user!.reload { (error) in
                if error != nil {
                    guard let NSError = error as NSError? else {return}
                    if let error = AuthErrorCode(rawValue: NSError.code) {
                        return completion(error, true)
                    }
                }
                print("Valid token")
                return completion(nil, false)
            }
        } else {
            print("The user is not signed in!")
            completion(nil, true)
        }
    }
    
    func signInUser(with email: String, _ password: String, completion: @escaping (Error?, AuthDataResult?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if error != nil {
                completion(error, nil)
                return
            }
            completion(nil, authResult)
        }
    }
    
    
    
    
    
    
    
    
    
    
    //MARK: - FOR CHECKING
    
    
    
    
    
    
    
    func getSignedInUserData(completion: @escaping (UserViewModel) -> Void) {
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
    
    
    
    
    
    
    
    
    func isEmailVerified(completion: @escaping (Error?, Bool?) -> Void) {
        if user != nil {
            user?.reload(completion: { (error) in
                if error != nil {
                    // Show error
                    completion(error, nil)
                    return
                }
                if user!.isEmailVerified {
                    completion(nil, true)
                    return
                } else {
                    completion(nil, false)
                    return
                }
            })
        } else {
            // Showb error no user is signed in!
        }
    }
    
    
    
    
    
    func updateUserData(_ firstName: String, _ lastName: String, _ email: String, _ profilePicURL: String, completion: @escaping (Error?) -> Void) {
        if user != nil {
            user!.reload(completion: { (error) in
                if error != nil {
                    // Show error
                    completion(error)
                    return
                }
                let isEmailVerified = user!.isEmailVerified
                if isEmailVerified {
                    let signedInUserID = user!.uid
                    let initialUserEmail = user!.email
                    db.collection(Strings.userCollection).whereField(Strings.userIDField, isEqualTo: signedInUserID).getDocuments { (snapshot, error) in
                        if error != nil {
                            // Show error
                            completion(error)
                            return
                        }
                        guard let result = snapshot?.documents.first else {return}
                        let documentID = result[Strings.userDocumentIDField] as! String
                        user!.updateEmail(to: email, completion: { (error) in
                            if error != nil {
                                // Show error
                                completion(error)
                                return
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





