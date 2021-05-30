//
//  StickerCategoryViewModel.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 5/21/21.
//

import Foundation

struct StickerCategoryViewModel {
    
    let category: String
    var isCategorySelected: Bool
    
    init(stickerCategory: StickerCategoryModel) {
        self.category = stickerCategory.category
        self.isCategorySelected = stickerCategory.isCategorySelected
    }
    
}
