//
//  UserViewModel.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 1/5/21.
//

import Foundation

struct UserViewModel {
    
    let userIDs: String
    let firstName: String
    let lastname: String
    let email: String
    let profilePic: String
    
    init(_ user: UserModel) {
        self.userIDs = user.userIDs
        self.firstName = user.firstName
        self.lastname = user.lastName
        self.email = user.email
        self.profilePic = user.profilePic
    }
    
}
