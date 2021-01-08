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
    let profilePic: URL
    
    init(_ user: User) {
        self.userID = user.userID
        self.firstName = user.firstName
        self.lastname = user.lastName
        self.email = user.email
        self.profilePic = user.profilePic
    }
    
}

struct FetchUserData {
    
    private let user = Auth.auth().currentUser
    private let db = Firestore.firestore()
    
    func signedInUser(completed: @escaping(UserViewModel)->Void) {
        
        if user != nil {
            let userID = user!.uid
            let userEmail = user!.email!
            db.collection(Strings.userCollection).whereField(Strings.userIDField, isEqualTo: userID).getDocuments { (snapshot, error) in
                if error != nil {
                    // Show error
                }
                guard let result = snapshot?.documents.first else {return}
                
                let userID = result["userID"] as! String
                let firstName = result["firstName"] as! String
                let lastName = result["lastName"] as! String
                let profilePic = URL(string: result["profilePic"] as! String)!
                
                let userViewModel = UserViewModel(User(userID: userID, firstName: firstName, lastName: lastName, email: userEmail, profilePic: profilePic))
                completed(userViewModel)
                
            }
        }
        
    }
    
}





