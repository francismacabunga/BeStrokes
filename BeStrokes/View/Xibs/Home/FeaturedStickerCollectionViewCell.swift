//
//  FeaturedCollectionViewCell.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 12/5/20.
//

import UIKit
import SkeletonView
import Firebase
import Kingfisher

class FeaturedStickerCollectionViewCell: UICollectionViewCell {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var featuredStickerContentView: UIView!
    @IBOutlet weak var featuredStickerLabel: UILabel!
    @IBOutlet weak var featuredStickerHeartButtonImageView: UIImageView!
    @IBOutlet weak var featuredStickerTryMeButton: UIButton!
    @IBOutlet weak var featuredStickerImageView: UIImageView!
    
    
    //MARK: - Constants / Variables
    
    private let heartButtonLogic = HeartButtonLogic()
    private var stickerID: String?
    private var heartButtonTapped: Bool?
    var featuredStickerCellDelegate: FeaturedStickerCellDelegate?
    
    var featuredStickerViewModel: FeaturedStickerViewModel! {
        didSet {
            stickerID = featuredStickerViewModel.stickerID
            featuredStickerLabel.text = featuredStickerViewModel.name
            featuredStickerImageView.kf.setImage(with: URL(string: featuredStickerViewModel.image))
        }
    }
    
    
    //MARK: - NIB Functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        showLoadingSkeletonView()
        registerGestures()
        
    }
    
    override func prepareForReuse() {
        featuredStickerHeartButtonImageView.image = nil
    }
    
    
    //MARK: - Design Elements
    
    func setDesignElements() {
        Utilities.setDesignOn(view: featuredStickerContentView, backgroundColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), isCircular: true, setCustomCircleCurve: 40)
        Utilities.setDesignOn(label: featuredStickerLabel, font: Strings.defaultFontBold, fontSize: 25, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), numberofLines: 0, lineBreakMode: .byWordWrapping, canResize: false)
        Utilities.setDesignOn(button: featuredStickerTryMeButton, title: Strings.tryMeButtonText, font: Strings.defaultFontBold, fontSize: 15, titleColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), isCircular: true)
        Utilities.setDesignOn(imageView: featuredStickerImageView)
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
    
    func prepareFeatureCollectionViewCell() {
        hideLoadingSkeletonView()
        setDesignElements()
        getHeartButtonValue(using: stickerID!)
    }
    
    func getHeartButtonValue(using stickerDocumentID: String) {
        heartButtonLogic.checkIfStickerIsLoved(using: stickerDocumentID) { [self] (error, userAuthenticationState, isStickerLoved) in
            if error != nil {
                featuredStickerCellDelegate?.getError(using: error!)
                return
            }
            guard let userAuthenticationState = userAuthenticationState else {return}
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
//            heartButtonLogic.untapHeartButton(using: stickerID!) { [self] (error, userAuthenticationState) in
//                if error != nil {
//                    featuredStickerCellDelegate?.getError(using: error!)
//                    return
//                }
//                guard let userAuthenticationState = userAuthenticationState else {return}
//                if !userAuthenticationState {
//                    featuredStickerCellDelegate?.getUserAuthenticationState(with: userAuthenticationState)
//                    return
//                }
//            }
        } else {
            let stickerDataDictionary = [Strings.stickerIDField : featuredStickerViewModel.stickerID,
                                         Strings.stickerNameField : featuredStickerViewModel.name,
                                         Strings.stickerImageField : featuredStickerViewModel.image,
                                         Strings.stickerDescriptionField : featuredStickerViewModel.description,
                                         Strings.stickerCategoryField : featuredStickerViewModel.category,
                                         Strings.stickerTagField : featuredStickerViewModel.tag]
//            heartButtonLogic.tapHeartButton(using: stickerID!, with: stickerDataDictionary) { [self] (error, userAuthenticationState) in
//                if error != nil {
//                    featuredStickerCellDelegate?.getError(using: error!)
//                    return
//                }
//                guard let userAuthenticationState = userAuthenticationState else {return}
//                if !userAuthenticationState {
//                    featuredStickerCellDelegate?.getUserAuthenticationState(with: userAuthenticationState)
//                    return
//                }
//            }
        }
    }
    
    
    //MARK: - Buttons
    
    @IBAction func featuredTryMeButton(_ sender: UIButton) {
        
    }
    
}


//MARK: - Protocols

protocol FeaturedStickerCellDelegate {
    func getError(using error: Error)
    func getUserAuthenticationState(with isUserSignedIn: Bool)
}







