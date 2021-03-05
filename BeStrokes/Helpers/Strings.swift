//
//  Strings.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 11/4/20.
//

import Foundation

struct Strings {
    
    //MARK: - Heading / Body Labels
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
    static let captureTutorial1Label = "Choose an image from your photos!"
    static let captureTutorial2Label = "Point your iPhone to a flat surface and start moving it."
    static let captureTutorial3Label = "You can tap the sticker to try!"
    static let captureStickerLabel = "Sticker Name"
    static let captureDefaultStickerName = "Elephant"
    static let notificationHeadingLabel = "Notifications"
    
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
    static let editAccountAlertTitle = "Success!"
    static let editAccountAlertMessage = "Your account details and email has been successfully updated. You may now sign in with your new email. Signing you out."
    static let landingAlertMessage = "User is automatically signed out."
    static let landingAlertAction = "Dismiss"
    static let landingInvalidCErrorAlertTitle = "Invalid credentials"
    static let landingInvalidUTErrorAlertTitle = "Invalid user token"
    static let landingInvalidCTErrorAlertTitle = "Invalid custom token"
    static let landingUserTEErrorAlertTitle = "User token expired"
    static let landingUserDErrorAlertTitle = "User is disabled"
    static let landingUserNFErrorAlertTitle = "User not found"
    static let landingCustomTMErrorAlertTitle = "Custom token mismatch"
    static let landingCallDErrorAlertTitle = "Default error"
    static let homeAlertTitle = "Error"
    static let homeAlertMessage = "The user is not signed in."
    static let homeAlert1Action = "Try again"
    static let homeAlert2Action = "Dismiss"
    static let captureAlertErrorTitle = "Error"
    static let captureAlertWarningTitle = "Warning"
    static let captureAlertExcessStickerErrorMessage = "Sticker is already present. You can only add 1 sticker as of the moment."
    static let captureAlertNoStickerErrorMessage = "Please choose a sticker first."
    static let captureAlertRaycastErrorMessage = "No flat surface has been detected yet."
    static let captureAlertAnchorErrorMessage = "Cannot create a plane anchor as of the moment."
    static let captureAlertAction = "Dismiss"
    
    //MARK: - Warning Labels
    static let profileWarningLabel = "To change the notification settings,"
    static let profileCannotSignOutUserLabel = "Cannot sign out user now. Please try again."
    static let accountNoLovedStickerLabel = "You don't have any loved stickers yet."
    static let accountInvalidStickerLabel = "No results for this sticker."
    static let editAccountEmailVerficationErrorLabel = "Account cannot be updated. Kindly tap the resend button below to resend an email verification."
    static let editAccountTextFieldsErrorLabel = "Some fields are incomplete."
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
    static let categoryAllStickers = "All"
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
    
    //MARK: - Landing Array
    static let lionImage = "Lion"
    static let shirtImage = "Shirt"
    static let dancingImage = "Dancing"
    static let headingOne = "BeStrokes"
    static let headingTwo = "Make it stick"
    static let headingThree = "Show it off"
    static let subheadingOne = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer cursus odio a purus."
    static let subheadingTwo = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer cursus odio a purus."
    static let subheadingThree = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer cursus odio a purus."
    
    
    
    
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
    
    //MARK: - SF Symbols Names
    static let settingNotificationIcon = "bell.badge"
    static let settingNotificationWithBadgeIcon = "bell.badge.fill"
    static let settingDarkModeIcon = "moon"
    static let settingLogoutIcon = "power"
    
    static let tabHomeIcon = "house.fill"
    static let tabCaptureIcon = "camera.fill"
    static let tabNotificationIcon = "bell.fill"
    static let tabAccountIcon = "person.circle.fill"
    
    static let accountNotificationIcon = "bell.fill"
    static let accountEditAccountIcon = "pencil.circle.fill"
    static let accountSearchStickerIcon = "magnifyingglass"
    static let accountArrowUpIcon = "chevron.up.square.fill"
    
    static let loveStickerIcon = "heart"
    static let lovedStickerIcon = "heart.fill"
    
    static let captureExitIcon = "xmark.circle.fill"
    static let captureDeleteIcon = "trash.fill"
    static let captureChooseImageIcon = "camera.fill"
    
    
    
    
    //MARK: - Storyboard Names
    static let mainStoryboard = "Main"
    static let userStoryboard = "User"
    
    //MARK: - View Controllers Names
    static let landingVC = "LandingViewController"
    static let tabBarVC = "UserTabBarController"
    static let homeVC = "HomeViewController"
    static let stickerOptionVC = "StickerOptionViewController"
    static let editAccountVC = "EditAccountViewController"
    static let editAccountContainerVC = "EditAccountContainerViewController"
    static let profileVC = "ProfileViewController"
    static let landingPageContentVC = "LandingPageContentViewController"
    static let captureVC = "CaptureViewController"
    
    //MARK: - NIBs Names
    static let featuredStickerCell = "FeaturedStickerCollectionViewCell"
    static let stickerCategoryCell = "StickerCategoryCollectionViewCell"
    static let profileCell = "ProfileTableViewCell"
    static let stickerCollectionViewCell = "StickerCollectionViewCell"
    static let stickerTableViewCell = "StickerTableViewCell"
    
    //MARK: - Segue
    static let unwindToLandingVC = "goBackToLandingVC"
    
    
    
    
    //MARK: - Firebase
    static let firebaseStoragePath = "gs://bestrokes-f5c28.appspot.com/"
    static let firebaseProfilePicStoragePath = "profilePictures"
    static let metadataContentType = "image/jpg"
    
    static let userCollection = "users"
    static let stickerCollection = "stickers"
    static let lovedByCollection = "lovedBy"
    static let lovedStickerCollection = "lovedStickers"
    
    static let userDocumentIDField = "documentID"
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
    static let stickerIsNewField = "isNew"
    static let stickerIsOpenField = "isOpen"
    static let stickerIsCategorySelected = "isCategorySelected"
    static let stickerSelectedOnStart = "selectedOnStart"
    
    //MARK: - Password Regex
    static let regexFormat = "SELF MATCHES %@"
    static let validationType = "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}"
    
    
    
    
    //MARK: - User Defaults
    
    static let tryMeButtonKey = "openedFromTryMeButton"
    static let captureButtonKey = "openedFromCaptureButton"
    static let lightModeKey = "isLightModeOn"
    static let notificationKey = "notificationAuthorization"
    static let notificationBadgeCounterKey = "notificationBadgeCounter"
    static let userFirstTimeLoginKey = "userFirstTimeLogin"
    
    //MARK: - Notification
    
    static let lightModeAppearanceNotificationName = "setLightModeAppearance"
    static let darkModeAppearanceNotificationName = "setDarkModeAppearance"
    static let badgeCounterToNotificationName = "setBadgeCounterToNotificationIcon"
    static let notificationIdentifier = "Sticker Notification"
    static let notificationTitle = "New Sticker Alert"
    static let notificationBody = "A brand new sticker has been uploaded. Check it out on your notifications tab!"
    
}
