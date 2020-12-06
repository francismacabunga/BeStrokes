//
//  StickersCollectionViewCell.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 12/5/20.
//

import UIKit

class StickersCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var stickersCollectionContentView: UIView!
    @IBOutlet weak var stickersLabel: UILabel!
    @IBOutlet weak var stickersOptionButtonLabel: UIButton!
    @IBOutlet weak var stickersImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        stickersCollectionContentView.layer.cornerRadius = 30
        stickersCollectionContentView.clipsToBounds = true
        
        stickersLabel.font = UIFont(name: "Futura-Bold", size: 15)
        stickersLabel.textColor = .black
        
    }
    
    @IBAction func stickersOptionButton(_ sender: UIButton) {
        
    }
    
}
