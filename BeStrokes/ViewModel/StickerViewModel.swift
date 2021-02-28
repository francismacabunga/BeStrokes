//
//  StickerViewModel.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 12/29/20.
//

import Foundation
import Firebase

struct FeaturedStickerViewModel {
    
    let stickerID: String
    let name: String
    let image: String
    let description: String
    let category: String
    let tag: String
    
    init(_ featuredSticker: StickerModel) {
        self.stickerID = featuredSticker.stickerID
        self.name = featuredSticker.name
        self.image = featuredSticker.image
        self.description = featuredSticker.description
        self.category = featuredSticker.category
        self.tag = featuredSticker.tag
    }
    
}

struct StickerCategoryViewModel {
    
    let category: String
    var isCategorySelected: Bool
    
    init(_ category: StickerCategoryModel) {
        self.category = category.category
        self.isCategorySelected = category.isCategorySelected
    }
    
}

struct StickerViewModel {
    
    let stickerID: String
    let name: String
    let image: String
    let description: String
    let category: String
    let tag: String
    
    init(_ sticker: StickerModel) {
        self.stickerID = sticker.stickerID
        self.name = sticker.name
        self.image = sticker.image
        self.description = sticker.description
        self.category = sticker.category
        self.tag = sticker.tag
    }
    
}

struct LovedStickerViewModel {
    
    let stickerID: String
    let name: String
    let image: String
    let description: String
    let category: String
    let tag: String
    
    init(_ sticker: StickerModel) {
        self.stickerID = sticker.stickerID
        self.name = sticker.name
        self.image = sticker.image
        self.description = sticker.description
        self.category = sticker.category
        self.tag = sticker.tag
    }
    
}

struct FetchStickerData {
    
    private let user = Auth.auth().currentUser
    private let db = Firestore.firestore()
    
    func featuredStickerCollectionView(completion: @escaping (Error?, [FeaturedStickerViewModel]?) -> Void) {
        let firebaseQuery = db.collection(Strings.stickerCollection).whereField(Strings.stickerTagField, isEqualTo: Strings.categoryFeaturedStickers)
        fetchFirebaseData(with: firebaseQuery) { (error, stickerData) in
            guard let error = error else {
                guard let stickerData = stickerData else {return}
                let featuredStickerViewModel = stickerData.map({return FeaturedStickerViewModel($0)})
                completion(nil, featuredStickerViewModel)
                return
            }
            completion(error, nil)
        }
    }
    
    func stickerCollectionView(category: String, completion: @escaping (Error?, [StickerViewModel]?) -> Void) {
        var firebaseQuery: Query
        if category == Strings.allStickers {
            firebaseQuery = db.collection(Strings.stickerCollection)
            fetchFirebaseData(with: firebaseQuery) { (error, stickerData) in
                guard let error = error else {
                    guard let stickerData = stickerData else {return}
                    let stickerViewModel = stickerData.map({return StickerViewModel($0)})
                    completion(nil, stickerViewModel)
                    return
                }
                completion(error, nil)
            }
        } else {
            firebaseQuery = db.collection(Strings.stickerCollection).whereField(Strings.stickerCategoryField, isEqualTo: category)
            fetchFirebaseData(with: firebaseQuery) { (error, stickerData) in
                guard let error = error else {
                    guard let stickerData = stickerData else {return}
                    let stickerViewModel = stickerData.map({return StickerViewModel($0)})
                    completion(nil, stickerViewModel)
                    return
                }
                completion(error, nil)
            }
        }
    }
    
