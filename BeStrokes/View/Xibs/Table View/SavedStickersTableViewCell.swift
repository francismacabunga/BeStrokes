//
//  SavedStickersTableViewCell.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 12/10/20.
//

import UIKit

class SavedStickersTableViewCell: UITableViewCell {

    @IBOutlet weak var stickerView: UIView!
    @IBOutlet weak var stickerHeading: UILabel!
    @IBOutlet weak var stickerOptionButtonLabel: UIButton!
    @IBOutlet weak var stickerTryMeButtonLabel: UIButton!
    @IBOutlet weak var stickerImageView: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        stickerView.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1)
        stickerView.layer.cornerRadius = 30
        
        
        stickerHeading.text = "Elephant"
        stickerHeading.font = UIFont(name: "Futura-Bold", size: 20)
        stickerHeading.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        stickerHeading.numberOfLines = 0
        stickerHeading.textAlignment = .left
        stickerHeading.adjustsFontSizeToFitWidth = true
        stickerHeading.minimumScaleFactor = 0.5
        
        
        stickerOptionButtonLabel.setTitle("...", for: .normal)
        stickerOptionButtonLabel.titleLabel?.font = UIFont(name: "Futura-Bold", size: 20)
        stickerOptionButtonLabel.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        
        
        stickerImageView.image = UIImage(named: "Elephant")
        stickerImageView.contentMode = .scaleAspectFit
        
        
        stickerTryMeButtonLabel.setTitle("Try me", for: .normal)
        stickerTryMeButtonLabel.setTitleColor(#colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), for: .normal)
        stickerTryMeButtonLabel.titleLabel?.font = UIFont(name: "Futura-Bold", size: 14)
        stickerTryMeButtonLabel.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        stickerTryMeButtonLabel.layer.cornerRadius = stickerTryMeButtonLabel.bounds.height / 2
        
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
}
