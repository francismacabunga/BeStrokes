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
        
        stickersCategoryContentView.layer.cornerRadius = stickersCategoryContentView.bounds.height / 2
        
        stickersCategoryLabel.font = UIFont(name: "Futura-Bold", size: 13)
        stickersCategoryLabel.textColor = .black
    }
    
}
