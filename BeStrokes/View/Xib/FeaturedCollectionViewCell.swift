//
//  FeaturedCollectionViewCell.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 12/5/20.
//

import UIKit

class FeaturedCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var featuredContentView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        featuredContentView.layer.cornerRadius = 30
        
    }

}
