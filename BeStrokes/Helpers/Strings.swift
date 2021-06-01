//
//  Strings.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 11/4/20.
//

import Foundation

struct Strings {
    
    //MARK: - Heading / Body Labels
    static let landingHeading1Text = "BeStrokes"
    static let landingHeading2Text = "Make it stick"
    static let landingHeading3Text = "Show it off"
    static let landingSubheading1Text = "Cool new way to check out new designs on your favorite clothes, through the use of AR."
    static let landingSubheading2Text = "Choose from categories of stickers available, or pick from your very own photos."
    static let landingSubheading3Text = "Point your phone to your favorite shirt and watch the new design come to life."
    static let homeHeading1Text = "Featured"
    static let homeHeading2Text = "Stickers"
    static let profileSettingsHeadingText = "Settings"
    static let profileTrademark1Text = "BeStrokes"
    static let profileTrademark2Text = "made by Francis"
    static let accountHeading1Text = "Account"
    static let accountHeading2Text = "Loved Stickers"
    static let editAccountHeadingText = "Update Account"
    static let landingSignupText = "Don't have an account yet?"
    static let signUpHeadingText = "Create Account"
    static let loginHeadingText = "Welcome Back!"
    static let forgotPasswordHeadingText = "Forgot your password?"
    static let forgotPasswordSubheadingText = "Enter your associated email with your account."
    static let captureTutorial1Text = "Choose an image from your photos!"
    static let captureTutorial2Text = "Point your iPhone to a flat surface and start moving it."
    static let captureTutorial3Text = "You can tap the sticker to try!"
    static let captureTutorial4Text = "Tap on the flat surface detected to make the sticker appear."
    static let captureStickerText = "Sticker Name"
    static let captureDefaultStickerNameText = "Elephant"
    static let notificationHeadingText = "Notifications"
    
    //MARK: - Button Labels
    static let tryMeButtonText = "Try me"
    static let saveButtonText = "Save"
    static let loginButtonText = "Login"
    static let signUpButtonText = "Sign up"
    static let getStartedButtonText = "Get Started"
    static let signUpButtonTransitionText = "Redirecting"
    static let forgotPasswordButtonText = "Forgot Password"
    static let submitButtonText = "Submit"
    static let dismissButtonText = "Dismiss"
    static let resendButtonText = "Resend"
    static let dontShowAgainButtonText = "Don't show again"
    static let clickHereButtonText = "click here."
    
    //MARK: - Text Fields Labels
    static let firstNameTextField = "First Name"
    static let lastNameTextField = "Last Name"
    static let emailTextField = "Email"
    static let passwordTextField = "Password"
    static let searchTextField = "Search"
    
    //MARK: - Alert Labels
    static let logoutAlertTitle = "Are you sure?"
    static let logoutYesAction = "Yes"
    static let logoutNoAction = "No"
    static let captureAlertExcessStickerErrorMessage = "Sticker is already present. You can only add 1 sticker as of the moment."
    static let captureAlertNoStickerErrorMessage = "Please choose a sticker first."
    static let captureAlertRaycastErrorMessage = "No flat surface has been detected yet."
    static let captureAlertAnchorErrorMessage = "Cannot create a plane anchor as of the moment."
    static let errorAlert = "Error"
    static let dismissAlert = "Dismiss"
    
    //MARK: - Warning Labels
    static let profileWarningLabel = "To change the notification settings,"
    static let profileCannotSignOutUserLabel = "Cannot sign out user now. Please try again."
    static let accountNoLovedStickerLabel = "You don't have any loved stickers yet."
    static let accountInvalidStickerLabel = "No results for this sticker."
    static let editAccountEmailVerficationErrorLabel = "Account cannot be updated. Kindly tap the resend button below to resend an email verification."
    static let editAccountTextFieldErrorLabel = "All fields are required, please fill them out."
    static let editAccountSuccessfullySentEmailVerificationLabel = "Email verfication has been successfully resent, please check your email."
    static let editAccountProcessSuccessfulLabel = "Your account has been updated, please verify your new email address to edit your account again."
    static let signUpFirstNameTextFieldErrorLabel = "First Name is required."
    static let signUpLastNameTextFieldErrorLabel = "Last Name is required."
    static let signUpEmailTextFieldErrorLabel = "Email is required."
    static let signUpPasswordTextFieldErrorLabel = "Password is required."
    static let signUpPasswordErrorLabel = "Password must be at least 8 characters long with one alphabet and one special character or more."
    static let signUpProfilePictureErrorLabel = "Profile picture is required, please choose an image."
    static let signUpProcessSuccessfulLabel = "Successfully created your account. Email verification has been sent, please check your email."
    static let forgotPasswordProcessSuccessfulLabel = "Your password has been successfuly reset. Please check your email."
    static let notificationWarningLabel = "No new stickers as of the moment."
    
    
    
    
    //MARK: - Sticker Category/Tag Title
    static let categoryFeaturedStickers = "Featured"
    static let tagNoStickers = "None"
    
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
    
    
    
    
    //MARK: - Font Names
    static let defaultFont = "Futura"
    static let defaultFontBold = "Futura-Bold"
    static let defaultFontMedium = "Futura-Medium"
    
