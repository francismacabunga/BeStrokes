//
//  ProfileSettingsViewModel.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 1/8/21.
//

import Foundation

struct ProfileSettingsViewModel {
    
    var model: [ProfileSettingsModel]?
    var data: [ProfileSettingsViewModel] {
        let profileSettingsViewModel = [ProfileSettingsViewModel(model: [ProfileSettingsModel(settingIcon: Strings.settingNotificationIcon, settingLabel: Strings.profileSettingsNotifications)]),
                                        ProfileSettingsViewModel(model: [ProfileSettingsModel(settingIcon: Strings.settingDarkModeIcon, settingLabel: Strings.profileSettingsDarkAppearance)]),
                                        ProfileSettingsViewModel(model: [ProfileSettingsModel(settingIcon: Strings.settingLogoutIcon, settingLabel: Strings.profileSettingsLogout)])]
        return profileSettingsViewModel
    }
    
}
