//
//  ProfileTableViewCell.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 12/24/20.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var settingContentView: UIView!
    @IBOutlet weak var settingIconImageView: UIImageView!
    @IBOutlet weak var settingLabel: UILabel!
    @IBOutlet weak var settingSwitch: UISwitch!
    
    
    //MARK: - Constants / Variables
    
    private var isLightAppearanceOn = UserDefaults.standard.bool(forKey: "isLightAppearanceOn")
    var profileSettingsViewModel: ProfileSettingsViewModel! {
        didSet {
            let label = profileSettingsViewModel.profileSettings.first!.settingLabel
            let icon = profileSettingsViewModel.profileSettings.first!.settingIcon
            if label == Strings.profileSettingsLogout {
                settingLabel.text = label
                settingIconImageView.image = UIImage(systemName: icon)
                settingSwitch.isHidden = true
            } else {
                settingLabel.text = label
                settingIconImageView.image = UIImage(systemName: icon)
            }
            
            
            if settingLabel.text == Strings.profileSettingsDarkAppearance {
                if isLightAppearanceOn {
                    settingSwitch.isOn = false
                } else {
                    settingSwitch.isOn = true
                }
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
        Utilities.setDesignOn(view: settingContentView, backgroundColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1))
        Utilities.setDesignOn(imageView: settingIconImageView, tintColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        Utilities.setDesignOn(label: settingLabel, font: Strings.defaultFont, fontSize: 15, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), numberofLines: 1, textAlignment: .left)
    }
    
    
    //MARK: - Switches
    
    @IBAction func profileSwitch(_ sender: UISwitch) {
        
        
        
        

        switch settingLabel.text {
        case Strings.profileSettingsNotifications:
            if sender.isOn {
                print("Notification is turned on!")

            } else {
                print("Notification is turned off!")

            }
        case Strings.profileSettingsDarkAppearance:
            if sender.isOn {
                print("Dark Appearance is turned on!")
                UserDefaults.standard.setValue(false, forKey: "isLightAppearanceOn")
            } else {
                print("Dark Appearance is turned off!")
                UserDefaults.standard.setValue(true, forKey: "isLightAppearanceOn")
            }
        default:
            return
        }

        
        
    }
    
}