    //MARK: - Image Assets Names
    static let whiteBarImage = "Black_Bar"
    static let blackBarImage = "White_Bar"
    static let optionImage = "Dots"
    static let cameraImage = "Camera"
    static let signUpDefaultImage = "Woman"
    static let loginDefaultImage = "Avatar"
    static let blackKeys = "Black_Keys"
    static let whiteKeys = "White_Keys"
    static let tutorialDialogueImage = "Dialogue"
    static let defaultStickerImage = "Elephant"
    static let lionImage = "Lion"
    static let shirtImage = "Shirt"
    static let dancingImage = "Dancing"
    
    //MARK: - SF Symbols Names
    static let settingNotificationIcon = "bell.badge"
    static let settingDarkModeIcon = "moon"
    static let settingLogoutIcon = "power"
    static let tabHomeIcon = "house.fill"
    static let tabCaptureIcon = "camera.fill"
    static let tabNotificationIcon = "bell.fill"
    static let tabAccountIcon = "person.circle.fill"
    static let accountEditAccountIcon = "pencil.circle.fill"
    static let accountSearchStickerIcon = "magnifyingglass"
    static let accountArrowUpIcon = "chevron.up.square.fill"
    static let loveStickerIcon = "heart"
    static let lovedStickerIcon = "heart.fill"
    static let captureDeleteIcon = "trash.fill"
    static let captureChooseImageIcon = "camera.fill"
    static let exitIcon = "xmark.circle.fill"
    
    
    
    
    //MARK: - Storyboard Names
    static let guestStoryboard = "Guest"
    static let userStoryboard = "User"
    
    //MARK: - View Controllers Names
    static let landingVC = "LandingViewController"
    static let landingPageContentVC = "LandingPageContentViewController"
    static let tabBarVC = "TabBarViewController"
    static let stickerOptionVC = "StickerOptionViewController"
    static let captureVC = "CaptureViewController"
    static let profileVC = "ProfileViewController"
    
    //MARK: - NIBs Names
    static let featuredStickerCell = "FeaturedStickerCollectionViewCell"
    static let stickerCategoryCell = "StickerCategoryCollectionViewCell"
    static let stickerCollectionViewCell = "StickerCollectionViewCell"
    static let profileCell = "ProfileTableViewCell"
    static let stickerTableViewCell = "StickerTableViewCell"
    
    //MARK: - Segues
    static let unwindToLandingVC = "goBackToLandingVC"
    
    
    
    
    //MARK: - Firebase
    static let firebaseStoragePath = "gs://bestrokes-f5c28.appspot.com/"
    static let firebaseProfilePicStoragePath = "profilePictures"
    static let metadataContentType = "image/jpg"
    
    static let userCollection = "users"
    static let stickerCollection = "stickers"
    static let lovedByCollection = "lovedBy"
    
    static let userIDField = "userID"
    static let userFirstNameField = "firstName"
    static let userLastNameField = "lastName"
    static let userEmailField = "email"
    static let userPasswordField = "password"
    static let userInitialUserEmail = "initialUserEmail"
    static let userProfilePicField = "profilePic"
    
    static let stickerIDField = "stickerID"
    static let stickerNameField = "name"
    static let stickerImageField = "image"
    static let stickerDescriptionField = "description"
    static let stickerCategoryField = "category"
    static let stickerTagField = "tag"
    static let stickerIsRecentlyUploadedField = "isRecentlyUploaded"
    static let stickerIsNewField = "isNew"
    static let stickerIsLovedField = "isLoved"
    
    //MARK: - Password Regex
    static let regexFormat = "SELF MATCHES %@"
    static let validationType = "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}"
    
    
    
    
    //MARK: - User Defaults
    static let capturePageOpenedFromTryMeButtonKey = "capturePageOpenedFromTryMeButtonKey"
    static let capturePageOpenedFromCaptureTabKey = "capturePageOpenedFromCaptureButtonKey"
    static let lightModeKey = "lightModeKey"
    static let notificationKey = "notificationAuthorizationKey"
    static let notificationBadgeCounterKey = "notificationBadgeCounterKey"
    static let userFirstTimeLoginKey = "userFirstTimeLoginKey"
    static let homeTabKey = "homeTabKey"
    static let captureTabKey = "captureTabKey"
    static let notificationTabKey = "notificationTabKey"
    static let accountTabKey = "accountTabKey"
    static let homePageKey = "homePageKey"
    static let capturePageKey = "capturePageKey"
    static let notificationPageKey = "notificationPageKey"
    static let accountPageKey = "accountPageKey"
    static let profilePageKey = "profilePageKey"
    static let stickerOptionPageKey = "stickerOptionPageKey"
    static let editAccountPageKey = "editAccountPageKey"
    
    //MARK: - Notification
    static let lightModeAppearanceNotificationName = "setLightModeAppearance"
    static let darkModeAppearanceNotificationName = "setDarkModeAppearance"
    static let badgeCounterToNotificationName = "setBadgeCounterToNotificationIcon"
    static let reloadUserDataNotificationName = "reloadUserData"
    static let reloadProfilePicNotificationName = "reloadProfilePic"
    static let notificationIdentifier = "Sticker Notification"
    static let notificationTitle = "New Sticker Alert"
    static let notificationBody = "A brand new sticker has been uploaded. Check it out on your notifications tab!"
    
}
