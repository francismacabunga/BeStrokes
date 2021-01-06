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
    let description: String
    let category: String
    let tag: String
    
    init(featuredSticker: Sticker) {
        self.stickerDocumentID = featuredSticker.stickerDocumentID
        self.name = featuredSticker.name
        self.image = featuredSticker.image
        self.description = featuredSticker.description
        self.category = featuredSticker.category
        self.tag = featuredSticker.tag
    }
    
}

struct StickerViewModel {
    
    let stickerDocumentID: String
    let name: String
    let image: URL
    let description: String
    let category: String
    let tag: String
    
    init(sticker: Sticker) {
        self.stickerDocumentID = sticker.stickerDocumentID
        self.name = sticker.name
        self.image = sticker.image
        self.description = sticker.description
        self.category = sticker.category
        self.tag = sticker.tag
    }
    
}

struct HeartButtonLogic {
    
    private let user = Auth.auth().currentUser
    private let db = Firestore.firestore()
    
    func checkIfStickerLiked(using stickerDocumentID: String, completed: @escaping (Bool)->Void) {
        guard let signedInUser = user else {return}
        let signedInUserID = signedInUser.uid
        db.collection("stickers").document(stickerDocumentID).collection("heartBy").whereField("userID", isEqualTo: signedInUserID).addSnapshotListener { (snapshot, error) in
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
    
    func getSignedInUserData(completion: @escaping ([String:String])->Void) {
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

struct FetchStickerData {
    
    private let db = Firestore.firestore()
    
    func onCollectionViewData(withTag stickerTag: String? = nil, category: String? = nil, completed: @escaping([Sticker])->Void) {
        
        var firebaseQuery: Query
        
        if stickerTag == "Featured" {
            firebaseQuery = db.collection("stickers").whereField("tag", isEqualTo: stickerTag!)
            fetchFirebaseData(query: firebaseQuery) { (result) in
                completed(result)
                return
            }
        } else if category == nil || category == "All" {
            firebaseQuery = db.collection("stickers")
            fetchFirebaseData(query: firebaseQuery) { (result) in
                completed(result)
                return
            }
        } else if category != nil {
            firebaseQuery = db.collection("stickers").whereField("category", isEqualTo: category!)
            fetchFirebaseData(query: firebaseQuery) { (result) in
                completed(result)
                return
            }
        }
        
    }
    
    func fetchFirebaseData(query: Query, completed: @escaping([Sticker])->Void) {
        query.getDocuments { (snapshot, error) in
            if error != nil {
                // Show error
            }
            guard let results = snapshot?.documents else {return}
            let stickerData = results.map({return Sticker(stickerDocumentID: $0["documentID"] as! String,
                                                          name: $0["name"] as! String,
                                                          image: URL(string: $0["image"] as! String)!,
                                                          description: $0["description"] as! String,
                                                          category: $0["category"] as! String,
                                                          tag: $0["tag"] as! String)})
            completed(stickerData)
        }
    }
    
}

