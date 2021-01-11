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
    let profilePic: URL
    
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
    
    func getSignedInUserData(completed: @escaping(UserViewModel)->Void) {
        if user != nil {
            let signedInUserID = user!.uid
            db.collection(Strings.userCollection).whereField(Strings.userIDField, isEqualTo: signedInUserID).addSnapshotListener { (snapshot, error) in
                if error != nil {
                    // Show error
                }
                guard let result = snapshot?.documents.first else {return}
                
                let documentID = result["documentID"] as! String
                let userID = result["userID"] as! String
                let firstName = result["firstName"] as! String
                let lastName = result["lastName"] as! String
                let email = result["email"] as! String
                let profilePic = URL(string: result["profilePic"] as! String)!
                
                let userViewModel = UserViewModel(UserModel(documentID: documentID, userID: userID, firstName: firstName, lastName: lastName, email: email, profilePic: profilePic))
                completed(userViewModel)
            }
        }
    }
    
    func signOutUser()->Bool? {
        if user != nil {
            do {
                try Auth.auth().signOut()
                return true
            } catch {
                // Show error message
                return false
            }
        }
        // Show no signed in user message
        return Bool()
    }
    
    func updateUserData(_ firstName: String, _ lastName: String, _ email: String) {
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
                        Auth.auth().currentUser?.updateEmail(to: email, completion: { (error) in
                            if error != nil {
                                // Show error
                            }
                            // Password successfully changed
                            print("Email changed")
                            db.collection(Strings.userCollection)
                                .document(documentID)
                                .updateData([Strings.userFirstNameField : firstName,
                                             Strings.userLastNameField : lastName,
                                             Strings.userEmailField : email])
                        })
                    }
                }
                // Email is not verified
                print("Email is not verified")
            })
        }
    }
    
    
    
    
    
    
}





