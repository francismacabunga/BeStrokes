//
//  StickersCategoryCollectionViewCell.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 12/5/20.
//

import UIKit

class StickersCategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var stickersCategoryContentView: UIView!
    @IBOutlet weak var stickersCategoryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        stickersCategoryContentView.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1)
        stickersCategoryContentView.layer.cornerRadius = stickersCategoryContentView.bounds.height / 2
        
        stickersCategoryLabel.text = "Label"
        stickersCategoryLabel.font = UIFont(name: "Futura-Bold", size: 13)
        stickersCategoryLabel.adjustsFontSizeToFitWidth = true
        stickersCategoryLabel.numberOfLines = 1
        stickersCategoryLabel.minimumScaleFactor = 0.9
        stickersCategoryLabel.textAlignment = .center
       
        
        stickersCategoryLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
    }
    
}
