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
    let profilePic: URL
    
    init(user: User) {
        self.userID = user.userID
        self.firstName = user.firstName
        self.lastname = user.lastName
        self.profilePic = user.profilePic
    }
    
}

struct FetchUserData {
    
    private let user = Auth.auth().currentUser
    private let db = Firestore.firestore()
    
    func getProfilePicture(completed: @escaping(URL)->Void) {
        if user != nil {
            let userID = user?.uid
            db.collection(Strings.userCollection).whereField(Strings.userIDField, isEqualTo: userID!).getDocuments { (snapshot, error) in
                if error != nil {
                    // Show error
                }
                guard let result = snapshot?.documents.first else {return}
                let profilePicImageURL = URL(string: result[Strings.userProfilePicField] as! String)!
                completed(profilePicImageURL)
            }
        }
    }
    
}
