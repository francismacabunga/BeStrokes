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
    
    
    static let defaultProfilePicture = "Woman"
    
    
    
    //MARK: - MVVM
    
    
    
    
    // Heading Text
    static let homeFeaturedHeadingText = "Featured"
    static let homeStickerHeadingText = "Stickers"
    static let profileSettingsHeadingText = "Settings"
    static let profileTrademark1Text = "BeStrokes"
    static let profileTrademark2Text = "made by Francis"
    static let accountHeadingText = "Account"
    static let accountLikedStickersHeadingText = "Liked Stickers"
    
    
    
    
    
    
    
    // Font Names
    static let defaultFont = "Futura"
    static let defaultFontBold = "Futura-Bold"
    static let defaultFontMedium = "Futura-Medium"
    
    
    
    // NIB Names
    static let featuredStickerCell = "FeaturedCollectionViewCell"
    static let stickerCategoryCell = "StickerCategoryCollectionViewCell"
    static let profileTableViewCell = "ProfileTableViewCell"
    static let stickerCell = "StickerCollectionViewCell"
    static let likedStickerCell = "LikedStickersTableViewCell"
    
    
    // View Controllers
    static let landingVC = "LandingViewController"
    static let stickerOptionVC = "StickerOptionViewController"
    static let editAccountVC = "EditAccountViewController"
    static let editAccountContainerVC = "EditAccountContainerViewController"
    
    
    
    
    // Image Names
    static let whiteBar = "Black_Bar"
    static let blackBar = "White_Bar"
    static let optionImage = "Dots"
    static let unheartSticker = "heart"
    static let heartSticker = "heart.fill"
    
    
    // Storyboard Names
    static let mainStoryboard = "Main"
    static let userStoryboard = "User"
    
    
    
    // Button Label
    static let tryMeButton = "Try me"
    
    
    
    
    // Firebase Collections and Fields
    static let userCollection = "users"
    static let stickerCollection = "stickers"
    static let heartByCollection = "heartBy"
    
    static let userDocumentIDField = "documentID"
    static let userIDField = "userID"
    static let userFirstNameField = "firstName"
    static let userLastNameField = "lastName"
    static let userEmailField = "email"
    static let userProfilePicField = "profilePic"
    
    static let stickerDocumentIDField = "documentID"
    static let stickerNameField = "name"
    static let stickerImageField = "image"
    static let stickerDescriptionField = "description"
    static let stickerCategoryField = "category"
    static let stickerTagField = "tag"
    static let stickerIsCategorySelected = "isCategorySelected"
    static let stickerSelectedOnStart = "selectedOnStart"
    
    
    
    static let profileSettingsNotifications = "Notifications"
    static let profileSettingsDarkAppearance = "Dark Appearance"
    static let profileSettingsLogout = "Logout"
    
    
    
    
    // Stickers
    
    static let allStickers = "All"
    static let animalStickers = "Animals"
    static let foodStickers = "Food"
    static let objectStickers = "Objects"
    static let coloredStickers = "Colored"
    static let travelStickers = "Travel"
    
    static let featuredStickers = "Featured"
    static let noStickerTag = "none"
    
    
    
    // View Controllers
    
    static let profileVC = "ProfileViewController"
    
    
    // Alert controller messages
    
    
    static let logoutAlertTitle = "Are you sure?"
    static let logoutYesAction = "Yes"
    static let logoutNoAction = "No"
    
    
    
    // SF Symbols
    
    static let settingNotificationIcon = "bell.badge"
    static let settingDarkModeIcon = "moon"
    static let settingLogoutIcon = "power"
    
    static let tabHomeIcon = "house.fill"
    static let tabCaptureIcon = "camera.fill"
    static let tabAccountIcon = "person.crop.circle.fill"
    
    static let accountNotificationIcon = "bell.badge.fill"
    static let accountEditAccountIcon = "pencil.circle.fill"
    
    
    
    // tab bar items
    
    static let homeTab = "Home"
    static let captureTab = "Capture"
    static let accountTab = "Account"
    
    
    static let firebaseStoragePath = "gs://bestrokes-f5c28.appspot.com/"
    static let firebaseProfilePicStoragePath = "profilePictures"
    static let metadataContentType = "image/jpg"
    
    
}
