//
//  Utilities.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 11/17/20.
//

import Foundation
import UIKit

struct Utilities {
    
    //MARK: - Design Elements
    
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
                            backgroundColor: UIColor? = nil,
                            isHidden: Bool? = nil)
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
                            font: String,
                            fontSize: CGFloat,
                            autocorrectionType: UITextAutocorrectionType,
                            isSecureTextEntry: Bool,
                            keyboardType: UIKeyboardType,
                            textContentType: UITextContentType? = nil,
                            capitalization: UITextAutocapitalizationType? = nil,
                            returnKeyType: UIReturnKeyType? = nil,
                            textColor: UIColor? = nil,
                            backgroundColor: UIColor? = nil,
                            placeholder: String? = nil,
                            placeholderTextColor: UIColor? = nil,
                            isCircular: Bool? = nil)
    {
        textField.font = UIFont(name: font, size: fontSize)
        textField.autocorrectionType = autocorrectionType
        textField.isSecureTextEntry = isSecureTextEntry
        textField.keyboardType = keyboardType
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
                            isSkeletonCircular: Bool? = nil,
                            isHidden: Bool? = nil)
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
        if isSkeletonCircular != nil {
            if isSkeletonCircular! {
                button.skeletonCornerRadius = Float(button.bounds.height / 2)
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
                            backgroundColor: UIColor,
                            isStartAnimating: Bool? = nil,
                            isHidden: Bool? = nil)
    {
        activityIndicatorView.style = size
        activityIndicatorView.color = backgroundColor
        if isStartAnimating != nil {
            if isStartAnimating! {
                activityIndicatorView.startAnimating()
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
    static func setDesign(pageControl: UIPageControl,
                          pageIndicatorColor: UIColor,
                          currentPageColor: UIColor)
    {
        pageControl.pageIndicatorTintColor = pageIndicatorColor
        pageControl.currentPageIndicatorTintColor = currentPageColor
    }
    
    // Stack View
    static func setDesignOn(stackView: UIStackView,
                            backgroundColor: UIColor,
                            isCircular: Bool? = nil,
                            isHidden: Bool? = nil)
    {
        stackView.backgroundColor = backgroundColor
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
                            isSkeletonCircular: Bool? = nil)
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
                imageView.clipsToBounds = true
                imageView.contentMode = .scaleAspectFit
            }
        }
        if isSkeletonCircular != nil {
            if isSkeletonCircular! {
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
                            rowHeight: CGFloat? = nil,
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
        if isHidden != nil {
            if isHidden! {
                tableView.isHidden = true
            }
        }
    }
    
    // Animation
    static func animate(button: UIButton? = nil, view: UIView? = nil)
    {
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
    
}










