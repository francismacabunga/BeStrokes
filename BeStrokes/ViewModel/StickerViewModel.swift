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
        db.collection(Strings.stickerCollection).document(stickerDocumentID).collection(Strings.heartByCollection).whereField(Strings.userIDField, isEqualTo: signedInUserID).addSnapshotListener { (snapshot, error) in
            if error != nil {
                // Show error
            }
            if let results = snapshot?.documents  {
                for result in results {
                    let userID = result[Strings.userIDField] as! String
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
            let query = db.collection(Strings.stickerCollection).document(stickerDocumentID).collection(Strings.heartByCollection).document()
            userData[Strings.userDocumentIDField] = query.documentID
            query.setData(userData)
        }
    }
    
    func removeUserData(using stickerDocumentID: String) {
        guard let signedInUser = user else {return}
        let signedInUserID = signedInUser.uid
        db.collection(Strings.stickerCollection).document(stickerDocumentID).collection(Strings.heartByCollection).whereField(Strings.userIDField, isEqualTo: signedInUserID).getDocuments { [self] (snapshot, error) in
            if error != nil {
                // Show error
            }
            guard let result = snapshot?.documents.first else {return}
            let userDocumentID = result[Strings.userDocumentIDField] as! String
            db.collection(Strings.stickerCollection).document(stickerDocumentID).collection(Strings.heartByCollection).document(userDocumentID).delete()
        }
    }
    
    func getSignedInUserData(completion: @escaping ([String:String])->Void) {
        guard let signedInUser = user else {return}
        let signedInUserID = signedInUser.uid
        let userEmail = signedInUser.email!
        db.collection(Strings.userCollection).whereField(Strings.userIDField, isEqualTo: signedInUserID).getDocuments { (snapshot, error) in
            if error != nil {
                // Show error
            } else {
                guard let result = snapshot?.documents.first else {return}
                let firstName = result[Strings.userFirstNameField] as! String
                completion([Strings.userIDField: signedInUserID, Strings.userFirstNameField: firstName, Strings.userEmailField: userEmail])
            }
        }
    }
    
}

struct FetchStickerData {
    
    private let db = Firestore.firestore()
    
    func onCollectionViewData(withTag stickerTag: String? = nil, category: String? = nil, completed: @escaping([Sticker])->Void) {
        
        var firebaseQuery: Query
        
        if stickerTag == Strings.featuredStickers {
            firebaseQuery = db.collection(Strings.stickerCollection).whereField(Strings.stickerTagField, isEqualTo: stickerTag!)
            fetchFirebaseData(query: firebaseQuery) { (result) in
                completed(result)
                return
            }
        } else if category == nil || category == Strings.allStickers {
            firebaseQuery = db.collection(Strings.stickerCollection)
            fetchFirebaseData(query: firebaseQuery) { (result) in
                completed(result)
                return
            }
        } else if category != nil {
            firebaseQuery = db.collection(Strings.stickerCollection).whereField(Strings.stickerCategoryField, isEqualTo: category!)
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
            let stickerData = results.map({return Sticker(stickerDocumentID: $0[Strings.stickerDocumentIDField] as! String,
                                                          name: $0[Strings.stickerNameField] as! String,
                                                          image: URL(string: $0[Strings.stickerImageField] as! String)!,
                                                          description: $0[Strings.stickerDescriptionField] as! String,
                                                          category: $0[Strings.stickerCategoryField] as! String,
                                                          tag: $0[Strings.stickerTagField] as! String)})
            completed(stickerData)
        }
    }
    
}

