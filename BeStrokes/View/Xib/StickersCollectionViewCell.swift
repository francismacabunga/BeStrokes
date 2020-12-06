//
//  StickersCollectionViewCell.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 12/5/20.
//

import UIKit

class StickersCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var stickersCollectionContentView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        stickersCollectionContentView.layer.cornerRadius = stickersCollectionContentView.bounds.width / 2
        
    }
    
}
