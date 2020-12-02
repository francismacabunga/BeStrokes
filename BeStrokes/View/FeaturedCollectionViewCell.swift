//
//  FeaturedCollectionViewCell.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 12/3/20.
//

import UIKit

class FeaturedCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var sampleLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        containerView.layer.cornerRadius = 30
    }

}
