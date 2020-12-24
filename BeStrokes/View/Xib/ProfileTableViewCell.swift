//
//  ProfileTableViewCell.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 12/24/20.
//

import UIKit
import Firebase

class ProfileTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var settingLabel: UILabel!
    @IBOutlet weak var settingSwitch: UISwitch!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setData(with value: String) {
        
        
        
        if value == "Logout"  {
            settingLabel.text = value
            settingSwitch.isHidden = true
            
        } else {
            settingLabel.text = value
        }
        
    }
    
    
 
    
}
