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
            stickerCategoryLabel.text = stickerCategoryViewModel.category
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
    
    func putDesignOnElements() {
        
        stickerCategoryContentView.isHidden = false
        stickerCategoryContentView.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1)
        stickerCategoryContentView.layer.cornerRadius = stickerCategoryContentView.bounds.height / 2
        
        stickerCategoryLabel.font = UIFont(name: "Futura-Bold", size: 13)
        stickerCategoryLabel.adjustsFontSizeToFitWidth = true
        stickerCategoryLabel.numberOfLines = 1
        stickerCategoryLabel.minimumScaleFactor = 0.9
        stickerCategoryLabel.textAlignment = .center
        stickerCategoryLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
    }
    
    func getStickerCategoryStatus(using sticker: StickerCategoryViewModel) {
        guard let isCategorySelected = sticker.isCategorySelected else {return}
        if isCategorySelected {
            stickerCategoryContentView.backgroundColor = .yellow
        } else {
            stickerCategoryContentView.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1)
        }
    }
    
}
