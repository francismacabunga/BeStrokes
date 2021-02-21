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
    @IBOutlet weak var featuredStickerTryMeButton: UIButton!
    @IBOutlet weak var featuredStickerImageView: UIImageView!
    
    
    //MARK: - Constants / Variables
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let heartButtonLogic = HeartButtonLogic()
    private var heartButtonTapped: Bool?
    private var skeletonColor: UIColor?
    var featuredStickerCellDelegate: FeaturedStickerCellDelegate?
    var featuredStickerViewModel: FeaturedStickerViewModel! {
        didSet {
            featuredStickerLabel.text = featuredStickerViewModel.name
            featuredStickerImageView.kf.setImage(with: URL(string: featuredStickerViewModel.image))
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
        Utilities.setDesignOn(view: featuredStickerView, isCircular: true, setCustomCircleCurve: 40)
        Utilities.setDesignOn(label: featuredStickerLabel, fontName: Strings.defaultFontBold, fontSize: 25, numberofLines: 0, lineBreakMode: .byWordWrapping, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), canResize: false)
        Utilities.setDesignOn(button: featuredStickerTryMeButton, title: Strings.tryMeButtonText, font: Strings.defaultFontBold, fontSize: 15, isCircular: true)
        Utilities.setDesignOn(imageView: featuredStickerImageView)
        NotificationCenter.default.addObserver(self, selector: #selector(setLightMode), name: Utilities.setLightModeAppearance, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setDarkMode), name: Utilities.setDarkModeAppearance, object: nil)
        checkThemeAppearance()
    }
    
    func checkThemeAppearance() {
        if appDelegate.isLightModeOn {
            setLightMode()
        } else {
            setDarkMode()
        }
    }
    
    @objc func setLightMode() {
        UIView.animate(withDuration: 0.3) { [self] in
            featuredStickerContentView.backgroundColor = .white
            featuredStickerView.backgroundColor = .white
            
            featuredStickerView.layer.shadowColor = #colorLiteral(red: 0.6948884352, green: 0.6939979255, blue: 0.7095529112, alpha: 1)
            featuredStickerView.layer.shadowOpacity = 1
            featuredStickerView.layer.shadowOffset = .zero
            featuredStickerView.layer.shadowRadius = 2
            featuredStickerView.layer.masksToBounds = false
            
            featuredStickerTryMeButton.layer.shadowColor = #colorLiteral(red: 0.6948884352, green: 0.6939979255, blue: 0.7095529112, alpha: 1)
            featuredStickerTryMeButton.layer.shadowOpacity = 1
            featuredStickerTryMeButton.layer.shadowOffset = .zero
            featuredStickerTryMeButton.layer.shadowRadius = 2
            featuredStickerTryMeButton.layer.masksToBounds = false
            
            Utilities.setDesignOn(button: featuredStickerTryMeButton, titleColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), backgroundColor: .white)
        }
    }
    
    @objc func setDarkMode() {
        UIView.animate(withDuration: 0.3) { [self] in
            featuredStickerContentView.backgroundColor = .clear
            featuredStickerView.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1)
            
            featuredStickerView.layer.shadowColor = nil
            featuredStickerView.layer.shadowOpacity = 0
            featuredStickerView.layer.shadowOffset = .zero
            featuredStickerView.layer.shadowRadius = 0
            featuredStickerView.layer.masksToBounds = true
            
            featuredStickerTryMeButton.layer.shadowColor = nil
            featuredStickerTryMeButton.layer.shadowOpacity = 0
            featuredStickerTryMeButton.layer.shadowOffset = .zero
            featuredStickerTryMeButton.layer.shadowRadius = 0
            featuredStickerTryMeButton.layer.masksToBounds = true
            
            Utilities.setDesignOn(button: featuredStickerTryMeButton, titleColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        }
    }
    
    func setSkeletonColor() {
        if appDelegate.isLightModeOn {
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
    
    func prepareFeaturedStickerCell() {
        hideLoadingSkeletonView()
        setDesignElements()
        getHeartButtonValue(using: featuredStickerViewModel.stickerID)
        registerGestures()
    }
    
    func transitionToCaptureVC() {
        let storyboard = UIStoryboard(name: Strings.userStoryboard, bundle: nil)
        let captureVC = storyboard.instantiateViewController(identifier: Strings.captureVC) as! CaptureViewController
        captureVC.isStickerPicked = true
        captureVC.featuredStickerViewModel = featuredStickerViewModel
        featuredStickerCellDelegate?.getVC(using: captureVC)
    }
    
    func getHeartButtonValue(using stickerID: String) {
        heartButtonLogic.checkIfStickerIsLoved(using: stickerID) { [self] (error, userAuthenticationState, isStickerLoved) in
            if error != nil {
                featuredStickerCellDelegate?.getError(using: error!)
                return
            }
            if !userAuthenticationState {
                featuredStickerCellDelegate?.getUserAuthenticationState(with: userAuthenticationState)
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
    
    
    //MARK: - UIGestureHandlers
    
    func registerGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler))
        featuredStickerHeartButtonImageView.addGestureRecognizer(tapGesture)
        featuredStickerHeartButtonImageView.isUserInteractionEnabled = true
    }
    
    @objc func tapGestureHandler() {
        if heartButtonTapped! {
            heartButtonLogic.untapHeartButton(using: featuredStickerViewModel.stickerID) { [self] (error, userAuthenticationState, isProcessDone) in
                if error != nil {
                    featuredStickerCellDelegate?.getError(using: error!)
                    return
                }
                if !userAuthenticationState {
                    featuredStickerCellDelegate?.getUserAuthenticationState(with: userAuthenticationState)
                    return
                }
            }
        } else {
            let stickerDataDictionary = [Strings.stickerIDField : featuredStickerViewModel.stickerID,
                                         Strings.stickerNameField : featuredStickerViewModel.name,
                                         Strings.stickerImageField : featuredStickerViewModel.image,
                                         Strings.stickerDescriptionField : featuredStickerViewModel.description,
                                         Strings.stickerCategoryField : featuredStickerViewModel.category,
                                         Strings.stickerTagField : featuredStickerViewModel.tag]
            heartButtonLogic.tapHeartButton(using: featuredStickerViewModel.stickerID, with: stickerDataDictionary) { [self] (error, userAuthenticationState, isProcessDone) in
                if error != nil {
                    featuredStickerCellDelegate?.getError(using: error!)
                    return
                }
                if !userAuthenticationState {
                    featuredStickerCellDelegate?.getUserAuthenticationState(with: userAuthenticationState)
                    return
                }
            }
        }
    }
    
    
    //MARK: - Buttons
    
    @IBAction func featuredTryMeButton(_ sender: UIButton) {
        transitionToCaptureVC()
    }
    
}


//MARK: - Protocols

protocol FeaturedStickerCellDelegate {
    func getError(using error: Error)
    func getUserAuthenticationState(with isUserSignedIn: Bool)
    func getVC(using viewController: UIViewController)
}







