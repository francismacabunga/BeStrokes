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
            
            let settings = profileViewModel.profileSettings
            
            for setting in settings {
                
                let label = setting.settingLabel
                let icon = setting.settingIcon
                
                
                if label == Strings.profileSettingsLogout {
                    settingLabel.text = label
                    settingIconImageView.image = UIImage(systemName: icon)
                    settingSwitch.isHidden = true
                } else {
                    settingLabel.text = label
                    settingIconImageView.image = UIImage(systemName: icon)
                }
                
                
            }
            
            
            
            
            
            //            if profileViewModel.label == Strings.profileSettingsLogout {
            //                settingLabel.text = profileViewModel.label
            //                settingSwitch.isHidden = true
            //            } else {
            //                settingLabel.text = profileViewModel.label
            //            }
            
            
        }
    }
    
    
    //MARK: - NIB Functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setDesignElements()
        
    }
    
    
    //MARK: - Design Elements
    
    func setDesignElements() {
        Utilities.setDesignOn(view: contentView, color: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1))
                Utilities.setDesignOn(imageView: settingIconImageView, tintColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        Utilities.setDesignOn(settingLabel, font: Strings.defaultFont, fontSize: 15, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), textAlignment: .left, numberofLines: 1)
    }
    
    //
    //    func setSampleData(value: ProfileSettingsViewModel) {
    //
    //        let sample = value.profileSettings
    //
    ////        for i in sample {
    ////            settingIconImageView.image = UIImage(systemName: i.iconImage)
    ////            settingLabel.text = i.label
    ////        }
    //
    //    }
    
}
