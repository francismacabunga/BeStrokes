//
//  HomeViewModel.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 5/27/21.
//

import Foundation
import Firebase
import UserNotifications
import MSPeekCollectionViewDelegateImplementation

class HomeViewModel {
    
    private let firebase = Firebase()
    private let db = Firestore.firestore()
    private let notificationCenter = UNUserNotificationCenter.current()
    private var selectedIndexPath: IndexPath?
    var shouldReloadCategoryCollectionView = false
    
    
    //MARK: - Design Related Functions
    
    func setViewPeekingBehavior(using behavior: MSCollectionViewPeekingBehavior, on tableView: UICollectionView) {
        tableView.configureForPeekingBehavior(behavior: behavior)
        behavior.cellPeekWidth = 15
        behavior.cellSpacing = 5
    }
    
    func setInitialSelectedCell(on collectionView: UICollectionView) {
        let initialSelectedIndexPath = IndexPath(item: 0, section: 0)
        collectionView.selectItem(at: initialSelectedIndexPath, animated: false, scrollPosition: .centeredHorizontally)
        shouldReloadCategoryCollectionView = true
    }
    
    func reload(_ collectionView: UICollectionView) {
        collectionView.reloadData()
        collectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: .centeredHorizontally)
    }
    
    func profileVC() -> ProfileViewController {
        let profileVC = Utilities.transition(to: Strings.profileVC, onStoryboard: Strings.userStoryboard, canAccessDestinationProperties: true) as! ProfileViewController
        profileVC.modalPresentationStyle = .popover
        return profileVC
    }
    
    func stickerOptionVC(_ stickerViewModel: [StickerViewModel], _ indexPath: IndexPath) -> StickerOptionViewController {
        let stickerOptionVC = Utilities.transition(to: Strings.stickerOptionVC, onStoryboard: Strings.userStoryboard, canAccessDestinationProperties: true) as! StickerOptionViewController
        stickerOptionVC.stickerViewModel = stickerViewModel[indexPath.item]
        stickerOptionVC.modalPresentationStyle = .fullScreen
        UserDefaults.standard.setValue(false, forKey: Strings.isHomeVCLoadedKey)
        return stickerOptionVC
    }
    
    
    //MARK: - Sticker Related Functions
    
    func stickerCategory() -> [StickerCategoryViewModel] {
        let stickerCategoryViewModel = [StickerCategoryViewModel(stickerCategory: StickerCategoryModel(category: Strings.allStickers, isCategorySelected: true)),
                                        StickerCategoryViewModel(stickerCategory: StickerCategoryModel(category: Strings.animalStickers, isCategorySelected: false)),
                                        StickerCategoryViewModel(stickerCategory: StickerCategoryModel(category: Strings.foodStickers, isCategorySelected: false)),
                                        StickerCategoryViewModel(stickerCategory: StickerCategoryModel(category: Strings.objectStickers, isCategorySelected: false)),
                                        StickerCategoryViewModel(stickerCategory: StickerCategoryModel(category: Strings.coloredStickers, isCategorySelected: false)),
                                        StickerCategoryViewModel(stickerCategory: StickerCategoryModel(category: Strings.travelStickers, isCategorySelected: false))]
        return stickerCategoryViewModel
    }
    
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
    
    func fetchSticker(onCategory category: String, completion: @escaping (Error?, [StickerViewModel]?) -> Void) {
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
    
    func fetchRecentlyUploadedSticker(completion: @escaping (Error?, Bool, UserStickerViewModel?) -> Void) {
        firebase.checkIfUserIsSignedIn { [weak self] (error, isUserSignedIn, user) in
            guard let self = self else {return}
            if !isUserSignedIn {
                guard let error = error else {return}
                completion(error, false, nil)
                return
            }
            guard let signedInUser = user else {return}
            let firebaseQuery = self.db.collection(Strings.userCollection).document(signedInUser.uid).collection(Strings.stickerCollection).whereField(Strings.stickerIsRecentlyUploadedField, isEqualTo: true)
            self.firebase.fetchUserStickerData(withQuery: firebaseQuery, withListener: true) { (error, userStickerData) in
                guard let error = error else {
                    guard let userStickerViewModel = userStickerData?.first else {return}
                    completion(nil, true, userStickerViewModel)
                    return
                }
                completion(error, true, nil)
            }
        }
    }
    
    func checkIfStickerExistsInUserCollection(stickerViewModel: [StickerViewModel], completion: @escaping (Error?, Bool, Bool?, StickerViewModel?) -> Void) {
        firebase.checkIfUserIsSignedIn { [weak self] (error, isUserSignedIn, user) in
            guard let self = self else {return}
            if !isUserSignedIn {
                guard let error = error else {return}
                completion(error, false, nil, nil)
                return
            }
            guard let signedInUser = user else {return}
            _ = stickerViewModel.map({
                let newSticker = $0
                let firebaseQuery = self.db.collection(Strings.userCollection).document(signedInUser.uid).collection(Strings.stickerCollection).whereField(Strings.stickerIDField, isEqualTo: $0.stickerID)
                self.firebase.fetchUserStickerData(withQuery: firebaseQuery, withListener: false) { (error, userStickerData) in
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
        firebase.checkIfUserIsSignedIn { [weak self] (error, isUserSignedIn, user) in
            guard let self = self else {return}
            if !isUserSignedIn {
                guard let error = error else {return}
                completion(error, false)
                return
            }
            guard let signedInUser = user else {return}
            let firebaseQuery1 = self.db.collection(Strings.userCollection).document(signedInUser.uid).collection(Strings.stickerCollection)
            self.firebase.fetchUserStickerData(withQuery: firebaseQuery1, withListener: false) { (error, userStickerData) in
                if error != nil {
                    completion(error, true)
                    return
                }
                guard let userStickerData = userStickerData else {return}
                _ = userStickerData.map({
                    let missingStickerID = $0.stickerID
                    let firebaseQuery2 = self.db.collection(Strings.stickerCollection).whereField(Strings.stickerIDField, isEqualTo: $0.stickerID)
                    self.fetchStickerData(withQuery: firebaseQuery2, withListener: false) { (error, stickerData) in
                        if error != nil {
                            completion(error, true)
                            return
                        }
                        guard let _ = stickerData?.first else {
                            self.db.collection(Strings.userCollection).document(signedInUser.uid).collection(Strings.stickerCollection).document(missingStickerID).delete { (error) in
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
        firebase.checkIfUserIsSignedIn { [weak self] (error, isUserSignedIn, user) in
            guard let self = self else {return}
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
                self.db.collection(Strings.userCollection).document(signedInUser.uid).collection(Strings.stickerCollection).document($0.stickerID).setData(userStickerViewModelDictionary) { (error) in
                    guard let error = error else {return}
                    completion(error, true)
                }
            })
        }
    }
    
    func updateRecentlyUploadedSticker(on stickerID: String, completion: @escaping (Error?, Bool) -> Void) {
        firebase.checkIfUserIsSignedIn { [weak self] (error, isUserSignedIn, user) in
            guard let self = self else {return}
            if !isUserSignedIn {
                guard let error = error else {return}
                completion(error, false)
                return
            }
            guard let signedInUser = user else {return}
            self.db.collection(Strings.userCollection).document(signedInUser.uid).collection(Strings.stickerCollection).document(stickerID).updateData([Strings.stickerIsRecentlyUploadedField : false]) { (error) in
                guard let error = error else {return}
                completion(error, true)
            }
        }
    }
    
    
    //MARK: - Cell Data
    
    func featuredStickerCell(_ collectionView: UICollectionView, _ indexPath: IndexPath) -> FeaturedStickerCollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Strings.featuredStickerCell, for: indexPath) as! FeaturedStickerCollectionViewCell
        return cell
    }
    
    func stickerCategoryCell(_ collectionView: UICollectionView, _ indexPath: IndexPath) -> StickerCategoryCollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Strings.stickerCategoryCell, for: indexPath) as! StickerCategoryCollectionViewCell
        return cell
    }
    
    func stickerCell(_ collectionView: UICollectionView, _ indexPath: IndexPath) -> StickerCollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Strings.stickerCollectionViewCell, for: indexPath) as! StickerCollectionViewCell
        return cell
    }
    
    func setup(_ featuredStickerCell: FeaturedStickerCollectionViewCell,
               _ indexPath: IndexPath,
               _ featuredStickerViewModel: [FeaturedStickerViewModel],
               _ homeVC: HomeViewController)
    {
        let featuredStickerCell = featuredStickerCell
        featuredStickerCell.prepareFeaturedStickerCell()
        featuredStickerCell.featuredStickerViewModel = featuredStickerViewModel[indexPath.item]
        featuredStickerCell.featuredStickerCellDelegate = homeVC
    }
    
    func setupStickerCategoryCell(_ collectionView: UICollectionView,
                                  _ indexPath: IndexPath,
                                  _ stickerCategoryViewModel: [StickerCategoryViewModel]) -> StickerCategoryCollectionViewCell
    {
        let stickerCategoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: Strings.stickerCategoryCell, for: indexPath) as! StickerCategoryCollectionViewCell
        stickerCategoryCell.stickerCategoryViewModel = stickerCategoryViewModel[indexPath.item]
        stickerCategoryCell.setDesignElements()
        return stickerCategoryCell
    }
    
    func setup(_ stickerCell: StickerCollectionViewCell,
               _ indexPath: IndexPath,
               _ stickerViewModel: [StickerViewModel])
    {
        let stickerCell = stickerCell
        stickerCell.prepareStickerCell()
        stickerCell.stickerViewModel = stickerViewModel[indexPath.item]
    }
    
    
    //MARK: - Collection View Delegate Functions
    
    func selectStickerCategory(_ collectionView: UICollectionView,
                               _ indexPath: IndexPath,
                               _ stickerCategoryViewModel: inout [StickerCategoryViewModel]) -> String?
    {
        let selectedStickerCategory: String
        selectedIndexPath = indexPath
        stickerCategoryViewModel[indexPath.item].isCategorySelected = true
        selectedStickerCategory = stickerCategoryViewModel[indexPath.item].category
        guard let stickerCategoryCell = collectionView.cellForItem(at: indexPath) as? StickerCategoryCollectionViewCell else {return nil}
        stickerCategoryCell.stickerCategoryViewModel = stickerCategoryViewModel[indexPath.item]
        return selectedStickerCategory
    }
    
    func deselectStickerCategory(_ collectionView: UICollectionView,
                                 _ indexPath: IndexPath,
                                 _ stickerCategoryViewModel: inout [StickerCategoryViewModel])
    {
        stickerCategoryViewModel[indexPath.item].isCategorySelected = false
        guard let cell = collectionView.cellForItem(at: indexPath) as? StickerCategoryCollectionViewCell else {
            DispatchQueue.main.async { [self] in
                collectionView.reloadData()
                collectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: .centeredHorizontally)
            }
            return
        }
        cell.stickerCategoryViewModel = stickerCategoryViewModel[indexPath.item]
    }
    
    
    //MARK: - Notification Functions
    
    func checkIfNotificationIsPermitted(completion: @escaping (Error) -> Void) {
        Utilities.checkIfNotificationIsPermitted { [weak self] (permission) in
            guard let self = self else {return}
            if !permission {
                let options: UNAuthorizationOptions = [.alert, .sound]
                self.notificationCenter.requestAuthorization(options: options) { (isPermissionGranted, error) in
                    guard let error = error else {
                        if isPermissionGranted {
                            UserDefaults.standard.setValue(true, forKey: Strings.notificationKey)
                        } else {
                            UserDefaults.standard.setValue(false, forKey: Strings.notificationKey)
                        }
                        return
                    }
                    completion(error)
                }
            }
        }
    }
    
    func notificationRequest() -> UNNotificationRequest {
        let notificationIdentifier = Strings.notificationIdentifier
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = Strings.notificationTitle
        notificationContent.body = Strings.notificationBody
        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let notificationRequest = UNNotificationRequest(identifier: notificationIdentifier, content: notificationContent, trigger: notificationTrigger)
        return notificationRequest
    }
    
}
