//
//  ProfileViewModel.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 1/8/21.
//

import Foundation

struct ProfileSettingsViewModel {
    
    let profileSettings: [String]
    
    init(_ settings: ProfileSettingsModel) {
        self.profileSettings = settings.profileSettings
    }
    
}

struct FetchProfileData {
    
    func settings() -> ProfileSettingsViewModel {
        let profileSettingsViewModel = ProfileSettingsViewModel(ProfileSettingsModel(profileSettings: [Strings.profileSettingsNotifications, Strings.profileSettingsDarkAppearance, Strings.profileSettingsLogout]))
        return profileSettingsViewModel
    }
    
}



