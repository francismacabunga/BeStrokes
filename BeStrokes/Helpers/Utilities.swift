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
        
        let image = UIImage(named: Strings.blackBar)
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
    
    
    
    
    
    
    //MARK: - MVVM
    
    
    
    
    
    
    
    
    
    
    
    // Use for text
    static func setDesignOn(_ label: UILabel, label labelValue: String? = nil, font: String, fontSize: CGFloat, fontColor: UIColor, textAlignment: NSTextAlignment? = .none, numberofLines: Int, lineBreakMode: NSLineBreakMode? = .none, canResize: Bool? = nil, minimumScaleFactor: CGFloat? = nil, isCircular: Bool? = nil, backgroundColor: UIColor? = nil) {
        
        if labelValue != nil {
            label.text = labelValue
        }
        
        label.textColor = fontColor
        label.font = UIFont(name: font, size: fontSize)
        label.numberOfLines = numberofLines
        
        if textAlignment != nil {
            label.textAlignment = textAlignment!
        }
        
        if lineBreakMode != nil {
            label.lineBreakMode = lineBreakMode!
        }
        
        if canResize != nil {
            label.adjustsFontSizeToFitWidth = canResize!
        }
        
        if minimumScaleFactor != nil {
            label.minimumScaleFactor = minimumScaleFactor!
        }
        
        if isCircular != nil {
            label.layer.cornerRadius = label.bounds.height / 2
            label.clipsToBounds = true
            label.backgroundColor = backgroundColor
        }
        
    }
    
    // Use for images
    static func setDesignOn(imageView: UIImageView, image: UIImage? = nil, tintColor: UIColor? = nil, isCircular: Bool? = nil, isCircularSkeleton: Bool? = nil) {
        
        if image != nil {
            imageView.image = image
        }
        
        if tintColor != nil {
            imageView.tintColor = tintColor
        }
        
        if isCircular != nil {
            imageView.layer.cornerRadius = imageView.frame.size.height / 2
            imageView.clipsToBounds = true
            imageView.contentMode = .scaleAspectFit
        }
        
        if isCircularSkeleton != nil {
            imageView.skeletonCornerRadius = Float(imageView.frame.size.height / 2)
        }
        imageView.contentMode = .scaleAspectFit
        
    }
    
    // Use for navbar
    static func setDesignOn(navigationBar: UINavigationBar, isDarkMode: Bool) {
        
        let imageView = UIImageView()
        var image = UIImage()
        
        if isDarkMode {
            image = UIImage(named: Strings.blackBar)!
            navigationBar.barTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        } else {
            image = UIImage(named: Strings.whiteBar)!
            navigationBar.barTintColor = #colorLiteral(red: 0.7843137255, green: 0.7882352941, blue: 0.8039215686, alpha: 1)
        }
        
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        navigationBar.topItem?.titleView = imageView
    }
    
    // Use for collection view
    static func setDesignOn(collectionView: UICollectionView, isTransparent: Bool, isHorizontalDirection: Bool, showIndicator: Bool) {
        
        if isTransparent {
            collectionView.backgroundColor = .clear
        }
        
        if isHorizontalDirection {
            collectionView.configureForPeekingDelegate(scrollDirection: .horizontal)
        } else {
            collectionView.configureForPeekingDelegate(scrollDirection: .vertical)
        }
        
        if showIndicator {
            if isHorizontalDirection {
                collectionView.showsHorizontalScrollIndicator = true
            }
        } else {
            if !isHorizontalDirection {
                collectionView.showsVerticalScrollIndicator = false
            }
        }
        
    }
    
    // Use for tableview
    static func setDesignOn(tableView: UITableView, isTransparent: Bool, backgroundColor: UIColor? = nil, separatorStyle: UITableViewCell.SeparatorStyle, rowHeight: CGFloat? = nil, showVerticalScrollIndicator: Bool) {
        
        if isTransparent {
            tableView.backgroundColor = .clear
        }
        
        if backgroundColor != nil {
            tableView.backgroundColor = backgroundColor
        }
        
        tableView.separatorStyle = separatorStyle
        
        if rowHeight != nil {
            tableView.rowHeight = rowHeight!
        }
        
        if showVerticalScrollIndicator {
            tableView.showsVerticalScrollIndicator = true
        }
        
        tableView.showsVerticalScrollIndicator = false
        
       
    
    }
    
    
    
    // Use for loading indicator
    static func setDesignOn(activityIndicatorView: UIActivityIndicatorView, size: UIActivityIndicatorView.Style, color: UIColor) {
        activityIndicatorView.color = color
        activityIndicatorView.style = size
    }
    
    // Use for view
    static func setDesignOn(view: UIView, color: UIColor? = nil, isCircular: Bool? = nil, amountOfCurve: CGFloat? = nil, isCircularSkeleton: Bool? = nil, circularSkeletonCurve: Float? = nil) {
        
        if color != nil {
            view.backgroundColor = color
        }
        
        if isCircular != nil {
            view.layer.cornerRadius = view.frame.size.height / 2
            view.clipsToBounds = true
        }
        
        if amountOfCurve != nil {
            view.layer.cornerRadius = amountOfCurve!
            view.clipsToBounds = true
        }
        
        if isCircularSkeleton != nil {
            view.skeletonCornerRadius = circularSkeletonCurve!
        }
        
    }
    
    // Use for stack
    static func setDesignOn(stackView: UIStackView, color: UIColor) {
        stackView.backgroundColor = color
    }
    
    
    
    // Use for buttons
    static func setDesignOn(button: UIButton, title: String? = nil, font: String? = nil, size: CGFloat? = nil, titleColor: UIColor? = nil, backgroundColor: UIColor? = nil, tintColor: UIColor? = nil, backgroundImage: UIImage? = nil, isCircular: Bool? = nil) {
        
        
        if titleColor != nil {
            button.setTitleColor(titleColor, for: .normal)
        }
        
        if font != nil, size != nil {
            button.titleLabel?.font = UIFont(name: font!, size: size!)
        }
        
        
        
        
        
        
        if title != nil {
            button.setTitle(title, for: .normal)
        }
        
        if tintColor != nil {
            button.tintColor = tintColor
        }
        
        
        
        
        var color = UIColor()
        
        if backgroundColor != nil {
            color = backgroundColor!
        }
        
        if isCircular != nil {
            button.layer.cornerRadius = button.bounds.height / 2
            button.clipsToBounds = true
            button.backgroundColor = color
        }
        
        if backgroundImage != nil {
            button.setBackgroundImage(backgroundImage, for: .normal)
        }
        
        if backgroundColor != nil {
            button.backgroundColor = color
        }
        
        
        
    }
    
    
    
    
    
    
    
}


