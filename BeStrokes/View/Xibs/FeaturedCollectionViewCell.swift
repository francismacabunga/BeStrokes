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

protocol FeaturedCollectionViewCellDelegate {
    func isFeaturedHeartButtonTapped(value: Bool)
}

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
    
    var featuredCollectionViewCellDelegate: FeaturedCollectionViewCellDelegate?
    private var heartButtonLogic = HeartButtonLogic()
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
    
    func setDesignOnElements() {
        
        featuredContentView.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1)
        featuredContentView.layer.cornerRadius = 40
        featuredContentView.clipsToBounds = true
        
        featuredLabel.numberOfLines = 0
        featuredLabel.lineBreakMode = .byWordWrapping
        featuredLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        featuredLabel.font = UIFont(name: "Futura-Bold", size: 25)
        
        featuredTryMeButtonLabel.setTitle("Try me", for: .normal)
        featuredTryMeButtonLabel.layer.cornerRadius = featuredTryMeButtonLabel.bounds.height / 2
        featuredTryMeButtonLabel.clipsToBounds = true
        featuredTryMeButtonLabel.titleLabel?.font = UIFont(name: "Futura-Bold", size: 15)
        featuredTryMeButtonLabel.setTitleColor(#colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), for: .normal)
        featuredTryMeButtonLabel.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        featuredImageView.contentMode = .scaleAspectFit
        
    }
    
    func showLoadingSkeletonView() {
        DispatchQueue.main.async { [self] in
            featuredContentView.isSkeletonable = true
            featuredContentView.skeletonCornerRadius = 40
            featuredContentView.showAnimatedSkeleton()
        }
    }
    
    func hideLoadingSkeletonView() {
        featuredContentView.hideSkeleton(reloadDataAfter: true, transition: SkeletonTransitionStyle.crossDissolve(0.5))
    }
    
    func setHeartButtonValue(using value: String) {
        featuredHeartButtonImageView.image = UIImage(systemName: value)
        featuredHeartButtonImageView.tintColor = .black
    }
    
    func prepareFeatureCollectionViewCell() {
        hideLoadingSkeletonView()
        setDesignOnElements()
        showHeartButtonValue(using: stickerDocumentID!)
    }
    
    func showHeartButtonValue(using stickerDocumentID: String) {
        heartButtonLogic.checkIfStickerLiked(using: stickerDocumentID) { [self] (result) in
            if result {
                setHeartButtonValue(using: "heart.fill")
                featuredCollectionViewCellDelegate?.isFeaturedHeartButtonTapped(value: true)
                heartButtonTapped = true
            } else {
                setHeartButtonValue(using: "heart")
                featuredCollectionViewCellDelegate?.isFeaturedHeartButtonTapped(value: false)
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









