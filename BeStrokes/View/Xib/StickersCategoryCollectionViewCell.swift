//
//  StickersCategoryCollectionViewCell.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 12/5/20.
//

import UIKit

class StickersCategoryCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var stickersCategoryContentView: UIView!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        stickersCategoryContentView.layer.cornerRadius = 15
    
    }

}
