//
//  StickerCategoryViewModel.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 12/30/20.
//

import Foundation
import UIKit

struct StickerCategoryViewModel {
    
    let category: String
    var isCategorySelected: Bool?
    var selectedOnStart: Bool?
    
    init(stickerCategory: StickerCategory) {
        self.category = stickerCategory.category
        self.isCategorySelected = stickerCategory.isCategorySelected
        self.selectedOnStart = stickerCategory.selectedOnStart
    }
    
}

struct FetchStickerCategoryData {
    
    func getCategoryData()->[StickerCategory] {
        let stickerCategory = [StickerCategory(category: Strings.allStickers, isCategorySelected: nil, selectedOnStart: true),
                               StickerCategory(category: Strings.animalStickers, isCategorySelected: nil),
                               StickerCategory(category: Strings.foodStickers, isCategorySelected: nil),
                               StickerCategory(category: Strings.objectStickers, isCategorySelected: nil),
                               StickerCategory(category: Strings.coloredStickers, isCategorySelected: nil),
                               StickerCategory(category: Strings.travelStickers, isCategorySelected: nil)]
        return stickerCategory
    }
    
}
