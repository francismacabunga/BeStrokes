//
//  FeaturedStickerViewModel.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 5/21/21.
//

import Foundation

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
    
    func captureVC(_ featuredStickerViewModel: FeaturedStickerViewModel) -> CaptureViewController {
        let captureVC = Utilities.transition(to: Strings.captureVC, onStoryboard: Strings.userStoryboard, canAccessDestinationProperties: true)! as! CaptureViewController
        captureVC.isStickerPicked = true
        captureVC.featuredStickerViewModel = featuredStickerViewModel
        captureVC.modalPresentationStyle = .fullScreen
        UserDefaults.standard.setValue(false, forKey: Strings.isHomeVCLoadedKey)
        return captureVC
    }
    
}
