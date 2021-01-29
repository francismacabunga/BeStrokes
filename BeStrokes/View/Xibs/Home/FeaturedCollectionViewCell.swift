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

class FeaturedCollectionViewCell: UICollectionViewCell {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var featuredContentView: UIView!
    @IBOutlet weak var featuredLabel: UILabel!
    @IBOutlet weak var featuredHeartButtonImageView: UIImageView!
    @IBOutlet weak var featuredTryMeButton: UIButton!
    @IBOutlet weak var featuredImageView: UIImageView!
    
    
    //MARK: - Constants / Variables
    
    private let user = Auth.auth().currentUser
    private let db = Firestore.firestore()
    
    private let heartButtonLogic = HeartButtonLogic()
    private var stickerID: String?
    private var heartButtonTapped: Bool?
    
    var featuredStickerViewModel: FeaturedStickerViewModel! {
        didSet {
            stickerID = featuredStickerViewModel.stickerID
            featuredLabel.text = featuredStickerViewModel.name
            featuredImageView.kf.setImage(with: URL(string: featuredStickerViewModel.image))
        }
    }
    
    
    //MARK: - NIB Functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        showLoadingSkeletonView()
        registerGestures()
        
    }
    
    override func prepareForReuse() {
        featuredHeartButtonImageView.image = nil
    }
    
    
    //MARK: - Design Elements
    
    func setDesignElements() {
        Utilities.setDesignOn(view: featuredContentView, backgroundColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), isCircular: true, setCustomCircleCurve: 40)
        Utilities.setDesignOn(label: featuredLabel, font: Strings.defaultFontBold, fontSize: 25, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), numberofLines: 0, lineBreakMode: .byWordWrapping, canResize: false)
        Utilities.setDesignOn(button: featuredTryMeButton, title: Strings.tryMeButtonText, font: Strings.defaultFontBold, fontSize: 15, titleColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), isCircular: true)
        Utilities.setDesignOn(imageView: featuredImageView)
    }
    
    func showLoadingSkeletonView() {
        DispatchQueue.main.async { [self] in
            featuredContentView.isSkeletonable = true
            Utilities.setDesignOn(view: featuredContentView, isSkeletonCircular: true, setCustomSkeletonCircleCurve: 40)
            featuredContentView.showAnimatedSkeleton()
        }
    }
    
    func hideLoadingSkeletonView() {
        featuredContentView.hideSkeleton(reloadDataAfter: true, transition: SkeletonTransitionStyle.crossDissolve(0.5))
    }
    
    func prepareFeatureCollectionViewCell() {
        hideLoadingSkeletonView()
        setDesignElements()
        getHeartButtonValue(using: stickerID!)
    }
    
    func getHeartButtonValue(using stickerDocumentID: String) {
        heartButtonLogic.checkIfStickerIsLoved(using: stickerDocumentID) { [self] (error, isUserSignedIn, isStickerLoved) in
            if error != nil {
                // Show error
                return
            }
            guard let isUserSignedIn = isUserSignedIn else {return}
            if !isUserSignedIn {
                // Show error
                return
            }
            guard let isStickerLoved = isStickerLoved else {return}
            if isStickerLoved {
                Utilities.setDesignOn(imageView: featuredHeartButtonImageView, image: UIImage(systemName: Strings.lovedStickerIcon), tintColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
                heartButtonTapped = true
            } else {
                Utilities.setDesignOn(imageView: featuredHeartButtonImageView, image: UIImage(systemName: Strings.loveStickerIcon), tintColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
                heartButtonTapped = false
            }
        }
    }
    
    
    //MARK: - UIGestureHandlers
    
    func registerGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler))
        featuredHeartButtonImageView.addGestureRecognizer(tapGesture)
        featuredHeartButtonImageView.isUserInteractionEnabled = true
    }
    
    @objc func tapGestureHandler() {
        if heartButtonTapped! {
            heartButtonLogic.untapHeartButton(using: stickerID!) { (error, isUserSignedIn) in
                if error != nil {
                    // Show error
                    return
                }
                guard let isUserSignedIn = isUserSignedIn else {return}
                if !isUserSignedIn {
                    // Show error
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
            heartButtonLogic.tapHeartButton(using: stickerID!, with: stickerDataDictionary) { (error, isUserSignedIn) in
                if error != nil {
                    // Show error
                    return
                }
                guard let isUserSignedIn = isUserSignedIn else {return}
                if !isUserSignedIn {
                    // Show error
                    return
                }
            }
        }
    }
    
    
    //MARK: - Buttons
    
    @IBAction func featuredTryMeButton(_ sender: UIButton) {
        
    }
    
}









