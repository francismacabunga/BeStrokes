//
//  Service.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 5/22/21.
//

import Foundation
import Firebase

struct Service {
    
    //MARK: - User Data Related Firebase Functions
    
    private let db = Firestore.firestore()
    private let auth = Auth.auth()
    private let user = Auth.auth().currentUser
    
    func isPasswordValid(_ password: String) -> Bool {
        let passwordTest = NSPredicate(format: Strings.regexFormat, Strings.validationType)
        return passwordTest.evaluate(with: password)
    }
    
    func createUser(with email: String,
                    and password: String,
                    completion: @escaping (Error?, AuthDataResult?) -> Void)
    {
        auth.createUser(withEmail: email, password: password) { (authResult, error) in
            guard let error = error else {
                completion(nil, authResult)
                return
            }
            completion(error, nil)
        }
    }
    
    func storeData(using userID: String,
                   with dictionary: [String : String],
                   completion: @escaping (Error?, Bool) -> Void)
    {
        db.collection(Strings.userCollection).document(userID).setData(dictionary) { (error) in
            guard let error = error else {
                completion(nil, true)
                return
            }
            completion(error, false)
        }
    }
    
    func sendEmailVerification(completion: @escaping (Error?, Bool, Bool) -> Void) {
        checkIfUserIsSignedIn { (error, isUserSignedIn, user) in
            if !isUserSignedIn {
                guard let error = error else {return}
                completion(error, false, false)
                return
            }
            guard let signedInUser = user else {return}
            signedInUser.sendEmailVerification { (error) in
                guard let error = error else {
                    completion(nil, true, true)
                    return
                }
                completion(error, true, false)
            }
        }
    }
    
    func signInUser(with email: String,
                    and password: String,
                    completion: @escaping (Error?, AuthDataResult?) -> Void)
    {
        auth.signIn(withEmail: email, password: password) { (authResult, error) in
            guard let error = error else {
                completion(nil, authResult)
                return
            }
            completion(error, nil)
        }
    }
    
    func forgotPassword(with email: String, completion: @escaping (Error?, Bool) -> Void) {
        auth.sendPasswordReset(withEmail: email) { (error) in
            guard let error = error else {
                completion(nil, true)
                return
            }
            completion(error, false)
        }
    }
    
    func checkIfUserIsSignedIn(completion: @escaping (Error?, Bool, User?) -> Void) {
        guard let signedInUser = auth.currentUser else {return}
        signedInUser.reload { (error) in
            guard let error = error else {
                completion(nil, true, signedInUser)
                return
            }
            completion(error, false, nil)
        }
    }
    
    func getSignedInUserData(completion: @escaping (Error?, Bool, UserViewModel?) -> Void) {
        checkIfUserIsSignedIn { (error, isUserSignedIn, user) in
            if !isUserSignedIn {
                guard let error = error else {return}
                completion(error, false, nil)
                return
            }
            guard let signedInUser = user else {return}
            db.collection(Strings.userCollection).document(signedInUser.uid).getDocument { (snapshot, error) in
                guard let error = error else {
                    guard let userData = snapshot else {return}
                    let userViewModel = UserViewModel(UserModel(userID: userData[Strings.userIDField] as! String,
                                                                firstName: userData[Strings.userFirstNameField] as! String,
                                                                lastName: userData[Strings.userLastNameField] as! String,
                                                                email: userData[Strings.userEmailField] as! String,
                                                                profilePic: userData[Strings.userProfilePicField] as! String))
                    completion(nil, true, userViewModel)
                    return
                }
                completion(error, true, nil)
            }
        }
    }
    
    func isEmailVerified(completion: @escaping (Error?, Bool, Bool) -> Void) {
        checkIfUserIsSignedIn { (error, isUserSignedIn, user) in
            if !isUserSignedIn {
                guard let error = error else {return}
                completion(error, false, false)
                return
            }
            guard let signedInUser = user else {return}
            if signedInUser.isEmailVerified {
                completion(nil, true, true)
            } else {
                completion(nil, true, false)
            }
        }
    }
    
    func updateUserData(_ firstName: String,
                        _ lastName: String,
                        _ email: String,
                        _ profilePicURL: String,
                        completion: @escaping (Error?, Bool, Bool) -> Void)
    {
        checkIfUserIsSignedIn { (error, isUserSignedIn, user) in
            if !isUserSignedIn {
                guard let error = error else {return}
                completion(error, false, false)
                return
            }
            guard let signedInUser = user else {return}
            signedInUser.updateEmail(to: email) { (error) in
                if error != nil {
                    completion(error, true, false)
                    return
                }
                db.collection(Strings.userCollection).document(signedInUser.uid).updateData([Strings.userFirstNameField : firstName,
                                                                                             Strings.userLastNameField : lastName,
                                                                                             Strings.userEmailField : email,
                                                                                             Strings.userProfilePicField : profilePicURL]) { (error) in
                    guard let error = error else {
                        completion(nil, true, true)
                        return
                    }
                    completion(error, true, false)
                }
            }
        }
    }
    
    func uploadProfilePic(with image: UIImage,
                          using userID: String,
                          completion: @escaping (Error?, String?) -> Void)
    {
        guard let imageData = image.jpegData(compressionQuality: 0.4) else {return}
        let storagePath = Storage.storage().reference(forURL: Strings.firebaseStoragePath)
        let profilePicStoragePath = storagePath.child(Strings.firebaseProfilePicStoragePath).child(userID)
        let imageMetadata = StorageMetadata()
        imageMetadata.contentType = Strings.metadataContentType
        profilePicStoragePath.putData(imageData, metadata: imageMetadata) { (_, error) in
            if error != nil {
                completion(error, nil)
                return
            }
            profilePicStoragePath.downloadURL { (url, error) in
                guard let error = error else {
                    guard let imageString = url?.absoluteString else {return}
                    completion(nil, imageString)
                    return
                }
                completion(error, nil)
            }
        }
    }
    
    func signOutUser() -> Bool {
        do {
            try auth.signOut()
            return true
        } catch {
            return false
        }
    }
    
}

//MARK: - Sticker Data Related Firebase Functions

extension Service {
    
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
        checkIfUserIsSignedIn { (error, isUserSignedIn, user) in
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
        checkIfUserIsSignedIn { (error, isUserSignedIn, user) in
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
        checkIfUserIsSignedIn { (error, isUserSignedIn, user) in
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
        checkIfUserIsSignedIn { (error, isUserSignedIn, user) in
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
        checkIfUserIsSignedIn { (error, isUserSignedIn, user) in
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
        checkIfUserIsSignedIn { (error, isUserSignedIn, user) in
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
        checkIfUserIsSignedIn { (error, isUserSignedIn, user) in
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
        checkIfUserIsSignedIn { (error, isUserSignedIn, user) in
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
        checkIfUserIsSignedIn { (error, isUserSignedIn, user) in
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

//MARK: - Heart Button Related Firebase Functions

extension Service {
    
    func tapHeartButton(using stickerID: String,
                        completion: @escaping (Error?, Bool) -> Void)
    {
        getSignedInUserData { (error, isUserSignedIn, userData) in
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
        checkIfUserIsSignedIn { (error, isUserSignedIn, user) in
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

//MARK: - Networking

extension Service {
    
    func downloadStickerImage(using stickerURL: String,
                              completion: @escaping (Error?, Data?) -> Void) {
        guard let url = URL(string: stickerURL) else {return}
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: url) { data, _, error in
            guard let error = error else {
                guard let stickerImageData = data else {return}
                completion(nil, stickerImageData)
                return
            }
            completion(error, nil)
        }
        dataTask.resume()
    }
    
}
