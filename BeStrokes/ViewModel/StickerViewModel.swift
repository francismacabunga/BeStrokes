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

struct UserStickerViewModel {
    
    let stickerID: String
    let name: String
    let image: String
    let description: String
    let category: String
    let tag: String
    let isRecentlyUploaded: Bool
    let isNew: Bool
    let isLoved: Bool
    
    init(_ userSticker: UserStickerModel) {
        self.stickerID = userSticker.stickerID
        self.name = userSticker.name
        self.image = userSticker.image
        self.description = userSticker.description
        self.category = userSticker.category
        self.tag = userSticker.tag
        self.isRecentlyUploaded = userSticker.isRecentlyUploaded
        self.isNew = userSticker.isNew
        self.isLoved = userSticker.isLoved
    }
    
}

struct StickerCategoryViewModel {
    
    let category: String
    var isCategorySelected: Bool
    
    init(_ stickerCategory: StickerCategoryModel) {
        self.category = stickerCategory.category
        self.isCategorySelected = stickerCategory.isCategorySelected
    }
    
}

struct StickerData {
    
    private let user = Auth.auth().currentUser
    private let db = Firestore.firestore()
    private let userData = UserData()
    
    func fetchStickerData(withQuery query: Query,
                          withListener: Bool,
                          completion: @escaping (Error?, [StickerModel]?) -> Void)
    {
        if withListener {
            query.addSnapshotListener { (snapshot, error) in
                if error != nil {
                    completion(error, nil)
                    return
                }
                guard let stickerData = snapshot?.documents else {
                    completion(nil, nil)
                    return
                }
                let stickerModel = stickerData.map({return StickerModel(stickerID: $0[Strings.stickerIDField] as! String,
                                                                        name: $0[Strings.stickerNameField] as! String,
                                                                        image: $0[Strings.stickerImageField] as! String,
                                                                        description: $0[Strings.stickerDescriptionField] as! String,
                                                                        category: $0[Strings.stickerCategoryField] as! String,
                                                                        tag: $0[Strings.stickerTagField] as! String)})
                completion(nil, stickerModel)
            }
        } else {
            query.getDocuments { (snapshot, error) in
                if error != nil {
                    completion(error, nil)
                    return
                }
                guard let stickerData = snapshot?.documents else {
                    completion(nil, nil)
                    return
                }
                let stickerModel = stickerData.map({return StickerModel(stickerID: $0[Strings.stickerIDField] as! String,
                                                                        name: $0[Strings.stickerNameField] as! String,
                                                                        image: $0[Strings.stickerImageField] as! String,
                                                                        description: $0[Strings.stickerDescriptionField] as! String,
                                                                        category: $0[Strings.stickerCategoryField] as! String,
                                                                        tag: $0[Strings.stickerTagField] as! String)})
                completion(nil, stickerModel)
            }
        }
    }
    
    func fetchUserStickerData(withQuery query: Query,
                              withListener: Bool,
                              completion: @escaping (Error?, [UserStickerViewModel]?) -> Void)
    {
        if withListener {
            query.addSnapshotListener { (snapshot, error) in
                if error != nil {
                    completion(error, nil)
                    return
                }
                guard let userStickerData = snapshot?.documents else {
                    completion(nil, nil)
                    return
                }
                let userStickerViewModel = userStickerData.map({return UserStickerViewModel(UserStickerModel(stickerID: $0[Strings.stickerIDField] as! String,
                                                                                                             name: $0[Strings.stickerNameField] as! String,
                                                                                                             image: $0[Strings.stickerImageField] as! String,
                                                                                                             description: $0[Strings.stickerDescriptionField] as! String,
                                                                                                             category: $0[Strings.stickerCategoryField] as! String,
                                                                                                             tag: $0[Strings.stickerTagField] as! String,
                                                                                                             isRecentlyUploaded: $0[Strings.stickerIsRecentlyUploadedField] as! Bool,
                                                                                                             isNew: $0[Strings.stickerIsNewField] as! Bool,
                                                                                                             isLoved: $0[Strings.stickerIsLovedField] as! Bool))})
                completion(nil, userStickerViewModel)
            }
        } else {
            query.getDocuments { (snapshot, error) in
                if error != nil {
                    completion(error, nil)
                    return
                }
                guard let userStickerData = snapshot?.documents else {
                    completion(nil, nil)
                    return
                }
                let userStickerViewModel = userStickerData.map({return UserStickerViewModel(UserStickerModel(stickerID: $0[Strings.stickerIDField] as! String,
                                                                                                             name: $0[Strings.stickerNameField] as! String,
                                                                                                             image: $0[Strings.stickerImageField] as! String,
                                                                                                             description: $0[Strings.stickerDescriptionField] as! String,
                                                                                                             category: $0[Strings.stickerCategoryField] as! String,
                                                                                                             tag: $0[Strings.stickerTagField] as! String,
                                                                                                             isRecentlyUploaded: $0[Strings.stickerIsRecentlyUploadedField] as! Bool,
                                                                                                             isNew: $0[Strings.stickerIsNewField] as! Bool,
                                                                                                             isLoved: $0[Strings.stickerIsLovedField] as! Bool))})
                completion(nil, userStickerViewModel)
            }
        }
    }
    
