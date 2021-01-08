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
            ProfileSettingsViewModel(ProfileSettingsModel(profileSettings: [SettingsData(settingIcon: "flag.fill", settingLabel: Strings.profileSettingsNotifications)])),
            ProfileSettingsViewModel(ProfileSettingsModel(profileSettings: [SettingsData(settingIcon: "text.magnifyingglass", settingLabel: Strings.profileSettingsDarkAppearance)])),
            ProfileSettingsViewModel(ProfileSettingsModel(profileSettings: [SettingsData(settingIcon: "flag.slash.circle", settingLabel: Strings.profileSettingsLogout)]))]
        return profileSettingsViewModel
    }
    
}



