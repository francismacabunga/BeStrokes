//
//  StickerOptionTableViewCell.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 12/22/20.
//

import UIKit

class StickerOptionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var stickerOptionLabel: UILabel!
    @IBOutlet weak var stickerOptionImageView: UIImageView!
    @IBOutlet weak var imageContentView: UIView!
    
    
    
    
    
    var stickerLabelText: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1)
        stickerOptionImageView.image = UIImage(systemName: "heart")
        imageContentView.backgroundColor = .clear
        imageContentView.tintColor = .black
        stickerOptionLabel.font = UIFont(name: "Futura-Bold", size: 15)
        stickerOptionLabel.textColor = .black

    }


    
}
