//
//  FeaturedStickerCollectionViewCell.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 12/5/20.
//

import UIKit
import SkeletonView
import Kingfisher

class FeaturedStickerCollectionViewCell: UICollectionViewCell {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var featuredStickerContentView: UIView!
    @IBOutlet weak var featuredStickerView: UIView!
    @IBOutlet weak var featuredStickerLabel: UILabel!
    @IBOutlet weak var featuredStickerHeartButtonImageView: UIImageView!
    @IBOutlet weak var featuredStickerImageView: UIImageView!
    @IBOutlet weak var featuredStickerTryMeButton: UIButton!
    
    
    //MARK: - Constants / Variables
    
    private let stickerData = StickerData()
    private let heartButtonLogic = HeartButtonLogic()
    private var heartButtonTapped: Bool?
    private var skeletonColor: UIColor?
    var featuredStickerCellDelegate: FeaturedStickerCellDelegate?
    var featuredStickerViewModel: FeaturedStickerViewModel? {
        didSet {
            guard let featuredStickerData = featuredStickerViewModel else {return}
            featuredStickerLabel.text = featuredStickerData.name
            featuredStickerImageView.kf.setImage(with: URL(string: featuredStickerData.image))
            getHeartButtonValue(from: featuredStickerData.stickerID)
        }
    }
    
    
    //MARK: - NIB Functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setSkeletonColor()
        showLoadingSkeletonView()
        
    }
    
    override func prepareForReuse() {
        featuredStickerHeartButtonImageView.image = nil
    }
    
    
    //MARK: - Design Elements
    
    func setDesignElements() {
        Utilities.setDesignOn(view: featuredStickerContentView, backgroundColor: .clear)
        Utilities.setDesignOn(view: featuredStickerView, backgroundColor: .clear, isCircular: true, setCustomCircleCurve: 40)
        Utilities.setDesignOn(label: featuredStickerLabel, fontName: Strings.defaultFontBold, fontSize: 25, numberofLines: 0, lineBreakMode: .byWordWrapping, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), canResize: false)
        Utilities.setDesignOn(button: featuredStickerTryMeButton, title: Strings.tryMeButtonText, fontName: Strings.defaultFontBold, fontSize: 15, isCircular: true)
        NotificationCenter.default.addObserver(self, selector: #selector(setLightMode), name: Utilities.setLightModeAppearance, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setDarkMode), name: Utilities.setDarkModeAppearance, object: nil)
        checkThemeAppearance()
    }
    
    func checkThemeAppearance() {
        if UserDefaults.standard.bool(forKey: Strings.lightModeKey) {
            setLightMode()
        } else {
            setDarkMode()
        }
    }
    
    @objc func setLightMode() {
        UIView.animate(withDuration: 0.3) { [self] in
            Utilities.setDesignOn(view: featuredStickerView, backgroundColor: .white)
            Utilities.setShadowOn(view: featuredStickerView, isHidden: false, shadowColor: #colorLiteral(red: 0.6948884352, green: 0.6939979255, blue: 0.7095529112, alpha: 1), shadowOpacity: 1, shadowOffset: .zero, shadowRadius: 2)
            Utilities.setShadowOn(button: featuredStickerTryMeButton, isHidden: false, shadowColor: #colorLiteral(red: 0.6948884352, green: 0.6939979255, blue: 0.7095529112, alpha: 1), shadowOpacity: 1, shadowOffset: .zero, shadowRadius: 2)
            Utilities.setDesignOn(button: featuredStickerTryMeButton, titleColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), backgroundColor: .white)
        }
    }
    
    @objc func setDarkMode() {
        UIView.animate(withDuration: 0.3) { [self] in
            Utilities.setDesignOn(view: featuredStickerView, backgroundColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1))
            Utilities.setShadowOn(view: featuredStickerView, isHidden: true)
            Utilities.setShadowOn(button: featuredStickerTryMeButton, isHidden: true)
            Utilities.setDesignOn(button: featuredStickerTryMeButton, titleColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        }
    }
    
    func setSkeletonColor() {
        if UserDefaults.standard.bool(forKey: Strings.lightModeKey) {
            skeletonColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1)
        } else {
            skeletonColor = #colorLiteral(red: 0.2006691098, green: 0.200709641, blue: 0.2006634176, alpha: 1)
        }
    }
    
    func showLoadingSkeletonView() {
        DispatchQueue.main.async { [self] in
            featuredStickerView.isSkeletonable = true
            Utilities.setDesignOn(view: featuredStickerView, isSkeletonCircular: true, setCustomSkeletonCircleCurve: 40)
            featuredStickerView.showSkeleton(usingColor: skeletonColor!, transition: .crossDissolve(0.3))
            featuredStickerView.showAnimatedSkeleton()
        }
    }
    
    func hideLoadingSkeletonView() {
        featuredStickerView.hideSkeleton(reloadDataAfter: true, transition: SkeletonTransitionStyle.crossDissolve(0.5))
    }
    
    func getHeartButtonValue(from stickerID: String) {
        stickerData.fetchLovedSticker(on: stickerID) { [self] (error, isUserSignedIn, isStickerLoved, _) in
            if isUserSignedIn != nil {
                if !isUserSignedIn! {
                    featuredStickerCellDelegate?.getUserAuthenticationState(false)
                    return
                }
            }
            if error != nil {
                featuredStickerCellDelegate?.getError(using: error!)
                return
            }
            guard let isStickerLoved = isStickerLoved else {return}
            if isStickerLoved {
                Utilities.setDesignOn(imageView: featuredStickerHeartButtonImageView, image: UIImage(systemName: Strings.lovedStickerIcon), tintColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
                heartButtonTapped = true
            } else {
                Utilities.setDesignOn(imageView: featuredStickerHeartButtonImageView, image: UIImage(systemName: Strings.loveStickerIcon), tintColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
                heartButtonTapped = false
            }
        }
    }
    
    func prepareFeaturedStickerCell() {
        hideLoadingSkeletonView()
        setDesignElements()
        registerGestures()
    }
    
    
    //MARK: - UIGestureHandlers
    
    func registerGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler))
        featuredStickerHeartButtonImageView.addGestureRecognizer(tapGesture)
        featuredStickerHeartButtonImageView.isUserInteractionEnabled = true
    }
    
    @objc func tapGestureHandler() {
        guard let heartButtonTapped = heartButtonTapped,
              let featuredStickerViewModel = featuredStickerViewModel else {return}
        if heartButtonTapped {
            heartButtonLogic.untapHeartButton(using: featuredStickerViewModel.stickerID) { [self] (error, isUserSignedIn, _) in
                if isUserSignedIn != nil {
                    if !isUserSignedIn! {
                        featuredStickerCellDelegate?.getUserAuthenticationState(false)
                        return
                    }
                }
                if error != nil {
                    featuredStickerCellDelegate?.getError(using: error!)
                    return
                }
            }
        } else {
            heartButtonLogic.tapHeartButton(using: featuredStickerViewModel.stickerID) { [self] (error, isUserSignedIn) in
                if isUserSignedIn != nil {
                    if !isUserSignedIn! {
                        featuredStickerCellDelegate?.getUserAuthenticationState(false)
                        return
                    }
                }
                if error != nil {
                    featuredStickerCellDelegate?.getError(using: error!)
                    return
                }
            }
        }
    }
    
    
    //MARK: - Buttons
    
    @IBAction func featuredTryMeButton(_ sender: UIButton) {
        let captureVC = Utilities.transition(to: Strings.captureVC, onStoryboard: Strings.userStoryboard, canAccessDestinationProperties: true)! as! CaptureViewController
        captureVC.isStickerPicked = true
        captureVC.featuredStickerViewModel = featuredStickerViewModel
        featuredStickerCellDelegate?.getVC(using: captureVC)
    }
    
}


//MARK: - Protocols

protocol FeaturedStickerCellDelegate {
    func getError(using error: Error)
    func getUserAuthenticationState(_ isUserSignedIn: Bool)
    func getVC(using viewController: UIViewController)
}







