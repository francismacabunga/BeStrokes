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
    
    init(_ stickerCategory: StickerCategoryModel) {
        self.category = stickerCategory.category
        self.isCategorySelected = stickerCategory.isCategorySelected
        self.selectedOnStart = stickerCategory.selectedOnStart
    }
    
}

struct FetchCategoryData {
    
    func stickerCategory()->[StickerCategoryViewModel] {
        let stickerCategoryViewModel = [StickerCategoryViewModel(StickerCategoryModel(category: Strings.allStickers, isCategorySelected: nil, selectedOnStart: true)),
                               StickerCategoryViewModel(StickerCategoryModel(category: Strings.animalStickers, isCategorySelected: nil, selectedOnStart: nil)),
                               StickerCategoryViewModel(StickerCategoryModel(category: Strings.foodStickers, isCategorySelected: nil, selectedOnStart: nil)),
                               StickerCategoryViewModel(StickerCategoryModel(category: Strings.objectStickers, isCategorySelected: nil, selectedOnStart: nil)),
                               StickerCategoryViewModel(StickerCategoryModel(category: Strings.coloredStickers, isCategorySelected: nil, selectedOnStart: nil)),
                               StickerCategoryViewModel(StickerCategoryModel(category: Strings.travelStickers, isCategorySelected: nil, selectedOnStart: nil)),]
        return stickerCategoryViewModel
    }
    
}
