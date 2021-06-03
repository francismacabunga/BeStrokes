//
//  TabBarViewModel.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 6/3/21.
//

import Foundation

struct TabBarViewModel {
    
    func setBadgeCounterValue() -> String? {
        if UserDefaults.standard.bool(forKey: Strings.notificationKey) {
            if UserDefaults.standard.integer(forKey: Strings.notificationBadgeCounterKey) > 0 {
                let counter = "\(UserDefaults.standard.integer(forKey: Strings.notificationBadgeCounterKey))"
                return counter
            } else {
                return nil
            }
        } else {
           return nil
        }
    }
    
    func setTrueValueOnHomeUserDefaultsKey() {
        UserDefaults.standard.setValue(true, forKey: Strings.homeTabKey)
        UserDefaults.standard.setValue(true, forKey: Strings.homePageKey)
        UserDefaults.standard.setValue(false, forKey: Strings.captureTabKey)
        UserDefaults.standard.setValue(false, forKey: Strings.notificationTabKey)
        UserDefaults.standard.setValue(false, forKey: Strings.accountTabKey)
        UserDefaults.standard.setValue(false, forKey: Strings.capturePageKey)
        UserDefaults.standard.setValue(false, forKey: Strings.notificationPageKey)
        UserDefaults.standard.setValue(false, forKey: Strings.accountPageKey)
    }
    
    func setTrueValueOnCaptureUserDefaultsKey() {
        UserDefaults.standard.setValue(true, forKey: Strings.captureTabKey)
        UserDefaults.standard.setValue(true, forKey: Strings.capturePageKey)
        UserDefaults.standard.setValue(false, forKey: Strings.homeTabKey)
        UserDefaults.standard.setValue(false, forKey: Strings.notificationTabKey)
        UserDefaults.standard.setValue(false, forKey: Strings.accountTabKey)
        UserDefaults.standard.setValue(false, forKey: Strings.homePageKey)
        UserDefaults.standard.setValue(false, forKey: Strings.notificationPageKey)
        UserDefaults.standard.setValue(false, forKey: Strings.accountPageKey)
    }
        
    func setTrueValueOnNotificationUserDefaultsKey() {
        UserDefaults.standard.setValue(true, forKey: Strings.notificationTabKey)
        UserDefaults.standard.setValue(true, forKey: Strings.notificationPageKey)
        UserDefaults.standard.setValue(false, forKey: Strings.homeTabKey)
        UserDefaults.standard.setValue(false, forKey: Strings.captureTabKey)
        UserDefaults.standard.setValue(false, forKey: Strings.accountTabKey)
        UserDefaults.standard.setValue(false, forKey: Strings.homePageKey)
        UserDefaults.standard.setValue(false, forKey: Strings.capturePageKey)
        UserDefaults.standard.setValue(false, forKey: Strings.accountPageKey)
    }
    
    func setTrueValueOnAccountUserDefaultsKey() {
        UserDefaults.standard.setValue(true, forKey: Strings.accountTabKey)
        UserDefaults.standard.setValue(true, forKey: Strings.accountPageKey)
        UserDefaults.standard.setValue(false, forKey: Strings.homeTabKey)
        UserDefaults.standard.setValue(false, forKey: Strings.captureTabKey)
        UserDefaults.standard.setValue(false, forKey: Strings.notificationTabKey)
        UserDefaults.standard.setValue(false, forKey: Strings.homePageKey)
        UserDefaults.standard.setValue(false, forKey: Strings.capturePageKey)
        UserDefaults.standard.setValue(false, forKey: Strings.notificationPageKey)
    }

}
