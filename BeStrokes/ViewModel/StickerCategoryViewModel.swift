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
    
    init(stickerCategory: StickerCategory) {
        self.category = stickerCategory.category
        self.isCategorySelected = stickerCategory.isCategorySelected
    }
    
}

struct FetchStickerCategoryData {
    
    func getCategoryData()->[StickerCategory] {
        let stickerCategory = [StickerCategory(category: "All", isCategorySelected: nil),
                               StickerCategory(category: "Animals", isCategorySelected: nil),
                               StickerCategory(category: "Food", isCategorySelected: nil),
                               StickerCategory(category: "Objects", isCategorySelected: nil),
                               StickerCategory(category: "Colored", isCategorySelected: nil),
                               StickerCategory(category: "Travel", isCategorySelected: nil)]
        return stickerCategory
    }
    
}
