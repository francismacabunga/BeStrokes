//
//  StickerViewModel.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 12/29/20.
//

import Foundation
import Firebase

struct FeaturedStickerViewModel {
    
    let stickerDocumentID: String
    let name: String
    let image: URL
    let tag: String?
    var isStickerLiked: Bool?
    
    let user = Auth.auth().currentUser
    let db = Firestore.firestore()
    
    init(featuredSticker: Sticker) {
        self.stickerDocumentID = featuredSticker.stickerDocumentID
        self.name = featuredSticker.name
        self.image = featuredSticker.image
        self.tag = featuredSticker.tag
        self.isStickerLiked = featuredSticker.isStickerLiked
    }
    
}

struct StickerViewModel {
    
    let stickerDocumentID: String
    let name: String
    let image: URL
    let tag: String?
    var isStickerLiked: Bool?
    
    init(sticker: Sticker) {
        self.stickerDocumentID = sticker.stickerDocumentID
        self.name = sticker.name
        self.image = sticker.image
        self.tag = sticker.tag
        self.isStickerLiked = sticker.isStickerLiked
    }
    
}

struct HeartButtonLogic {
    
    private let user = Auth.auth().currentUser
    private let db = Firestore.firestore()
    
    func checkIfStickerLiked(using stickerDocumentID: String, completed: @escaping (Bool)->Void) {
        guard let signedInUser = user else {return}
        let signedInUserID = signedInUser.uid
        let listener =  db.collection("stickers").document(stickerDocumentID).collection("heartBy").whereField("userID", isEqualTo: signedInUserID).addSnapshotListener { [self] (snapshot, error) in
            if error != nil {
                // Show error
            }
            if let results = snapshot?.documents  {
                for result in results {
                    let userID = result["userID"] as! String
                    if userID == signedInUserID {
                        completed(true)
                        return
                    }
                }
            }
            completed(false)
            return
        }
    }
    
    func saveUserData(using stickerDocumentID: String)  {
        getSignedInUserData { [self] (result) in
            var userData = result
            let query = db.collection("stickers").document(stickerDocumentID).collection("heartBy").document()
            userData["documentID"] = query.documentID
            query.setData(userData)
        }
    }
    
    func removeUserData(using stickerDocumentID: String) {
        guard let signedInUser = user else {return}
        let userID = signedInUser.uid
        db.collection("stickers").document(stickerDocumentID).collection("heartBy").whereField("userID", isEqualTo: userID).getDocuments { [self] (snapshot, error) in
            if error != nil {
                // Show error
            }
            guard let result = snapshot?.documents.first else {return}
            let userDocumentID = result["documentID"] as! String
            db.collection("stickers").document(stickerDocumentID).collection("heartBy").document(userDocumentID).delete()
        }
    }
    
    func getSignedInUserData(completion: @escaping ([String:String])-> Void) {
        guard let signedInUser = user else {return}
        let userID = signedInUser.uid
        let userEmail = signedInUser.email!
        db.collection("users").whereField("userID", isEqualTo: userID).getDocuments { (snapshot, error) in
            if error != nil {
                // Show error
            } else {
                guard let result = snapshot?.documents.first else {return}
                let firstName = result["firstName"] as! String
                completion(["userID": userID, "firstName": firstName, "email": userEmail])
            }
        }
    }
    
}



