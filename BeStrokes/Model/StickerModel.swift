//
//  Sticker.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 12/29/20.
//

import Foundation

struct StickerModel {
    let stickerDocumentID: String
    let name: String
    let image: URL
    let description: String
    let category: String
    let tag: String
}

struct StickerCategoryModel {
    let category: String
    var isCategorySelected: Bool?
    var selectedOnStart: Bool?
}
