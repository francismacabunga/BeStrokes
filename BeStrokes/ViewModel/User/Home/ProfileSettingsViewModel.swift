//
//  ProfileSettingsViewModel.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 1/8/21.
//

import Foundation
import Firebase

struct ProfileSettingsViewModel {
    
    private let auth = Auth.auth()
    var model: [ProfileSettingsModel]?
    var data: [ProfileSettingsViewModel] {
        let profileSettingsViewModel = [ProfileSettingsViewModel(model: [ProfileSettingsModel(settingIcon: Strings.settingNotificationIcon, settingLabel: Strings.profileSettingsNotifications)]),
                                        ProfileSettingsViewModel(model: [ProfileSettingsModel(settingIcon: Strings.settingDarkModeIcon, settingLabel: Strings.profileSettingsDarkAppearance)]),
                                        ProfileSettingsViewModel(model: [ProfileSettingsModel(settingIcon: Strings.settingLogoutIcon, settingLabel: Strings.profileSettingsLogout)])]
        return profileSettingsViewModel
    }
    
    func signOutUser() -> Bool {
        do {
            try auth.signOut()
            return true
        } catch {
            return false
        }
    }
    
    func setupProfileCell(_ tableView: UITableView,
                          _ indexPath: IndexPath,
                          _ profileSettingsViewModel: [ProfileSettingsViewModel]) -> ProfileTableViewCell
    {
        let profileCell = tableView.dequeueReusableCell(withIdentifier: Strings.profileCell) as! ProfileTableViewCell
        profileCell.profileSettingsViewModel = profileSettingsViewModel[indexPath.row]
        return profileCell
    }
    
    func setUserDefaultsValueOnDidAppear() {
        UserDefaults.standard.setValue(true, forKey: Strings.profilePageKey)
        UserDefaults.standard.setValue(false, forKey: Strings.homePageKey)
    }
    
    func setUserDefaultsValueWillDisappear() {
        UserDefaults.standard.setValue(false, forKey: Strings.profilePageKey)
        UserDefaults.standard.setValue(true, forKey: Strings.homePageKey)
    }
    
    func setNotificationForDarkMode() {
        UserDefaults.standard.setValue(false, forKey: Strings.lightModeKey)
        NotificationCenter.default.post(name: Utilities.setDarkModeAppearance, object: nil)
    }
    
    func setNotificationForLightMode() {
        UserDefaults.standard.setValue(true, forKey: Strings.lightModeKey)
        NotificationCenter.default.post(name: Utilities.setLightModeAppearance, object: nil)
    }
    
}
