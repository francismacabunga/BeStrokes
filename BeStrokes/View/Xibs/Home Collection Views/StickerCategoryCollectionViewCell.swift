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
    @IBOutlet weak var stickerCategoryLabel: UILabel!
    
    
    //MARK: - Constants / Variables
    
    var stickerCategoryViewModel: StickerCategoryViewModel! {
        didSet {
            let isCatagorySelected = stickerCategoryViewModel.isCategorySelected
            stickerCategoryLabel.text = stickerCategoryViewModel.category
            
            if isCatagorySelected != nil {
                if isCatagorySelected! {
                    Utilities.setDesignOn(view: stickerCategoryContentView, color: #colorLiteral(red: 0.9538965821, green: 0.9584284425, blue: 0, alpha: 1))
                } else {
                    Utilities.setDesignOn(view: stickerCategoryContentView, color: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1))
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
        
        stickerCategoryContentView.isHidden = true
        
    }
    
    
    //MARK: - Design Elements
    
    func setDesignOnElements() {
        
        stickerCategoryContentView.isHidden = false
        Utilities.setDesignOn(view: stickerCategoryContentView, color: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), isCircular: true)
        Utilities.setDesignOn(stickerCategoryLabel, font: Strings.defaultFontBold, fontSize: 13, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), textAlignment: .center, numberofLines: 1, canResize: true, minimumScaleFactor: 0.9)
        
    }
    
}
