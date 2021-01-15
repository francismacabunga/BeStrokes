//
//  ProfileTableViewCell.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 12/24/20.
//

import UIKit
import Firebase

class ProfileTableViewCell: UITableViewCell {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var settingIconImageView: UIImageView!
    @IBOutlet weak var settingLabel: UILabel!
    @IBOutlet weak var settingSwitch: UISwitch!
    
    
    //MARK: - Constants / Variables
    
    var profileViewModel: ProfileSettingsViewModel! {
        didSet {
            
            let label = profileViewModel.profileSettings.first!.settingLabel
            let icon = profileViewModel.profileSettings.first!.settingIcon
            
            if label == Strings.profileSettingsLogout {
                settingLabel.text = label
                settingIconImageView.image = UIImage(systemName: icon)
                settingSwitch.isHidden = true
            } else {
                settingLabel.text = label
                settingIconImageView.image = UIImage(systemName: icon)
            }
            
        }
    }
    
    
    //MARK: - NIB Functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setDesignElements()
        
    }
    
    
    //MARK: - Design Elements
    
    func setDesignElements() {
        self.selectionStyle = .none
        Utilities.setDesignOn(view: contentView, backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        Utilities.setDesignOn(imageView: settingIconImageView, tintColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1))
        Utilities.setDesignOn(label: settingLabel, font: Strings.defaultFont, fontSize: 15, fontColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), numberofLines: 1, textAlignment: .left)
    }
    
}
