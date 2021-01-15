//
//  Utilities.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 11/17/20.
//

import Foundation
import UIKit
import Firebase
import Kingfisher

struct Utilities {
    
    //MARK: - For Refactoring
    
    let user = Auth.auth().currentUser
    let db = Firestore.firestore()
    
    
    
    
    //MARK: - Text Fields Designs
    
    
    
    static func putDesignOn(textField: UITextField, placeholder: String) {
        
        textField.font = UIFont(name: Strings.defaultFont, size: 15)
        textField.textColor = UIColor.black
        textField.layer.masksToBounds = true
        textField.layer.cornerRadius = 15
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [
            .foregroundColor: #colorLiteral(red: 0.5411764706, green: 0.5411764706, blue: 0.5411764706, alpha: 1),
            .font: UIFont(name: Strings.defaultFont, size: 15)
        ])
        
    }
    
    static func showError(on textField: UITextField, with textFieldErrorMessage: String ) {
        
        textField.attributedPlaceholder = NSAttributedString(string: textFieldErrorMessage, attributes: [
            .foregroundColor: UIColor.red,
            .font: UIFont(name: Strings.defaultFont, size: 15)
        ])
        
    }
    
    static func isPasswordValid(_ password: String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    //    static func putDesignOn(textFieldWithBorder: UITextField) {
    //
    //        textFieldWithBorder.font = UIFont(name: Strings.defaultFont, size: 15)
    //        textFieldWithBorder.textColor = UIColor.black
    //        textFieldWithBorder.layer.masksToBounds = true
    //        textFieldWithBorder.layer.borderWidth = 2
    //        textFieldWithBorder.layer.cornerRadius = 15
    //        textFieldWithBorder.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    //
    //    }
    
    //MARK: - Label Designs
    
    static func putDesignOn(whitePopupHeadingLabel: UILabel) {
        
        whitePopupHeadingLabel.font = UIFont(name: Strings.defaultFontBold, size: 35)
        whitePopupHeadingLabel.textColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1)
        whitePopupHeadingLabel.numberOfLines = 0
        whitePopupHeadingLabel.lineBreakMode = .byWordWrapping
        
    }
    
    //    static func putDesignOn(blackPopupHeadingLabel: UILabel) {
    //
    //        blackPopupHeadingLabel.font = UIFont(name: Strings.defaultFontBold, size: 35)
    //        blackPopupHeadingLabel.textColor = UIColor.black
    //        blackPopupHeadingLabel.numberOfLines = 0
    //        blackPopupHeadingLabel.lineBreakMode = .byWordWrapping
    //
    //    }
    
    static func putDesignOn(whitePopupSubheadingLabel: UILabel) {
        
        whitePopupSubheadingLabel.font = UIFont(name: Strings.defaultFontMedium, size: 17)
        whitePopupSubheadingLabel.textColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1)
        whitePopupSubheadingLabel.numberOfLines = 0
        whitePopupSubheadingLabel.lineBreakMode = .byWordWrapping
        whitePopupSubheadingLabel.textAlignment = .left
        
    }
    
    static func putDesignOn(landingHeadingLabel: UILabel) {
        
        landingHeadingLabel.font = UIFont(name: Strings.defaultFontBold, size: 35)
        landingHeadingLabel.textColor = UIColor.black
        landingHeadingLabel.textAlignment = .center
        landingHeadingLabel.numberOfLines = 0
        landingHeadingLabel.lineBreakMode = .byWordWrapping
        
    }
    
    static func putDesignOn(landingSubheadingLabel: UILabel) {
        
        landingSubheadingLabel.font = UIFont(name: Strings.defaultFontMedium, size: 17)
        landingSubheadingLabel.textColor = UIColor.black
        landingSubheadingLabel.textAlignment = .center
        landingSubheadingLabel.numberOfLines = 0
        landingSubheadingLabel.lineBreakMode = .byWordWrapping
        
    }
    
    static func putDesignOn(signUpLabel: UILabel) {
        
        signUpLabel.font = UIFont(name: Strings.defaultFontMedium, size: 13)
        signUpLabel.textColor = UIColor.black
        signUpLabel.numberOfLines = 0
        signUpLabel.lineBreakMode = .byWordWrapping
        
    }
    
    static func putDesignOn(errorLabel: UILabel) {
        
        errorLabel.font = UIFont(name: Strings.defaultFontBold, size: 15)
        errorLabel.textColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1)
        errorLabel.backgroundColor = UIColor.red
        errorLabel.numberOfLines = 0
        errorLabel.lineBreakMode = .byWordWrapping
        errorLabel.textAlignment = .center
        
    }
    
    //MARK: - Button and Other Elements Designs
    
    static func putDesignOn(landingButton: UIButton) {
        
        landingButton.titleLabel?.font = UIFont(name: Strings.defaultFontBold, size: 20)
        landingButton.setTitleColor(#colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), for: .normal)
        landingButton.backgroundColor = UIColor.black
        landingButton.layer.cornerRadius = 25
        
    }
    
    static func putDesignOn(forgotPasswordButton: UIButton) {
        
        forgotPasswordButton.titleLabel?.font = UIFont(name: Strings.defaultFontMedium, size: 15)
        forgotPasswordButton.setTitleColor(#colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), for: .normal)
        
    }
    
    static func putDesignOn(whiteButton: UIButton) {
        
        whiteButton.titleLabel?.font = UIFont(name: Strings.defaultFontBold, size: 20)
        whiteButton.titleLabel?.textColor = UIColor.black
        whiteButton.setTitleColor(UIColor.black, for: .normal)
        whiteButton.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1)
        whiteButton.layer.cornerRadius = 20
        
    }
    
    static func putDesignOn(signUpButton: UIButton) {
        
        signUpButton.titleLabel?.font = UIFont(name: Strings.defaultFontBold, size: 13)
        signUpButton.setTitleColor(UIColor.black, for: .normal)
        
    }
    
    static func putDesignOn(loadingIcon: UIActivityIndicatorView) {
        
        loadingIcon.color = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1)
        
    }
    
    static func putDesignOn(navigationBar: UINavigationBar) {
        
        let image = UIImage(named: Strings.blackBarImage)
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        navigationBar.topItem?.titleView = imageView
        navigationBar.barTintColor = #colorLiteral(red: 0.7843137255, green: 0.7882352941, blue: 0.8039215686, alpha: 1)
        navigationBar.isTranslucent = true
        
    }
    
    //MARK: - Animations
    
    static func animateButton(button: UIButton) {
        
        UIView.animate(withDuration: 0.2) {
            button.alpha = 0.4
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            UIView.animate(withDuration: 0.2) {
                button.alpha = 1
            }
        }
    }
    
    static func showAnimatedResetPasswordSuccessMessage(validationLabel: UILabel) {
        
        validationLabel.font = UIFont(name: Strings.defaultFontBold, size: 15)
        validationLabel.textColor = UIColor.black
        validationLabel.backgroundColor = UIColor.green
        validationLabel.numberOfLines = 0
        validationLabel.lineBreakMode = .byWordWrapping
        validationLabel.textAlignment = .center
        
        UIView.animate(withDuration: 0.2) {
            validationLabel.isHidden = false
            validationLabel.text = Strings.resetPasswordSuccessMessage
        }
    }
    
    static func showAnimatedEmailVerificationSuccessfulySent(validationLabel: UILabel) {
        
        validationLabel.font = UIFont(name: Strings.defaultFontBold, size: 15)
        validationLabel.textColor = UIColor.black
        validationLabel.backgroundColor = UIColor.green
        validationLabel.numberOfLines = 0
        validationLabel.lineBreakMode = .byWordWrapping
        validationLabel.textAlignment = .center
        
        UIView.animate(withDuration: 0.2) {
            validationLabel.isHidden = false
            validationLabel.text = Strings.emailVerificationSent
        }
        
    }
    
    static func showAnimatedError(on errorLabel: UILabel, withError error: Error? = nil, withCustomizedString: String? = nil) {
        
        UIView.animate(withDuration: 0.2) {
            errorLabel.isHidden = false
            errorLabel.textColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1)
            errorLabel.backgroundColor = UIColor.red
            
            if let errorIsPresent = error {
                errorLabel.text = errorIsPresent.localizedDescription
            }
            
            if let customizedStringIsPresent = withCustomizedString {
                errorLabel.text = customizedStringIsPresent
            }
        }
        
    }
    
    static func transitionTo(storyboardName: String, identifier: String) -> UIViewController {
        
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: identifier)
        return viewController
        
    }
    
    
    
    
    
    
    //MARK: - MVVM Refactored Code
    
    // Text Field
    static func setDesignOn(textField: UITextField,
                            font: String,
                            fontSize: CGFloat,
                            textColor: UIColor,
                            backgroundColor: UIColor,
                            placeholder: String? = nil,
                            placeholderTextColor: UIColor? = nil,
                            isCircular: Bool? = nil)
    {
        textField.font = UIFont(name: font, size: fontSize)
        textField.textColor = textColor
        textField.backgroundColor = backgroundColor
        if placeholder != nil && placeholderTextColor != nil {
            textField.attributedPlaceholder = NSAttributedString(string: placeholder!, attributes: [
                                                                    .foregroundColor: placeholderTextColor!,
                                                                    .font: UIFont(name: font, size: fontSize)!])
        }
        if isCircular != nil {
            if isCircular! {
                textField.layer.cornerRadius = textField.bounds.height / 2
                textField.clipsToBounds = true
            }
        }
    }
    
    // Label
    static func setDesignOn(label: UILabel,
                            font: String,
                            fontSize: CGFloat,
                            fontColor: UIColor,
                            numberofLines: Int,
                            textAlignment: NSTextAlignment? = .none,
                            lineBreakMode: NSLineBreakMode? = .none,
                            text: String? = nil,
                            canResize: Bool? = nil,
                            minimumScaleFactor: CGFloat? = nil,
                            isCircular: Bool? = nil,
                            backgroundColor: UIColor? = nil)
    {
        label.font = UIFont(name: font, size: fontSize)
        label.textColor = fontColor
        label.numberOfLines = numberofLines
        if textAlignment != nil {
            label.textAlignment = textAlignment!
        }
        if lineBreakMode != nil {
            label.lineBreakMode = lineBreakMode!
        }
        if text != nil {
            label.text = text!
        }
        if canResize != nil {
            if canResize! {
                label.adjustsFontSizeToFitWidth = canResize!
            }
        }
        if minimumScaleFactor != nil {
            label.minimumScaleFactor = minimumScaleFactor!
        }
        if isCircular != nil {
            if isCircular! {
                label.layer.cornerRadius = label.bounds.height / 2
                label.clipsToBounds = true
            }
        }
        if backgroundColor != nil {
            label.backgroundColor = backgroundColor!
        }
    }
    
    // Button
    static func setDesignOn(button: UIButton,
                            title: String? = nil,
                            font: String? = nil,
                            fontSize: CGFloat? = nil,
                            backgroundImage: UIImage? = nil,
                            titleColor: UIColor? = nil,
                            tintColor: UIColor? = nil,
                            backgroundColor: UIColor? = nil,
                            isCircular: Bool? = nil,
                            isSkeletonPerfectCircle: Bool? = nil)
    {
        if title != nil {
            button.setTitle(title!, for: .normal)
        }
        if font != nil, fontSize != nil {
            button.titleLabel?.font = UIFont(name: font!, size: fontSize!)
        }
        if backgroundImage != nil {
            button.setBackgroundImage(backgroundImage!, for: .normal)
        }
        if titleColor != nil {
            button.setTitleColor(titleColor!, for: .normal)
        }
        if tintColor != nil {
            button.tintColor = tintColor!
        }
        if backgroundColor != nil {
            button.backgroundColor = backgroundColor!
        }
        if isCircular != nil {
            if isCircular! {
                button.layer.cornerRadius = button.bounds.height / 2
                button.clipsToBounds = true
            }
        }
        if isSkeletonPerfectCircle != nil {
            if isSkeletonPerfectCircle! {
                button.skeletonCornerRadius = Float(button.bounds.height / 2)
            }
        }
    }
    
    // Stack View
    static func setDesignOn(stackView: UIStackView,
                            backgroundColor: UIColor)
    {
        stackView.backgroundColor = backgroundColor
    }
    
    // View
    static func setDesignOn(view: UIView,
                            backgroundColor: UIColor? = nil,
                            isPerfectCircle: Bool? = nil,
                            setCustomCircleCurve: CGFloat? = nil,
                            isSkeletonPerfectCircle: Bool? = nil,
                            setCustomCircleSkeletonCurve: Float? = nil)
    {
        if backgroundColor != nil {
            view.backgroundColor = backgroundColor!
        }
        if isPerfectCircle != nil {
            if isPerfectCircle! {
                view.layer.cornerRadius = view.frame.size.height / 2
                view.clipsToBounds = true
            }
        }
        if setCustomCircleCurve != nil {
            view.layer.cornerRadius = setCustomCircleCurve!
            view.clipsToBounds = true
        }
        if isSkeletonPerfectCircle != nil {
            if isSkeletonPerfectCircle! {
                view.skeletonCornerRadius = Float(view.frame.size.height / 2)
            }
        }
        if setCustomCircleSkeletonCurve != nil {
            view.skeletonCornerRadius = setCustomCircleSkeletonCurve!
        }
    }
    
    // Image View
    static func setDesignOn(imageView: UIImageView,
                            image: UIImage? = nil,
                            tintColor: UIColor? = nil,
                            isPerfectCircle: Bool? = nil,
                            isSkeletonPerfectCircle: Bool? = nil)
    {
        imageView.contentMode = .scaleAspectFit
        if image != nil {
            imageView.image = image!
        }
        if tintColor != nil {
            imageView.tintColor = tintColor!
        }
        if isPerfectCircle != nil {
            if isPerfectCircle! {
                imageView.layer.cornerRadius = imageView.frame.size.height / 2
                imageView.clipsToBounds = true
                imageView.contentMode = .scaleAspectFit
            }
        }
        if isSkeletonPerfectCircle != nil {
            if isSkeletonPerfectCircle! {
                imageView.skeletonCornerRadius = Float(imageView.frame.size.height / 2)
            }
        }
    }
    
    // Collection View
    static func setDesignOn(collectionView: UICollectionView,
                            backgroundColor: UIColor,
                            isHorizontalDirection: Bool,
                            showScrollIndicator: Bool)
    {
        collectionView.backgroundColor = backgroundColor
        if isHorizontalDirection {
            collectionView.configureForPeekingDelegate(scrollDirection: .horizontal)
        } else {
            collectionView.configureForPeekingDelegate(scrollDirection: .vertical)
        }
        if showScrollIndicator {
            if isHorizontalDirection {
                collectionView.showsHorizontalScrollIndicator = true
            } else {
                collectionView.showsVerticalScrollIndicator = true
            }
        } else {
            if isHorizontalDirection {
                collectionView.showsHorizontalScrollIndicator = false
            } else {
                collectionView.showsVerticalScrollIndicator = false
            }
        }
    }
    
    // Table View
    static func setDesignOn(tableView: UITableView,
                            backgroundColor: UIColor,
                            separatorStyle: UITableViewCell.SeparatorStyle,
                            showVerticalScrollIndicator: Bool,
                            separatorColor: UIColor? = nil,
                            rowHeight: CGFloat? = nil)
    {
        tableView.backgroundColor = backgroundColor
        tableView.separatorStyle = separatorStyle
        tableView.showsVerticalScrollIndicator = showVerticalScrollIndicator
        if separatorColor != nil {
            tableView.separatorColor = separatorColor!
        }
        if rowHeight != nil {
            tableView.rowHeight = rowHeight!
        }
    }
    
    // Navigation Bar
    static func setDesignOn(navigationBar: UINavigationBar,
                            isDarkMode: Bool)
    {
        let imageView = UIImageView()
        var image = UIImage()
        if isDarkMode {
            image = UIImage(named: Strings.blackBarImage)!
            navigationBar.barTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        } else {
            image = UIImage(named: Strings.whiteBarImage)!
            navigationBar.barTintColor = #colorLiteral(red: 0.7843137255, green: 0.7882352941, blue: 0.8039215686, alpha: 1)
        }
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        navigationBar.topItem?.titleView = imageView
    }
    
    // Loading Indicator
    static func setDesignOn(activityIndicatorView: UIActivityIndicatorView,
                            size: UIActivityIndicatorView.Style,
                            backgroundColor: UIColor)
    {
        activityIndicatorView.style = size
        activityIndicatorView.color = backgroundColor
    }
    
}




