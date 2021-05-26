//
//  LandingPageViewModel.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 1/18/21.
//

import Foundation

struct LandingPageViewModel {
    
    var imageArray: [String]?
    var headingArray: [String]?
    var subheadingArray: [String]?
    var data: LandingPageViewModel {
        let landingPageViewModel = LandingPageViewModel(imageArray: [Strings.lionImage, Strings.shirtImage, Strings.dancingImage],
                                                        headingArray: [Strings.landingHeading1Text, Strings.landingHeading2Text, Strings.landingHeading3Text],
                                                        subheadingArray: [Strings.landingSubheading1Text, Strings.landingSubheading2Text, Strings.landingSubheading3Text])
        return landingPageViewModel
    }
    
    func landingPageContentVC(at index: Int) -> LandingPageContentViewController? {
        let indexIsValid = checkIfIndexIsValid(index: index, imagesCount: data.imageArray!.count)
        if !indexIsValid {
            return nil
        }
        let landingPageContentVC = Utilities.transition(to: Strings.landingPageContentVC, onStoryboard: Strings.guestStoryboard, canAccessDestinationProperties: true) as! LandingPageContentViewController
        landingPageContentVC.imageFileName = data.imageArray![index]
        landingPageContentVC.headingLabelText = data.headingArray![index]
        landingPageContentVC.subheadingText = data.subheadingArray![index]
        landingPageContentVC.index = index
        return landingPageContentVC
    }
    
    func transitionToCaptureVC() -> CaptureViewController {
        let captureVC = Utilities.transition(to: Strings.captureVC, onStoryboard: Strings.userStoryboard, canAccessDestinationProperties: true) as! CaptureViewController
        captureVC.isPresentedFromLandingVC = true
        captureVC.modalPresentationStyle = .fullScreen
        return captureVC
    }
    
    func checkIfIndexIsValid(index: Int, imagesCount: Int) -> Bool {
        if index >= imagesCount || index < 0 {
            return false
        }
        return true
    }
    
    func plusOneTo(_ index: Int) -> Int {
        var newIndex = index
        newIndex += 1
        return newIndex
    }
    
    func minusOneTo(_ index: Int) -> Int {
        var newIndex = index
        newIndex -= 1
        return newIndex
    }
    
    func resetTabKeysValues() {
        UserDefaults.standard.setValue(false, forKey: Strings.homeVCTappedKey)
        UserDefaults.standard.setValue(false, forKey: Strings.isHomeVCLoadedKey)
        UserDefaults.standard.setValue(false, forKey: Strings.captureVCTappedKey)
        UserDefaults.standard.setValue(false, forKey: Strings.notificationVCTappedKey)
        UserDefaults.standard.setValue(false, forKey: Strings.accountVCTappedKey)
        UserDefaults.standard.setValue(false, forKey: Strings.isCaptureVCLoadedKey)
        UserDefaults.standard.setValue(false, forKey: Strings.isNotificationVCLoadedKey)
        UserDefaults.standard.setValue(false, forKey: Strings.isAccountVCLoadedKey)
    }
    
}
