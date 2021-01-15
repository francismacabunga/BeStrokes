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
    @IBOutlet weak var featuredTryMeButtonLabel: UIButton!
    @IBOutlet weak var featuredImageView: UIImageView!
    
    
    //MARK: - Constants / Variables
    
    private let user = Auth.auth().currentUser
    private let db = Firestore.firestore()
    
    private let heartButtonLogic = HeartButtonLogic()
    private var stickerDocumentID: String?
    private var heartButtonTapped: Bool?
    
    var featuredStickerViewModel: FeaturedStickerViewModel! {
        didSet {
            stickerDocumentID = featuredStickerViewModel.stickerDocumentID
            featuredLabel.text = featuredStickerViewModel.name
            featuredImageView.kf.setImage(with: featuredStickerViewModel.image.absoluteURL)
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
        Utilities.setDesignOn(view: featuredContentView, backgroundColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), isPerfectCircle: true, setCustomCircleCurve: 40)
        Utilities.setDesignOn(label: featuredLabel, font: Strings.defaultFontBold, fontSize: 25, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), numberofLines: 0, lineBreakMode: .byWordWrapping, canResize: false)
        Utilities.setDesignOn(button: featuredTryMeButtonLabel, title: Strings.tryMeButtonText, font: Strings.defaultFontBold, fontSize: 15, titleColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), isCircular: true)
        Utilities.setDesignOn(imageView: featuredImageView)
    }
    
    func showLoadingSkeletonView() {
        DispatchQueue.main.async { [self] in
            featuredContentView.isSkeletonable = true
            Utilities.setDesignOn(view: featuredContentView, isSkeletonPerfectCircle: true, setCustomCircleSkeletonCurve: 40)
            featuredContentView.showAnimatedSkeleton()
        }
    }
    
    func hideLoadingSkeletonView() {
        featuredContentView.hideSkeleton(reloadDataAfter: true, transition: SkeletonTransitionStyle.crossDissolve(0.5))
    }
    
    func prepareFeatureCollectionViewCell() {
        hideLoadingSkeletonView()
        setDesignElements()
        getHeartButtonValue(using: stickerDocumentID!)
    }
    
    func getHeartButtonValue(using stickerDocumentID: String) {
        heartButtonLogic.checkIfStickerLiked(using: stickerDocumentID) { [self] (result) in
            if result {
                Utilities.setDesignOn(imageView: featuredHeartButtonImageView, image: UIImage(systemName: Strings.heartStickerImage), tintColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
                heartButtonTapped = true
            } else {
                Utilities.setDesignOn(imageView: featuredHeartButtonImageView, image: UIImage(systemName: Strings.unheartStickerImage), tintColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
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
            heartButtonLogic.removeUserData(using: stickerDocumentID!)
        } else {
            heartButtonLogic.saveUserData(using: stickerDocumentID!)
        }
    }
    
    
    //MARK: - Buttons
    
    @IBAction func featuredTryMeButton(_ sender: UIButton) {
        
    }
    
}









