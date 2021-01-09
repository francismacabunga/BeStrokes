//
//  ProfileViewModel.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 1/8/21.
//

import Foundation

struct ProfileSettingsViewModel {
    
    let profileSettings: [SettingsData]
    
    init(_ settings: ProfileSettingsModel) {
        self.profileSettings = settings.profileSettings
    }
    
}

struct FetchProfileData {
    
    func settings()->[ProfileSettingsViewModel]  {
        let profileSettingsViewModel = [
            ProfileSettingsViewModel(ProfileSettingsModel(profileSettings: [SettingsData(settingIcon: Strings.notificationIcon, settingLabel: Strings.profileSettingsNotifications)])),
            ProfileSettingsViewModel(ProfileSettingsModel(profileSettings: [SettingsData(settingIcon: Strings.darkModeIcon, settingLabel: Strings.profileSettingsDarkAppearance)])),
            ProfileSettingsViewModel(ProfileSettingsModel(profileSettings: [SettingsData(settingIcon: Strings.logoutIcon, settingLabel: Strings.profileSettingsLogout)]))]
        return profileSettingsViewModel
    }
    
}



