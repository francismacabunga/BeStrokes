//
//  StickerModel.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 12/29/20.
//

import Foundation

struct StickerModel {
    let stickerID: String
    let name: String
    let image: String
    let description: String
    let category: String
    let tag: String
}

struct UserStickerModel {
    let stickerID: String
    let name: String
    let image: String
    let description: String
    let category: String
    let tag: String
    let isNew: Bool
    let isOpen: Bool
}

struct StickerCategoryModel {
    let category: String
    var isCategorySelected: Bool
}