    func fetchFirebaseData(with query: Query, completion: @escaping (Error?, [StickerModel]?) -> Void) {
        query.addSnapshotListener { (snapshot, error) in
            guard let error = error else {
                guard let stickerData = snapshot?.documents else {return}
                let stickerModel = stickerData.map({return StickerModel(stickerID: $0[Strings.stickerIDField] as! String,
                                                                        name: $0[Strings.stickerNameField] as! String,
                                                                        image: $0[Strings.stickerImageField] as! String,
                                                                        description: $0[Strings.stickerDescriptionField] as! String,
                                                                        category: $0[Strings.stickerCategoryField] as! String,
                                                                        tag: $0[Strings.stickerTagField] as! String)})
                completion(nil, stickerModel)
                return
            }
            completion(error, nil)
        }
    }
    
    func stickerCategory() -> [StickerCategoryViewModel] {
        let stickerCategoryViewModel = [StickerCategoryViewModel(StickerCategoryModel(category: Strings.allStickers, isCategorySelected: true)),
                                        StickerCategoryViewModel(StickerCategoryModel(category: Strings.animalStickers, isCategorySelected: false)),
                                        StickerCategoryViewModel(StickerCategoryModel(category: Strings.foodStickers, isCategorySelected: false)),
                                        StickerCategoryViewModel(StickerCategoryModel(category: Strings.objectStickers, isCategorySelected: false)),
                                        StickerCategoryViewModel(StickerCategoryModel(category: Strings.coloredStickers, isCategorySelected: false)),
                                        StickerCategoryViewModel(StickerCategoryModel(category: Strings.travelStickers, isCategorySelected: false))]
        return stickerCategoryViewModel
    }
    
    func stickerCount(completion: @escaping (Error?, [StickerViewModel]?) -> Void) {
        db.collection(Strings.stickerCollection).getDocuments { (snapshot, error) in
            guard let error = error else {
                guard let stickerData = snapshot?.documents else {return}
                let stickerViewModel = stickerData.map({return StickerViewModel(StickerModel(stickerID: $0[Strings.stickerIDField] as! String,
                                                                                             name: $0[Strings.stickerNameField] as! String,
                                                                                             image: $0[Strings.stickerImageField] as! String,
                                                                                             description: $0[Strings.stickerDescriptionField] as! String,
                                                                                             category: $0[Strings.stickerCategoryField] as! String,
                                                                                             tag: $0[Strings.stickerTagField] as! String))})
                completion(nil, stickerViewModel)
                return
            }
            completion(error, nil)
        }
    }
    
    func searchSticker(using searchTextFieldText: String, completion: @escaping (Error?, Bool, Bool?, LovedStickerViewModel?) -> Void) {
        guard let signedInUser = user else {
            completion(nil, false, nil, nil)
            return
        }
        db.collection(Strings.userCollection).document(signedInUser.uid).collection(Strings.lovedStickerCollection).whereField(Strings.stickerNameField, isEqualTo: searchTextFieldText).getDocuments { (snapshot, error) in
            guard let error = error else {
                guard let stickerData = snapshot?.documents.first else {
                    completion(nil, true, false, nil)
                    return
                }
                let searchedSticker = LovedStickerViewModel(StickerModel(stickerID: stickerData[Strings.stickerIDField] as! String,
                                                                         name: stickerData[Strings.stickerNameField] as! String,
                                                                         image: stickerData[Strings.stickerImageField] as! String,
                                                                         description: stickerData[Strings.stickerDescriptionField] as! String,
                                                                         category: stickerData[Strings.stickerCategoryField] as! String,
                                                                         tag: stickerData[Strings.stickerTagField] as! String))
                completion(nil, true, true, searchedSticker)
                return
            }
            completion(error, true, nil, nil)
        }
    }
    
}

struct HeartButtonLogic {
    
    private let user = Auth.auth().currentUser
    private let db = Firestore.firestore()
    private let userViewModel = User()
    
