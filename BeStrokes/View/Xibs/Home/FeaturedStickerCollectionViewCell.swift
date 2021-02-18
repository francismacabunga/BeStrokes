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
        
        showLoadingSkeletonView()
        
    }
    
    override func prepareForReuse() {
        featuredStickerHeartButtonImageView.image = nil
    }
    
    
    //MARK: - Design Elements
    
    func setDesignElements() {
        Utilities.setDesignOn(view: featuredStickerContentView, backgroundColor: .clear)
        Utilities.setDesignOn(view: featuredStickerView, isCircular: true, setCustomCircleCurve: 40)
        Utilities.setDesignOn(label: featuredStickerLabel, font: Strings.defaultFontBold, fontSize: 25, numberofLines: 0, lineBreakMode: .byWordWrapping, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), canResize: false)
        Utilities.setDesignOn(button: featuredStickerTryMeButton, title: Strings.tryMeButtonText, font: Strings.defaultFontBold, fontSize: 15, titleColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), isCircular: true)
        Utilities.setDesignOn(imageView: featuredStickerImageView)
        checkThemeAppearance()
        NotificationCenter.default.addObserver(self, selector: #selector(setLightMode), name: Utilities.setLightModeAppearance, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setDarkMode), name: Utilities.setDarkModeAppearance, object: nil)
    }
    
    func checkThemeAppearance() {
        if appDelegate.isLightModeOn {
            setLightMode()
        } else {
            setDarkMode()
        }
    }
    
    @objc func setLightMode() {
        print("Light Mode Activated - FeaturedStickerCellVC")
        UIView.animate(withDuration: 0.3) { [self] in
            featuredStickerContentView.backgroundColor = .clear
            featuredStickerView.backgroundColor = .white
            
            
            featuredStickerView.layer.shadowColor = #colorLiteral(red: 0.6948884352, green: 0.6939979255, blue: 0.7095529112, alpha: 1)
            featuredStickerView.layer.shadowOpacity = 1
            featuredStickerView.layer.shadowOffset = .zero
            featuredStickerView.layer.shadowRadius = 4
            featuredStickerView.layer.masksToBounds = false
        }
    }
    
    @objc func setDarkMode() {
        print("Dark Mode Activated - FeaturedStickerCellVC")
        UIView.animate(withDuration: 0.3) { [self] in
            featuredStickerContentView.backgroundColor = .clear
            featuredStickerView.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1)
            
            featuredStickerView.layer.shadowColor = nil
            featuredStickerView.layer.shadowOpacity = 0
            featuredStickerView.layer.shadowOffset = .zero
            featuredStickerView.layer.shadowRadius = 0
            featuredStickerView.layer.masksToBounds = true
        }
    }
    
    func showLoadingSkeletonView() {
        DispatchQueue.main.async { [self] in
            featuredStickerContentView.isSkeletonable = true
            Utilities.setDesignOn(view: featuredStickerContentView, isSkeletonCircular: true, setCustomSkeletonCircleCurve: 40)
            featuredStickerContentView.showAnimatedSkeleton()
        }
    }
    
    func hideLoadingSkeletonView() {
        featuredStickerContentView.hideSkeleton(reloadDataAfter: true, transition: SkeletonTransitionStyle.crossDissolve(0.5))
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