    func fetchFeaturedSticker(completion: @escaping (Error?, [FeaturedStickerViewModel]?) -> Void) {
        let firebaseQuery = db.collection(Strings.stickerCollection).whereField(Strings.stickerTagField, isEqualTo: Strings.categoryFeaturedStickers)
        fetchStickerData(withQuery: firebaseQuery, withListener: true) { (error, stickerData) in
            guard let error = error else {
                guard let stickerData = stickerData else {return}
                let featuredStickerViewModel = stickerData.map({return FeaturedStickerViewModel($0)})
                completion(nil, featuredStickerViewModel)
                return
            }
            completion(error, nil)
        }
    }
    
    func fetchSticker(onCategory category: String,
                      completion: @escaping (Error?, [StickerViewModel]?) -> Void)
    {
        var firebaseQuery: Query
        if category == Strings.allStickers {
            firebaseQuery = db.collection(Strings.stickerCollection)
            fetchStickerData(withQuery: firebaseQuery, withListener: true) { (error, stickerData) in
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
            fetchStickerData(withQuery: firebaseQuery, withListener: true) { (error, stickerData) in
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
    
    func fetchStickerCategories() -> [StickerCategoryViewModel] {
        let stickerCategoryViewModel = [StickerCategoryViewModel(StickerCategoryModel(category: Strings.allStickers, isCategorySelected: true)),
                                        StickerCategoryViewModel(StickerCategoryModel(category: Strings.animalStickers, isCategorySelected: false)),
                                        StickerCategoryViewModel(StickerCategoryModel(category: Strings.foodStickers, isCategorySelected: false)),
                                        StickerCategoryViewModel(StickerCategoryModel(category: Strings.objectStickers, isCategorySelected: false)),
                                        StickerCategoryViewModel(StickerCategoryModel(category: Strings.coloredStickers, isCategorySelected: false)),
                                        StickerCategoryViewModel(StickerCategoryModel(category: Strings.travelStickers, isCategorySelected: false))]
        return stickerCategoryViewModel
    }
    
    func fetchRecentlyUploadedSticker(completion: @escaping (Error?, Bool, UserStickerViewModel?) -> Void) {
        userData.checkIfUserIsSignedIn { (error, isUserSignedIn, user) in
            if !isUserSignedIn {
                guard let error = error else {return}
                completion(error, false, nil)
                return
            }
            guard let signedInUser = user else {return}
            let firebaseQuery = db.collection(Strings.userCollection).document(signedInUser.uid).collection(Strings.stickerCollection).whereField(Strings.stickerIsRecentlyUploadedField, isEqualTo: true)
            fetchUserStickerData(withQuery: firebaseQuery, withListener: true) { (error, userStickerData) in
                guard let error = error else {
                    guard let userStickerViewModel = userStickerData?.first else {return}
                    completion(nil, true, userStickerViewModel)
                    return
                }
                completion(error, true, nil)
            }
        }
    }
    
    func fetchNewSticker(completion: @escaping (Error?, Bool, Int?, [UserStickerViewModel]?) -> Void) {
        userData.checkIfUserIsSignedIn { (error, isUserSignedIn, user) in
            if !isUserSignedIn {
                guard let error = error else {return}
                completion(error, false, nil, nil)
                return
            }
            guard let signedInUser = user else {return}
            let firebaseQuery = db.collection(Strings.userCollection).document(signedInUser.uid).collection(Strings.stickerCollection).whereField(Strings.stickerIsNewField, isEqualTo: true)
            fetchUserStickerData(withQuery: firebaseQuery, withListener: true) { (error, userStickerData) in
                guard let error = error else {
                    guard let userStickerViewModel = userStickerData else {return}
                    completion(nil, true, userStickerViewModel.count, userStickerViewModel)
                    return
                }
                completion(error, true, nil, nil)
            }
        }
    }
    
    func fetchLovedSticker(on stickerID: String? = nil,
                           completion: @escaping (Error?, Bool, Bool?, [UserStickerViewModel]?) -> Void)
    {
        userData.checkIfUserIsSignedIn { (error, isUserSignedIn, user) in
            if !isUserSignedIn {
                guard let error = error else {return}
                completion(error, false, nil, nil)
                return
            }
            guard let signedInUser = user else {return}
            if stickerID != nil {
                let firebaseQuery = db.collection(Strings.userCollection).document(signedInUser.uid).collection(Strings.stickerCollection).whereField(Strings.stickerIDField, isEqualTo: stickerID!).whereField(Strings.stickerIsLovedField, isEqualTo: true)
                fetchUserStickerData(withQuery: firebaseQuery, withListener: true) { (error, userStickerData) in
                    if error != nil {
                        completion(error, true, nil, nil)
                        return
                    }
                    guard let _ = userStickerData?.first else {
                        completion(nil, true, false, nil)
                        return
                    }
                    completion(nil, true, true, nil)
                }
            } else {
                let firebaseQuery = db.collection(Strings.userCollection).document(signedInUser.uid).collection(Strings.stickerCollection).whereField(Strings.stickerIsLovedField, isEqualTo: true)
                fetchUserStickerData(withQuery: firebaseQuery, withListener: true) { (error, userStickerData) in
                    guard let error = error else {
                        guard let userStickerViewModel = userStickerData else {return}
                        completion(nil, true, nil, userStickerViewModel)
                        return
                    }
                    completion(error, true, nil, nil)
                }
            }
        }
    }
    
    func searchSticker(using searchText: String,
                       completion: @escaping (Error?, Bool, UserStickerViewModel?) -> Void)
    {
        userData.checkIfUserIsSignedIn { (error, isUserSignedIn, user) in
            if !isUserSignedIn {
                guard let error = error else {return}
                completion(error, false, nil)
                return
            }
            guard let signedInUser = user else {return}
            let firebaseQuery = db.collection(Strings.userCollection).document(signedInUser.uid).collection(Strings.stickerCollection).whereField(Strings.stickerIsLovedField, isEqualTo: true).whereField(Strings.stickerNameField, isEqualTo: searchText)
            fetchUserStickerData(withQuery: firebaseQuery, withListener: false) { (error, userStickerData) in
                if error != nil {
                    completion(error, true, nil)
                    return
                }
                guard let userStickerViewModel = userStickerData?.first else {
                    completion(nil, true, nil)
                    return
                }
                completion(nil, true, userStickerViewModel)
            }
        }
    }
    
    func checkIfStickerExistsInUserCollection(stickerViewModel: [StickerViewModel],
                                              completion: @escaping (Error?, Bool, Bool?, StickerViewModel?) -> Void)
    {
        userData.checkIfUserIsSignedIn { (error, isUserSignedIn, user) in
            if !isUserSignedIn {
                guard let error = error else {return}
                completion(error, false, nil, nil)
                return
            }
            guard let signedInUser = user else {return}
            _ = stickerViewModel.map({
                let newSticker = $0
                let firebaseQuery = db.collection(Strings.userCollection).document(signedInUser.uid).collection(Strings.stickerCollection).whereField(Strings.stickerIDField, isEqualTo: $0.stickerID)
                fetchUserStickerData(withQuery: firebaseQuery, withListener: false) { (error, userStickerData) in
                    if error != nil {
                        completion(error, true, nil, nil)
                        return
                    }
                    guard let _ = userStickerData?.first else {
                        completion(nil, true, false, newSticker)
                        return
                    }
                    completion(nil, true, true, newSticker)
                }
            })
        }
    }
    
    func checkIfUserStickerExistsInStickerCollection(completion: @escaping (Error?, Bool) -> Void) {
        userData.checkIfUserIsSignedIn { (error, isUserSignedIn, user) in
            if !isUserSignedIn {
                guard let error = error else {return}
                completion(error, false)
                return
            }
            guard let signedInUser = user else {return}
            let firebaseQuery1 = db.collection(Strings.userCollection).document(signedInUser.uid).collection(Strings.stickerCollection)
            fetchUserStickerData(withQuery: firebaseQuery1, withListener: false) { (error, userStickerData) in
                if error != nil {
                    completion(error, true)
                    return
                }
                guard let userStickerData = userStickerData else {return}
                _ = userStickerData.map({
                    let missingStickerID = $0.stickerID
                    let firebaseQuery2 = db.collection(Strings.stickerCollection).whereField(Strings.stickerIDField, isEqualTo: $0.stickerID)
                    fetchStickerData(withQuery: firebaseQuery2, withListener: false) { (error, stickerData) in
                        if error != nil {
                            completion(error, true)
                            return
                        }
                        guard let _ = stickerData?.first else {
                            db.collection(Strings.userCollection).document(signedInUser.uid).collection(Strings.stickerCollection).document(missingStickerID).delete { (error) in
                                guard let error = error else {return}
                                completion(error, true)
                            }
                            return
                        }
                    }
                })
            }
        }
    }
    
    func uploadStickerInUserCollection(from stickerViewModel: [StickerViewModel],
                                       isRecentlyUploaded: Bool,
                                       isNew: Bool,
                                       completion: @escaping (Error?, Bool) -> Void)
    {
        userData.checkIfUserIsSignedIn { (error, isUserSignedIn, user) in
            if !isUserSignedIn {
                guard let error = error else {return}
                completion(error, false)
                return
            }
            guard let signedInUser = user else {return}
            _ = stickerViewModel.map({
                let userStickerViewModelDictionary: [String : Any] = [Strings.stickerIDField : $0.stickerID,
                                                                      Strings.stickerNameField : $0.name,
                                                                      Strings.stickerImageField : $0.image,
                                                                      Strings.stickerDescriptionField : $0.description,
                                                                      Strings.stickerCategoryField : $0.category,
                                                                      Strings.stickerTagField : $0.tag,
                                                                      Strings.stickerIsRecentlyUploadedField : isRecentlyUploaded,
                                                                      Strings.stickerIsNewField : isNew,
                                                                      Strings.stickerIsLovedField : false]
                db.collection(Strings.userCollection).document(signedInUser.uid).collection(Strings.stickerCollection).document($0.stickerID).setData(userStickerViewModelDictionary) { (error) in
                    guard let error = error else {return}
                    completion(error, true)
                }
            })
        }
    }
    
    func updateRecentlyUploadedSticker(on stickerID: String,
                                       completion: @escaping (Error?, Bool) -> Void)
    {
        userData.checkIfUserIsSignedIn { (error, isUserSignedIn, user) in
            if !isUserSignedIn {
                guard let error = error else {return}
                completion(error, false)
                return
            }
            guard let signedInUser = user else {return}
            db.collection(Strings.userCollection).document(signedInUser.uid).collection(Strings.stickerCollection).document(stickerID).updateData([Strings.stickerIsRecentlyUploadedField : false]) { (error) in
                guard let error = error else {return}
                completion(error, true)
            }
        }
    }
    
    func updateNewSticker(on stickerID: String,
                          completion: @escaping (Error?, Bool) -> Void)
    {
        userData.checkIfUserIsSignedIn { (error, isUserSignedIn, user) in
            if !isUserSignedIn {
                guard let error = error else {return}
                completion(error, false)
                return
            }
            guard let signedInUser = user else {return}
            db.collection(Strings.userCollection).document(signedInUser.uid).collection(Strings.stickerCollection).document(stickerID).updateData([Strings.stickerIsNewField : false]) { (error) in
                guard let error = error else {return}
                completion(error, true)
            }
        }
    }
    
}

struct HeartButtonLogic {
    
    private let user = Auth.auth().currentUser
    private let db = Firestore.firestore()
    private let userData = UserData()
    
    func tapHeartButton(using stickerID: String,
                        completion: @escaping (Error?, Bool) -> Void)
    {
        userData.getSignedInUserData { (error, isUserSignedIn, userData) in
            if !isUserSignedIn {
                guard let error = error else {return}
                completion(error, false)
                return
            }
            if error != nil {
                completion(error, true)
                return
            }
            guard let userData = userData else {return}
            let userDataDictionary = [Strings.userIDField : userData.userID,
                                      Strings.userFirstNameField : userData.firstName,
                                      Strings.userLastNameField : userData.lastname,
                                      Strings.userEmailField : userData.email]
            db.collection(Strings.stickerCollection).document(stickerID).collection(Strings.lovedByCollection).document(userData.userID).setData(userDataDictionary) { (error) in
                guard let error = error else {return}
                completion(error, true)
            }
            db.collection(Strings.userCollection).document(userData.userID).collection(Strings.stickerCollection).document(stickerID).updateData([Strings.stickerIsLovedField : true]) { (error) in
                guard let error = error else {return}
                completion(error, true)
            }
        }
    }
    
    func untapHeartButton(using stickerID: String,
                          completion: @escaping (Error?, Bool, Bool?) -> Void)
    {
        userData.checkIfUserIsSignedIn { (error, isUserSignedIn, user) in
            if !isUserSignedIn {
                guard let error = error else {return}
                completion(error, false, nil)
                return
            }
            guard let signedInUser = user else {return}
            db.collection(Strings.stickerCollection).document(stickerID).collection(Strings.lovedByCollection).document(signedInUser.uid).delete { (error) in
                guard let error = error else {return}
                completion(error, true, false)
            }
            db.collection(Strings.userCollection).document(signedInUser.uid).collection(Strings.stickerCollection).document(stickerID).updateData([Strings.stickerIsLovedField : false]) { (error) in
                guard let error = error else {
                    completion(nil, true, true)
                    return
                }
                completion(error, true, false)
            }
        }
    }
    
}
