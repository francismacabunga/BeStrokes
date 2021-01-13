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
    
    
    
    
    
    
    
    //MARK: - Heading / Body Labels
    static let homeHeading1Text = "Featured"
    static let homeHeading2Text = "Stickers"
    static let profileSettingsHeadingText = "Settings"
    static let profileTrademark1Text = "BeStrokes"
    static let profileTrademark2Text = "made by Francis"
    static let accountHeading1Text = "Account"
    static let accountHeading2Text = "Liked Stickers"
    static let editAccountHeadingText = "Update Account"
    
    //MARK: - Button Labels
    static let tryMeButtonText = "Try me"
    static let saveButtonText = "Save"
    
    //MARK: - Tab Bar Labels
    static let homeTabText = "Home"
    static let captureTabText = "Capture"
    static let accountTabText = "Account"
    
    //MARK: - Text Fields Labels
    static let firstNameTextField = "First Name"
    static let lastNameTextField = "Last Name"
    static let emailTextField = "Email"
    
    
    
    
    
    //MARK: - Font Names
    static let defaultFont = "Futura"
    static let defaultFontBold = "Futura-Bold"
    static let defaultFontMedium = "Futura-Medium"
    
    //MARK: - Image Assets Names
    static let whiteBarImage = "Black_Bar"
    static let blackBarImage = "White_Bar"
    static let optionImage = "Dots"
    static let unheartStickerImage = "heart"
    static let heartStickerImage = "heart.fill"
    static let cameraImage = "Camera"
    
    //MARK: - SF Symbols Names
    static let settingNotificationIcon = "bell.badge"
    static let settingDarkModeIcon = "moon"
    static let settingLogoutIcon = "power"
    
    static let tabHomeIcon = "house.fill"
    static let tabCaptureIcon = "camera.fill"
    static let tabAccountIcon = "person.crop.circle.fill"
    
    static let accountNotificationIcon = "bell.badge.fill"
    static let accountEditAccountIcon = "pencil.circle.fill"
    
    
    
    
    
    //MARK: - Storyboard Names
    static let mainStoryboard = "Main"
    static let userStoryboard = "User"
    
    //MARK: - View Controllers Names
    static let landingVC = "LandingViewController"
    static let stickerOptionVC = "StickerOptionViewController"
    static let editAccountVC = "EditAccountViewController"
    static let editAccountContainerVC = "EditAccountContainerViewController"
    static let profileVC = "ProfileViewController"
    
    //MARK: - NIBs Names
    static let featuredStickerCell = "FeaturedCollectionViewCell"
    static let stickerCategoryCell = "StickerCategoryCollectionViewCell"
    static let profileTableViewCell = "ProfileTableViewCell"
    static let stickerCell = "StickerCollectionViewCell"
    static let likedStickerCell = "LikedStickersTableViewCell"
    
    
    
    
    
    //MARK: - Firebase
    static let firebaseStoragePath = "gs://bestrokes-f5c28.appspot.com/"
    static let firebaseProfilePicStoragePath = "profilePictures"
    static let metadataContentType = "image/jpg"
    
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
    
    
    
    
    
    //MARK: - Sticker Category/Tag Labels
    static let categoryAllStickers = "All"
    static let categoryFeaturedStickers = "Featured"
    static let tagNoStickers = "none"
    
    //MARK: - Sticker Category Array
    static let allStickers = "All"
    static let animalStickers = "Animals"
    static let foodStickers = "Food"
    static let objectStickers = "Objects"
    static let coloredStickers = "Colored"
    static let travelStickers = "Travel"
    
    //MARK: - Profile Settings Array
    static let profileSettingsNotifications = "Notifications"
    static let profileSettingsDarkAppearance = "Dark Appearance"
    static let profileSettingsLogout = "Logout"
    
    
    
    
    
    //MARK: - Warning Labels
    static let logoutAlertTitle = "Are you sure?"
    static let logoutYesAction = "Yes"
    static let logoutNoAction = "No"
    static let editAccountEmailVerficationErrorLabel = "Cannot update account, email is not verified yet. Please verify your email."
    static let editAccountTextFieldsErrorLabel = "Some fields are incomplete."
    static let editAccountTextFieldErrorLabel = "This field is required."
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
