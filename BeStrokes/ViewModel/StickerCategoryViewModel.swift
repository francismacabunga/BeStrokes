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
    var sampleString: String!
    
    init(stickerCategory: StickerCategory) {
        self.category = stickerCategory.category
        self.isCategorySelected = stickerCategory.isCategorySelected
    }
    
}

