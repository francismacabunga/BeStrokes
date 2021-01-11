//
//  StickersCategoryCollectionViewCell.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 12/5/20.
//

import UIKit

class StickerCategoryCollectionViewCell: UICollectionViewCell {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var stickerCategoryContentView: UIView!
    @IBOutlet weak var stickerCategoryLabelText: UILabel!
    
    
    //MARK: - Constants / Variables
    
    var stickerCategoryViewModel: StickerCategoryViewModel! {
        didSet {
            let isCategorySelected = stickerCategoryViewModel.isCategorySelected
            let selectedOnStart = stickerCategoryViewModel.selectedOnStart
            stickerCategoryLabelText.text = stickerCategoryViewModel.category
            if selectedOnStart != nil {
                if selectedOnStart! {
                    Utilities.setDesignOn(view: stickerCategoryContentView, backgroundColor: #colorLiteral(red: 0.9944363236, green: 0.9993038774, blue: 0, alpha: 1))
                } else {
                    Utilities.setDesignOn(view: stickerCategoryContentView, backgroundColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1))
                }
            }
            if isCategorySelected != nil {
                if isCategorySelected! {
                    Utilities.setDesignOn(view: stickerCategoryContentView, backgroundColor: #colorLiteral(red: 0.9944363236, green: 0.9993038774, blue: 0, alpha: 1))
                } else {
                    Utilities.setDesignOn(view: stickerCategoryContentView, backgroundColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1))
                }
            }
        }
    }
    
    
    //MARK: - NIB Functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        Utilities.setDesignOn(view: stickerCategoryContentView, backgroundColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1))
        
    }
    
    
    //MARK: - Design Elements
    
    func setDesignElements() {
        Utilities.setDesignOn(view: stickerCategoryContentView, isPerfectCircle: true)
        Utilities.setDesignOn(label: stickerCategoryLabelText, font: Strings.defaultFontBold, fontSize: 13, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), numberofLines: 1, textAlignment: .center, canResize: true, minimumScaleFactor: 0.9)
    }
    
}
