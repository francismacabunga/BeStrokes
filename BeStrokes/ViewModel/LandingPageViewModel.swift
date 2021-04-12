//
//  LandingPageViewModel.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 1/18/21.
//

import Foundation

struct LandingPageViewModel {
    
    let imageArray: [String]
    let headingArray: [String]
    let subheadingArray: [String]
    
    init(_ array: LandingPageModel) {
        self.imageArray = array.imageArray
        self.headingArray = array.headingArray
        self.subheadingArray = array.subheadingArray
    }
    
}

struct LandingPage {
    
    func fetchData() -> LandingPageViewModel {
        let landingPageViewModel = LandingPageViewModel(LandingPageModel(
                                                            imageArray: [Strings.lionImage, Strings.shirtImage, Strings.dancingImage],
                                                            headingArray: [Strings.landingHeading1Text, Strings.landingHeading2Text, Strings.landingHeading3Text],
                                                            subheadingArray: [Strings.landingSubheading1Text, Strings.landingSubheading2Text, Strings.landingSubheading3Text]))
        return landingPageViewModel
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
    
}