    func checkIfStickerIsLoved(using stickerID: String, completion: @escaping (Error?, Bool, Bool?) -> Void) {
        guard let signedInUser = user else {
            completion(nil, false, nil)
            return
        }
        let signedInUserID = signedInUser.uid
        db.collection(Strings.stickerCollection).document(stickerID).collection(Strings.lovedByCollection).whereField(Strings.userIDField, isEqualTo: signedInUserID).addSnapshotListener { (snapshot, error) in
            guard let error = error else {
                guard let _ = snapshot?.documents.first else {
                    completion(nil, true, false)
                    return
                }
                completion(nil, true, true)
                return
            }
            completion(error, true, nil)
        }
    }
    
    func showLovedSticker(completion: @escaping (Error?, Bool, [LovedStickerViewModel]?) -> Void) {
        userViewModel.getSignedInUserData { (error, isUserSignedIn, userData) in
            if error != nil {
                completion(error, true, nil)
                return
            }
            if !isUserSignedIn {
                completion(nil, false, nil)
                return
            }
            guard let userData = userData else {return}
            db.collection(Strings.userCollection).document(userData.userID).collection(Strings.lovedStickerCollection).addSnapshotListener { (snapshot, error) in
                guard let error = error else {
                    guard let result = snapshot?.documents else {return}
                    let lovedStickers = result.map({return LovedStickerViewModel(StickerModel(stickerID: $0[Strings.stickerIDField] as! String,
                                                                                              name: $0[Strings.stickerNameField] as! String,
                                                                                              image: $0[Strings.stickerImageField] as! String,
                                                                                              description: $0[Strings.stickerDescriptionField] as! String,
                                                                                              category: $0[Strings.stickerCategoryField] as! String,
                                                                                              tag: $0[Strings.stickerTagField] as! String))})
                    completion(nil, true, lovedStickers)
                    return
                }
                completion(error, true, nil)
            }
        }
    }
    
    func tapHeartButton(using stickerID: String, with stickerDataDictionary: [String : String], completion: @escaping (Error?, Bool, Bool) -> Void) {
        userViewModel.getSignedInUserData { (error, isUserSignedIn, userData) in
            if error != nil {
                completion(error, true, false)
                return
            }
            if !isUserSignedIn {
                completion(nil, false, false)
                return
            }
            guard let userData = userData else {return}
            let userDataDictionary = [Strings.userIDField : userData.userID,
                                      Strings.userFirstNameField : userData.firstName,
                                      Strings.userLastNameField : userData.lastname,
                                      Strings.userEmailField : userData.email]
            // Save User Data to Sticker Collection -- checkIfStickerIsLoved
            db.collection(Strings.stickerCollection).document(stickerID).collection(Strings.lovedByCollection).document(userData.userID).setData(userDataDictionary) { (error) in
                if error != nil {
                    completion(error, true, false)
                    return
                }
            }
            // Save Sticker Data to User Collection -- showLovedSticker
            db.collection(Strings.userCollection).document(userData.userID).collection(Strings.lovedStickerCollection).document(stickerID).setData(stickerDataDictionary) { (error) in
                if error != nil {
                    completion(error, true, false)
                    return
                }
            }
            completion(nil, true, true)
        }
    }
    
    func untapHeartButton(using stickerID: String, completion: @escaping (Error?, Bool, Bool) -> Void) {
        userViewModel.getSignedInUserData { (error, isUserSignedIn, userData) in
            if error != nil {
                completion(error, true, false)
                return
            }
            if !isUserSignedIn {
                completion(nil, false, false)
                return
            }
            guard let userData = userData else {return}
            // Remove Sticker Data to User Collection
            db.collection(Strings.userCollection).document(userData.userID).collection(Strings.lovedStickerCollection).document(stickerID).delete { (error) in
                if error != nil {
                    completion(error, true, false)
                    return
                }
            }
            // Remove User Data to Sticker Collection
            db.collection(Strings.stickerCollection).document(stickerID).collection(Strings.lovedByCollection).document(userData.userID).delete { (error) in
                if error != nil {
                    completion(error, true, false)
                    return
                }
            }
            completion(nil, true, true)
        }
    }
    
}



