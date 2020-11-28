//
//  StickerViewCell.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 11/28/20.
//

import UIKit

class StickerCell: UITableViewCell {
    
    

    @IBOutlet weak var stickerImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
