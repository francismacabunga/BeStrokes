//
//  Utilities.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 11/17/20.
//

import Foundation
import UIKit
import Firebase
import CropViewController
import UserNotifications

struct Utilities {
    
    //MARK: - Notification Names
    
    static let setLightModeAppearance = Notification.Name(Strings.lightModeAppearanceNotificationName)
    static let setDarkModeAppearance = Notification.Name(Strings.darkModeAppearanceNotificationName)
    static let setBadgeCounterToNotificationIcon = Notification.Name(Strings.badgeCounterToNotificationName)
    static let reloadUserData = Notification.Name(Strings.reloadUserDataNotificationName)
    static let reloadProfilePic = Notification.Name(Strings.reloadProfilePicNotificationName)
    
    
    //MARK: - Notification Functions
    
    static func checkIfNotificationIsPermitted(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { permission in
            if permission.authorizationStatus == .authorized {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    
    //MARK: - Design Elements
    
    // Label
    static func setDesignOn(label: UILabel,
                            fontName: String? = nil,
                            fontSize: CGFloat? = nil,
                            numberofLines: Int? = nil,
                            textAlignment: NSTextAlignment? = .none,
                            lineBreakMode: NSLineBreakMode? = .none,
                            fontColor: UIColor? = nil,
                            text: String? = nil,
                            canResize: Bool? = nil,
                            minimumScaleFactor: CGFloat? = nil,
                            isCircular: Bool? = nil,
                            backgroundColor: UIColor? = nil,
                            isHidden: Bool? = nil)
    {
        if fontName != nil && fontSize != nil {
            label.font = UIFont(name: fontName!, size: fontSize!)
        }
        if numberofLines != nil {
            label.numberOfLines = numberofLines!
        }
        if textAlignment != nil {
            label.textAlignment = textAlignment!
        }
        if lineBreakMode != nil {
            label.lineBreakMode = lineBreakMode!
        }
        if fontColor != nil {
            label.textColor = fontColor!
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
        if isHidden != nil {
            if isHidden! {
                label.isHidden = true
            } else {
                label.isHidden = false
            }
        }
    }
    
    // Text Field
    static func setDesignOn(textField: UITextField,
                            fontName: String? = nil,
                            fontSize: CGFloat? = nil,
                            autocorrectionType: UITextAutocorrectionType? = nil,
                            isSecureTextEntry: Bool? = nil,
                            keyboardType: UIKeyboardType? = nil,
                            textContentType: UITextContentType? = nil,
                            capitalization: UITextAutocapitalizationType? = nil,
                            returnKeyType: UIReturnKeyType? = nil,
                            textColor: UIColor? = nil,
                            backgroundColor: UIColor? = nil,
                            placeholder: String? = nil,
                            placeholderTextColor: UIColor? = nil,
                            isCircular: Bool? = nil)
    {
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftViewMode = .always
        if fontName != nil && fontSize != nil {
            textField.font = UIFont(name: fontName!, size: fontSize!)
        }
        if autocorrectionType != nil {
            textField.autocorrectionType = autocorrectionType!
        }
        if isSecureTextEntry != nil {
            if isSecureTextEntry! {
                textField.isSecureTextEntry = isSecureTextEntry!
            }
        }
        if keyboardType != nil {
            textField.keyboardType = keyboardType!
        }
        if textContentType != nil {
            textField.textContentType = textContentType!
        }
        if capitalization != nil {
            textField.autocapitalizationType = capitalization!
        }
        if returnKeyType != nil {
            textField.returnKeyType = returnKeyType!
        }
        if textColor != nil {
            textField.textColor = textColor!
        }
        if backgroundColor != nil {
            textField.backgroundColor = backgroundColor!
        }
        if placeholder != nil && placeholderTextColor != nil && fontName != nil && fontSize != nil {
            textField.attributedPlaceholder = NSAttributedString(string: placeholder!, attributes: [
                                                                    .foregroundColor: placeholderTextColor!,
                                                                    .font: UIFont(name: fontName!, size: fontSize!)!])
        }
        if isCircular != nil {
            if isCircular! {
                textField.layer.cornerRadius = textField.bounds.height / 2
                textField.clipsToBounds = true
            }
        }
    }
    
    // Shadow on Text Field
    static func setShadowOn(textField: UITextField,
                            isHidden: Bool,
                            borderStyle: UITextField.BorderStyle? = nil,
                            shadowColor: CGColor? = nil,
                            shadowOpacity: Float? = nil,
                            shadowOffset: CGSize? = nil,
                            shadowRadius: CGFloat? = nil)
    {
        if !isHidden && borderStyle != nil && shadowColor != nil && shadowOpacity != nil && shadowOffset != nil && shadowRadius != nil {
            textField.borderStyle = borderStyle!
            textField.layer.shadowColor = shadowColor!
            textField.layer.shadowOpacity = shadowOpacity!
            textField.layer.shadowOffset = shadowOffset!
            textField.layer.shadowRadius = shadowRadius!
        } else {
            textField.layer.shadowColor = nil
            textField.layer.shadowOpacity = 0
            textField.layer.shadowOffset = .zero
            textField.layer.shadowRadius = 0
        }
    }
    
    // Button
    static func setDesignOn(button: UIButton,
                            title: String? = nil,
                            fontName: String? = nil,
                            fontSize: CGFloat? = nil,
                            backgroundImage: UIImage? = nil,
                            titleColor: UIColor? = nil,
                            tintColor: UIColor? = nil,
                            backgroundColor: UIColor? = nil,
                            isCircular: Bool? = nil,
                            isSkeletonCircular: Bool? = nil,
                            isEnabled: Bool? = nil,
                            isHidden: Bool? = nil)
    {
        if title != nil {
            button.setTitle(title!, for: .normal)
        }
        if fontName != nil, fontSize != nil {
            button.titleLabel?.font = UIFont(name: fontName!, size: fontSize!)
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
        if isSkeletonCircular != nil {
            if isSkeletonCircular! {
                button.skeletonCornerRadius = Float(button.bounds.height / 2)
            }
        }
        if isEnabled != nil {
            if isEnabled! {
                button.isEnabled = true
            } else {
                button.isEnabled = false
            }
        }
        if isHidden != nil {
            if isHidden! {
                button.isHidden = true
            } else {
                button.isHidden = false
            }
        }
    }
    
    // Shadow on Button
    static func setShadowOn(button: UIButton,
                            isHidden: Bool,
                            shadowColor: CGColor? = nil,
                            shadowOpacity: Float? = nil,
                            shadowOffset: CGSize? = nil,
                            shadowRadius: CGFloat? = nil)
    {
        if !isHidden && shadowColor != nil && shadowOpacity != nil && shadowOffset != nil && shadowRadius != nil {
            button.layer.shadowColor = shadowColor!
            button.layer.shadowOpacity = shadowOpacity!
            button.layer.shadowOffset = shadowOffset!
            button.layer.shadowRadius = shadowRadius!
            button.layer.masksToBounds = false
        } else {
            button.layer.shadowColor = nil
            button.layer.shadowOpacity = 0
            button.layer.shadowOffset = .zero
            button.layer.shadowRadius = 0
            button.layer.masksToBounds = true
        }
    }
    
    // Navigation Bar
    static func setDesignOn(navigationBar: UINavigationBar, isDarkMode: Bool) {
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
    
    // Scroll View
    static func setDesignOn(scrollView: UIScrollView,
                            indicatorColor: UIScrollView.IndicatorStyle? = nil,
                            keyboardDismissMode: UIScrollView.KeyboardDismissMode? = nil)
    {
        if indicatorColor != nil {
            scrollView.indicatorStyle = indicatorColor!
        }
        if keyboardDismissMode != nil {
            scrollView.keyboardDismissMode = keyboardDismissMode!
        }
    }
    
    // Loading Indicator
    static func setDesignOn(activityIndicatorView: UIActivityIndicatorView,
                            size: UIActivityIndicatorView.Style? = nil,
                            color: UIColor? = nil,
                            isStartAnimating: Bool? = nil,
                            isHidden: Bool? = nil)
    {
        if size != nil {
            activityIndicatorView.style = size!
        }
        if color != nil {
            activityIndicatorView.color = color!
        }
        if isStartAnimating != nil {
            if isStartAnimating! {
                activityIndicatorView.startAnimating()
            } else {
                activityIndicatorView.stopAnimating()
            }
        }
        if isHidden != nil {
            if isHidden! {
                activityIndicatorView.isHidden = true
            } else {
                activityIndicatorView.isHidden = false
            }
        }
    }
    
    // Page Control
    static func setDesignOn(pageControl: UIPageControl,
                            pageIndicatorColor: UIColor,
                            currentPageColor: UIColor)
    {
        pageControl.pageIndicatorTintColor = pageIndicatorColor
        pageControl.currentPageIndicatorTintColor = currentPageColor
    }
    
    // Switch
    static func setDesignOn(switchIndicator: UISwitch, alpha: CGFloat) {
        switchIndicator.alpha = alpha
    }
    
    // Tab Bar
    static func setDesignOn(tabBar: UITabBar,
                            backgroundColor: UIColor,
                            iconColor: UIColor)
    {
        tabBar.barTintColor = backgroundColor
        tabBar.tintColor = iconColor
    }
    
    // Tab Bar Item
    static func setDesignOn(tabBarItem: UITabBarItem,
                            tag: Int,
                            image: UIImage)
    {
        tabBarItem.tag = tag
        tabBarItem.image = image
    }
    
    // Stack View
    static func setDesignOn(stackView: UIStackView,
                            backgroundColor: UIColor? = nil,
                            isCircular: Bool? = nil,
                            isHidden: Bool? = nil)
    {
        if backgroundColor != nil {
            stackView.backgroundColor = backgroundColor!
        }
        if isCircular != nil {
            if isCircular! {
                stackView.layer.cornerRadius = stackView.frame.size.width / 2
                stackView.clipsToBounds = true
            }
        }
        if isHidden != nil {
            if isHidden! {
                stackView.isHidden = true
            } else {
                stackView.isHidden = false
            }
        }
    }
    
    // View
    static func setDesignOn(view: UIView,
                            backgroundColor: UIColor? = nil,
                            isCircular: Bool? = nil,
                            setCustomCircleCurve: CGFloat? = nil,
                            isSkeletonCircular: Bool? = nil,
                            setCustomSkeletonCircleCurve: Float? = nil,
                            isHidden: Bool? = nil)
    {
        if backgroundColor != nil {
            view.backgroundColor = backgroundColor!
        }
        if isCircular != nil {
            if isCircular! {
                view.layer.cornerRadius = view.frame.size.height / 2
                view.clipsToBounds = true
            }
        }
        if setCustomCircleCurve != nil {
            view.layer.cornerRadius = setCustomCircleCurve!
            view.clipsToBounds = true
        }
        if isSkeletonCircular != nil {
            if isSkeletonCircular! {
                view.skeletonCornerRadius = Float(view.frame.size.height / 2)
            }
        }
        if setCustomSkeletonCircleCurve != nil {
            view.skeletonCornerRadius = setCustomSkeletonCircleCurve!
        }
        if isHidden != nil {
            if isHidden! {
                view.isHidden = true
            } else {
                view.isHidden = false
            }
        }
    }
    
    // Shadow on View
    static func setShadowOn(view: UIView,
                            isHidden: Bool,
                            shadowColor: CGColor? = nil,
                            shadowOpacity: Float? = nil,
                            shadowOffset: CGSize? = nil,
                            shadowRadius: CGFloat? = nil)
    {
        if !isHidden && shadowColor != nil && shadowOpacity != nil && shadowOffset != nil && shadowRadius != nil {
            view.layer.shadowColor = shadowColor!
            view.layer.shadowOpacity = shadowOpacity!
            view.layer.shadowOffset = shadowOffset!
            view.layer.shadowRadius = shadowRadius!
            view.layer.masksToBounds = false
        } else {
            view.layer.shadowColor = nil
            view.layer.shadowOpacity = 0
            view.layer.shadowOffset = .zero
            view.layer.shadowRadius = 0
            view.layer.masksToBounds = true
        }
    }
    
    // Visual Effect View
    static func setDesignOn(visualEffectView: UIVisualEffectView,
                            blurEffect: UIBlurEffect,
                            isHidden: Bool? = nil)
    {
        visualEffectView.effect = blurEffect
        if isHidden != nil {
            if isHidden! {
                visualEffectView.isHidden = true
            } else {
                visualEffectView.isHidden = false
            }
        }
    }
    
    // Image View
    static func setDesignOn(imageView: UIImageView,
                            image: UIImage? = nil,
                            tintColor: UIColor? = nil,
                            alpha: CGFloat? = nil,
                            isCircular: Bool? = nil,
                            isSkeletonCircular: Bool? = nil,
                            isUserInteractionEnabled: Bool? = nil,
                            gestureRecognizer: UIGestureRecognizer? = nil,
                            isHidden: Bool? = nil)
    {
        imageView.contentMode = .scaleAspectFit
        if image != nil {
            imageView.image = image!
        }
        if tintColor != nil {
            imageView.tintColor = tintColor!
        }
        if alpha != nil {
            imageView.alpha = alpha!
        }
        if isCircular != nil {
            if isCircular! {
                imageView.layer.cornerRadius = imageView.frame.size.height / 2
                imageView.contentMode = .scaleAspectFit
                imageView.clipsToBounds = true
            }
        }
        if isSkeletonCircular != nil {
            if isSkeletonCircular! {
                imageView.skeletonCornerRadius = Float(imageView.frame.size.height / 2)
            }
        }
        if isUserInteractionEnabled != nil {
            if isUserInteractionEnabled! {
                imageView.isUserInteractionEnabled = true
            } else {
                imageView.isUserInteractionEnabled = false
            }
        }
        if gestureRecognizer != nil {
            imageView.addGestureRecognizer(gestureRecognizer!)
        }
        if isHidden != nil {
            if isHidden! {
                imageView.isHidden = true
            } else {
                imageView.isHidden = false
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
    
    // Collection View Layout
    static func setMeasurementsOn(collectionViewFlowLayout: UICollectionViewFlowLayout,
                                  leftSectionInset: CGFloat,
                                  rightSectionInset: CGFloat,
                                  minimumLineSpacing: CGFloat? = nil)
    {
        collectionViewFlowLayout.sectionInset.left = leftSectionInset
        collectionViewFlowLayout.sectionInset.right = rightSectionInset
        if minimumLineSpacing != nil {
            collectionViewFlowLayout.minimumLineSpacing = minimumLineSpacing!
        }
    }
    
    // Table View
    static func setDesignOn(tableView: UITableView,
                            backgroundColor: UIColor,
                            separatorStyle: UITableViewCell.SeparatorStyle,
                            showVerticalScrollIndicator: Bool,
                            separatorColor: UIColor? = nil,
                            rowHeight: CGFloat? = nil,
                            keyboardDismissMode: UITableView.KeyboardDismissMode? = nil,
                            isHidden: Bool? = nil)
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
        if keyboardDismissMode != nil {
            tableView.keyboardDismissMode = keyboardDismissMode!
        }
        if isHidden != nil {
            if isHidden! {
                tableView.isHidden = true
            }
        }
    }
    
    // Table View Cell
    static func setDesignOn(cell: UITableViewCell, selectionStyle: UITableViewCell.SelectionStyle) {
        cell.selectionStyle = selectionStyle
    }
    
    // Animation
    static func animate(button: UIButton? = nil, view: UIView? = nil) {
        if button != nil {
            UIView.animate(withDuration: 0.2) {
                button!.alpha = 0.4
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                UIView.animate(withDuration: 0.2) {
                    button!.alpha = 1
                }
            }
        }
        if view != nil {
            UIView.animate(withDuration: 0.2) {
                view!.alpha = 0.4
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                UIView.animate(withDuration: 0.2) {
                    view!.alpha = 1
                }
            }
        }
    }
    
    static func dismiss(_ cropViewController: CropViewController) {
        let viewController = cropViewController.children.first!
        viewController.modalTransitionStyle = .coverVertical
        viewController.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    static func transition(from view: UIView? = nil,
                           to viewController: String,
                           onStoryboard storyboard: String,
                           canAccessDestinationProperties: Bool) -> UIViewController?
    {
        let storyboard = UIStoryboard(name: storyboard, bundle: nil)
        if canAccessDestinationProperties {
            let destinationVC = storyboard.instantiateViewController(identifier: viewController)
            return destinationVC
        } else {
            let destinationVC = storyboard.instantiateViewController(identifier: viewController)
            view!.window?.rootViewController = destinationVC
            view!.window?.makeKeyAndVisible()
        }
        return nil
    }
    
    
    //MARK: - Error Handlers
    
    static func showAlert(alertTitle: String,
                          alertMessage: String,
                          alertActionTitle1: String,
                          alertActionTitle2: String? = nil,
                          forSingleActionTitleWillItUseHandler: Bool? = nil,
                          completion: @escaping () -> Void) -> UIAlertController?
    {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        if forSingleActionTitleWillItUseHandler != nil {
            if forSingleActionTitleWillItUseHandler! {
                let alertAction1 = UIAlertAction(title: alertActionTitle1, style: .default) { (alertAction) in
                    completion()
                }
                alert.addAction(alertAction1)
                return alert
            } else {
                let alertAction1 = UIAlertAction(title: alertActionTitle1, style: .cancel)
                alert.addAction(alertAction1)
                return alert
            }
        }
        if alertActionTitle2 != nil {
            let alertAction1 = UIAlertAction(title: alertActionTitle1, style: .default) { (alertAction) in
                completion()
            }
            let alertAction2 = UIAlertAction(title: alertActionTitle2, style: .cancel)
            alert.addAction(alertAction1)
            alert.addAction(alertAction2)
            return alert
        }
        return nil
    }
    
    static func showWarningLabel(on label: UILabel,
                                 with error: Error? = nil,
                                 customizedWarning: String? = nil,
                                 isASuccessMessage: Bool)
    {
        if error != nil {
            label.text = error!.localizedDescription
        }
        if customizedWarning != nil {
            label.text = customizedWarning
        }
        if isASuccessMessage {
            setDesignOn(label: label, fontName: Strings.defaultFontBold, fontSize: 15, numberofLines: 0, textAlignment: .center, lineBreakMode: .byWordWrapping, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), backgroundColor: #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1))
        } else {
            setDesignOn(label: label, fontName: Strings.defaultFontBold, fontSize: 15, numberofLines: 0, textAlignment: .center, lineBreakMode: .byWordWrapping, fontColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), backgroundColor: #colorLiteral(red: 0.9673412442, green: 0.0823205933, blue: 0.006666854955, alpha: 1))
        }
        UIView.animate(withDuration: 0.2) {
            label.isHidden = false
        }
    }
    
}
