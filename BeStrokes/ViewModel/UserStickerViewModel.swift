//
//  UserStickerViewModel.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 5/21/21.
//

import Foundation

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
    
    func setUserDefaultsOnTryMeButton() {
        if UserDefaults.standard.bool(forKey: Strings.notificationTabKey) {
            UserDefaults.standard.setValue(false, forKey: Strings.notificationPageKey)
        }
        if UserDefaults.standard.bool(forKey: Strings.accountTabKey) {
            UserDefaults.standard.setValue(false, forKey: Strings.accountPageKey)
        }
    }
    
    func captureVC(_ userStickerViewModel: UserStickerViewModel) -> CaptureViewController {
        let captureVC = Utilities.transition(to: Strings.captureVC, onStoryboard: Strings.userStoryboard, canAccessDestinationProperties: true)! as! CaptureViewController
        captureVC.userStickerViewModel = userStickerViewModel
        captureVC.captureViewModel.stickerIsPicked = true
        captureVC.modalPresentationStyle = .fullScreen
        return captureVC
    }
    
}
