//
//  StickerViewModel.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 12/29/20.
//

import Foundation

struct StickerViewModel {
    
    let stickerID: String
    let name: String
    let image: URL
    let tag: String?
    
    init(sticker: Sticker) {
        self.stickerID = sticker.stickerID
        self.name = sticker.name
        self.image = sticker.image
        self.tag = sticker.tag
    }
    
}
