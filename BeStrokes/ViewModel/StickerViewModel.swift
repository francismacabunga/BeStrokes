//
//  StickerViewModel.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 12/29/20.
//

import Foundation
import Firebase

struct StickerViewModel {
    
    let stickerDocumentID: String
    let name: String
    let image: URL
    let tag: String?
    
    let user = Auth.auth().currentUser
    let db = Firestore.firestore()
    
    
    init(sticker: Sticker) {
        self.stickerDocumentID = sticker.stickerDocumentID
        self.name = sticker.name
        self.image = sticker.image
        self.tag = sticker.tag
    }
    
    //MARK: - Heart Button Logic
    
    func isStickerLiked(completed: @escaping (Bool)->Void) {
        guard let signedInUser = user else {return}
        let signedInUserID = signedInUser.uid
        db.collection("stickers").document(stickerDocumentID).collection("heartBy").whereField("userID", isEqualTo: signedInUserID).addSnapshotListener { [self] (snapshot, error) in
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
    
    func saveUserData()  {
        getSignedInUserData { [self] (result) in
            var userData = result
            let userLikedDocument = db.collection("stickers").document(stickerDocumentID).collection("heartBy").document()
            userData["documentID"] = userLikedDocument.documentID
            userLikedDocument.setData(userData)
        }
    }
    
    func removeUserData() {
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
