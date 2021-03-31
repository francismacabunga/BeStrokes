//
//  ProfileTableViewCell.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 12/24/20.
//

import UIKit
import Foundation

class ProfileTableViewCell: UITableViewCell {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var settingContentView: UIView!
    @IBOutlet weak var settingIconImageView: UIImageView!
    @IBOutlet weak var settingLabel: UILabel!
    @IBOutlet weak var settingSwitch: UISwitch!
    
    
    //MARK: - Constants / Variables
    
    var profileSettingsViewModel: ProfileSettingsViewModel! {
        didSet {
            let label = profileSettingsViewModel.profileSettings.first!.settingLabel
            let icon = profileSettingsViewModel.profileSettings.first!.settingIcon
            setSettingData(using: label, and: icon)
            setNotificationSetting()
            setThemeSetting()
        }
    }
    
    
    //MARK: - NIB Functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setDesignElements()
        
    }
    
    
    //MARK: - Design Elements
    
    func setDesignElements() {
        Utilities.setDesignOn(cell: self, selectionStyle: .none)
        Utilities.setDesignOn(view: settingContentView, backgroundColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1))
        Utilities.setDesignOn(imageView: settingIconImageView, tintColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        Utilities.setDesignOn(label: settingLabel, fontName: Strings.defaultFont, fontSize: 15, numberofLines: 1, textAlignment: .left, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
    }
    
    func setSettingData(using label: String, and icon: String) {
        if label == Strings.profileSettingsLogout {
            settingLabel.text = label
            settingIconImageView.image = UIImage(systemName: icon)
            settingSwitch.isHidden = true
        } else {
            settingLabel.text = label
            settingIconImageView.image = UIImage(systemName: icon)
        }
    }
    
    func setNotificationSetting() {
        if settingLabel.text == Strings.profileSettingsNotifications {
            self.isUserInteractionEnabled = false
            settingSwitch.alpha = 0.5
            if UserDefaults.standard.bool(forKey: Strings.notificationKey) {
                settingSwitch.isOn = true
            } else {
                settingSwitch.isOn = false
            }
        }
    }
    
    func setThemeSetting() {
        if settingLabel.text == Strings.profileSettingsDarkAppearance {
            if UserDefaults.standard.bool(forKey: Strings.lightModeKey) {
                settingSwitch.isOn = false
            } else {
                settingSwitch.isOn = true
            }
        }
    }
    
    
    //MARK: - Switches
    
    @IBAction func profileSwitch(_ sender: UISwitch) {
        switch settingLabel.text {
        case Strings.profileSettingsDarkAppearance:
            if sender.isOn {
                UserDefaults.standard.setValue(false, forKey: Strings.lightModeKey)
                NotificationCenter.default.post(name: Utilities.setDarkModeAppearance, object: nil)
            } else {
                UserDefaults.standard.setValue(true, forKey: Strings.lightModeKey)
                NotificationCenter.default.post(name: Utilities.setLightModeAppearance, object: nil)
            }
        default:
            return
        }
    }
    
}
