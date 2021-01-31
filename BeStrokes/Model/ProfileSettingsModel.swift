//
//  ProfileSettingsModel.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 1/8/21.
//

import Foundation

struct ProfileSettingsModel {
    let profileSettings: [SettingsData]
}

struct SettingsData {
    let settingIcon: String
    let settingLabel: String
}
