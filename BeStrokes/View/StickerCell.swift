//
//  StickerCell.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 11/28/20.
//

import UIKit

class StickerCell: UITableViewCell {
    
    
    
    @IBOutlet weak var stickerImageView: UIImageView!
    
    
    @IBOutlet weak var stickerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
}
