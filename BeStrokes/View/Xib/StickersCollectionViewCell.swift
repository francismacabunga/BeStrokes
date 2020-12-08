//
//  StickersCollectionViewCell.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 12/5/20.
//

import UIKit

class StickersCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var stickersContentView: UIView!
    @IBOutlet weak var stickersLabel: UILabel!
    @IBOutlet weak var stickersOptionButtonLabel: UIButton!
    @IBOutlet weak var stickersImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        stickersContentView.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1)
        stickersContentView.layer.cornerRadius = 30
        stickersContentView.clipsToBounds = true

        stickersLabel.text = "Lion"
        stickersLabel.textAlignment = .left
        stickersLabel.numberOfLines = 0
        stickersLabel.lineBreakMode = .byWordWrapping
        stickersLabel.font = UIFont(name: "Futura-Bold", size: 15)
        stickersLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        stickersOptionButtonLabel.setTitle("...", for: .normal)
        stickersOptionButtonLabel.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        stickersOptionButtonLabel.titleLabel?.font = UIFont(name: "Futura", size: 30)

        stickersImageView.image = UIImage(named: "Lion")
        stickersImageView.contentMode = .scaleAspectFit
        
    }
    
    @IBAction func stickersOptionButton(_ sender: UIButton) {
        
    }
    
}
