//
//  StickersCollectionViewCell.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 12/5/20.
//

import UIKit

class StickersCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var stickerContentView: UIView!
    @IBOutlet weak var stickerLabel: UILabel!
    @IBOutlet weak var stickerOptionButtonLabel: UIButton!
    @IBOutlet weak var stickerImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        stickerContentView.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1)
        stickerContentView.layer.cornerRadius = 30
        stickerContentView.clipsToBounds = true

        stickerLabel.text = "Lion"
        stickerLabel.textAlignment = .left
        stickerLabel.numberOfLines = 0
        stickerLabel.lineBreakMode = .byWordWrapping
        stickerLabel.font = UIFont(name: "Futura-Bold", size: 18)
        stickerLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        stickerOptionButtonLabel.setTitle("...", for: .normal)
        stickerOptionButtonLabel.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        stickerOptionButtonLabel.titleLabel?.font = UIFont(name: "Futura-Bold", size: 25)

        stickerImageView.image = UIImage(named: "Lion")
        stickerImageView.contentMode = .scaleAspectFit
        
    }
    
    @IBAction func stickersOptionButton(_ sender: UIButton) {
        
    }
    
}
