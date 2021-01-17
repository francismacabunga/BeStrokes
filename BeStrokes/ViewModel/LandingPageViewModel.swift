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

struct FetchLandingPageData {
    
    func of() -> LandingPageViewModel {
        let landingPageViewModel = LandingPageViewModel(LandingPageModel(
                                                            imageArray: [Strings.lionImage, Strings.shirtImage, Strings.dancingImage],
                                                            headingArray: [Strings.headingOne, Strings.headingTwo, Strings.headingThree],
                                                            subheadingArray: [Strings.subheadingOne, Strings.subheadingTwo, Strings.subheadingThree]))
        return landingPageViewModel
    }
    
}


