//
//  AccountViewModel.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 5/30/21.
//

import Foundation
import Firebase

struct AccountViewModel {
    
    private let firebase = Firebase()
    private let db = Firestore.firestore()
    private var searchButtonTap = false
    var hasPerformedSearch = false 
    
    mutating func buttonIsTapped() -> Bool {
        searchButtonTap = !searchButtonTap
        return searchButtonTap
    }
    
    func stickerOptionVC(_ userStickerViewModel: [UserStickerViewModel], _ indexPath: IndexPath) -> StickerOptionViewController {
        let stickerOptionVC = Utilities.transition(to: Strings.stickerOptionVC, onStoryboard: Strings.userStoryboard, canAccessDestinationProperties: true) as! StickerOptionViewController
        stickerOptionVC.userStickerViewModel = userStickerViewModel[indexPath.row]
        stickerOptionVC.modalPresentationStyle = .fullScreen
        return stickerOptionVC
    }
    
    
    //MARK: - Sticker Related Functions
    
    func fetchLovedSticker(on stickerID: String? = nil, completion: @escaping (Error?, Bool, Bool?, [UserStickerViewModel]?) -> Void) {
        firebase.checkIfUserIsSignedIn { (error, isUserSignedIn, user) in
            if !isUserSignedIn {
                guard let error = error else {return}
                completion(error, false, nil, nil)
                return
            }
            guard let signedInUser = user else {return}
            if stickerID != nil {
                let firebaseQuery = db.collection(Strings.userCollection).document(signedInUser.uid).collection(Strings.stickerCollection).whereField(Strings.stickerIDField, isEqualTo: stickerID!).whereField(Strings.stickerIsLovedField, isEqualTo: true)
                firebase.fetchUserStickerData(withQuery: firebaseQuery, withListener: true) { (error, userStickerData) in
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
                firebase.fetchUserStickerData(withQuery: firebaseQuery, withListener: true) { (error, userStickerData) in
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
    
    func searchSticker(using searchText: String, completion: @escaping (Error?, Bool, UserStickerViewModel?) -> Void) {
        firebase.checkIfUserIsSignedIn { (error, isUserSignedIn, user) in
            if !isUserSignedIn {
                guard let error = error else {return}
                completion(error, false, nil)
                return
            }
            guard let signedInUser = user else {return}
            let firebaseQuery = db.collection(Strings.userCollection).document(signedInUser.uid).collection(Strings.stickerCollection).whereField(Strings.stickerIsLovedField, isEqualTo: true).whereField(Strings.stickerNameField, isEqualTo: searchText)
            firebase.fetchUserStickerData(withQuery: firebaseQuery, withListener: false) { (error, userStickerData) in
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
    
    
    //MARK: - Cell Data
    
    func stickerCell(_ tableView: UITableView) -> StickerTableViewCell {
        let stickerCell = tableView.dequeueReusableCell(withIdentifier: Strings.stickerTableViewCell) as! StickerTableViewCell
        return stickerCell
    }
    
    func setup(_ stickerCell: StickerTableViewCell,
               _ indexPath: IndexPath,
               _ userStickerViewModel: [UserStickerViewModel],
               _ accountVC: AccountViewController)
    {
        stickerCell.prepareStickerTableViewCell()
        stickerCell.userStickerViewModel = userStickerViewModel[indexPath.row]
        stickerCell.stickerCellDelegate = accountVC
    }
    
}
