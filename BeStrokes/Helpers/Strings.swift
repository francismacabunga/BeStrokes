//
//  Constants.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 11/4/20.
//

import Foundation

struct Strings {
    
    //MARK: - Validation Messages
    
    static let firstNameTextFieldErrorMessage = "First Name is required."
    static let lastNameTextFieldErrorMessage = "Last Name is required."
    static let emailTextFieldErrorMessage = "Email is required."
    static let passwordTextFieldErrorMessage = "Password is required."
    static let profilePictureErrorMessage = "Profile picture is required, please choose an image."
    static let resetPasswordSuccessMessage = "Your password has been successfuly reset. Please check your email."
    static let passwordErrorMessage = "Password must be at least 8 characters long with one alphabet and one special character or more."
    static let invalidCErrorMessage = "Invalid credentials"
    static let invalidUTErrorMessage = "Invalid user token"
    static let invalidCTErrorMessage = "Invalid custom token"
    static let userTEErrorMessage = "User token expired"
    static let userDErrorMessage = "User is disabled"
    static let userNFErrorMessage = "User not found"
    static let customTMErrorMessage = "Custom token mismatch"
    static let callDErrorMessage = "Default error"
    static let alertControllerMessage = "User is automatically signed out."
    static let alertActionMessage = "Dismiss"
    static let emailVerificationSent = "Email verification has ben succesfuly sent. Please check your email"
    
    //MARK: - Storyboard
    
    
    static let loginStoryboardID = "LoginViewController"
    static let landingStoryboardID = "LandingViewController"
    static let landingNavigationStoryboardID = "LandingNavigationController"
    static let tabBarStoryboardID = "UserTabBarController"
    static let homeStoryboardID = "HomeViewController"
    static let profileStoryboardID = "ProfileViewController"
    static let unwindToLandingSegue = "goBackToLanding"
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
   
    
    
    
    
    
    static let emailPlaceholder = "Email"
    static let passwordPlaceholder = "Password"
    static let firstNamePlaceholder = "First Name"
    static let lastNamePlaceholder = "Last Name"
    
    
    static let changeSignUpButtonText = "Logging in..."
    
    
    
    
    static let collectionName = "users"
    static let profilePictureStorageReference = "profilePictures"
    static let firstName = "firstName"
    static let lastName = "lastName"
    static let UID = "userID"
    static let profilePicture = "profilePic"
    
    static let firebaseStorageReference = "gs://bestrokes-f5c28.appspot.com/"
    static let metadataContentType = "image/jpg"
    
    static let defaultProfilePicture = "Woman"
    
    
    
    //MARK: - MVVM
    
    
    
    
    // Heading Text Value
    
    static let featuredHeadingText = "Featured"
    static let stickerHeadingText = "Stickers"
    
    
    
    // Font Names
    
    static let defaultFont = "Futura"
    static let defaultFontBold = "Futura-Bold"
    static let defaultFontMedium = "Futura-Medium"
    
    
    
    // NIB Names
    
    static let featuredStickerCell = "FeaturedCollectionViewCell"
    static let stickerCategoryCell = "StickerCategoryCollectionViewCell"
    static let stickerCell = "StickerCollectionViewCell"
    static let stickerOption = "StickerOptionViewController"
    
    
    // Sticker Kind Names
    
    static let allStickers = "All"
    static let featuredStickers = "Featured"
    
    
    // Image Strings
    
    static let whiteBar = "Black_Bar"
    static let blackBar = "White_Bar"
    static let optionImage = "Dots"
    
    // Storyboard
    
    static let mainStoryboard = "Main"
    static let userStoryboard = "User"
    
    // Button
    
    static let tryMeButton = "Try me"
    static let unheartSticker = "heart"
    static let heartSticker = "heart.fill"
    
    // Sticker
    
    static let noStickerTag = "none"
    
}
