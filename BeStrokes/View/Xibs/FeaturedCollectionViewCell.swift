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
    @IBOutlet weak var featuredHeartButtonLabel: UIButton!
    @IBOutlet weak var featuredTryMeButtonLabel: UIButton!
    @IBOutlet weak var featuredImageView: UIImageView!
    
    
    //MARK: - Constants / Variables
    
    private let user = Auth.auth().currentUser
    private let db = Firestore.firestore()
    private var featuredStickerDocumentID: String?
    private var isHeartButtonTapped: Bool?
    var stickerViewModel: StickerViewModel! {
        didSet {
            featuredStickerDocumentID = stickerViewModel.stickerDocumentID
            featuredLabel.text = stickerViewModel.name
            featuredImageView.kf.setImage(with: stickerViewModel.image.absoluteURL)
        }
    }
    
    
    //MARK: - NIB Functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        showLoadingSkeletonView()
    }
    
    override func prepareForReuse() {
        featuredHeartButtonLabel.setBackgroundImage(nil, for: .normal)
    }
    
    
    //MARK: - Design Elements
    
    func putDesignOnElements() {
        
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
    
    func setHeartButtonValue(using value: String) {
        featuredHeartButtonLabel.setTitle("", for: .normal)
        featuredHeartButtonLabel.setBackgroundImage(UIImage(systemName: value), for: .normal)
        featuredHeartButtonLabel.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    func showLoadingSkeletonView() {
        DispatchQueue.main.async { [self] in
            featuredContentView.isSkeletonable = true
            featuredContentView.skeletonCornerRadius = 40
            featuredContentView.showAnimatedSkeleton()
        }
    }
    
    func hideLoadingSkeletonView() {
        featuredContentView.hideSkeleton(reloadDataAfter: false, transition: SkeletonTransitionStyle.crossDissolve(0.1))
    }
    
    func prepareFeatureCollectionViewCell() {
        
        hideLoadingSkeletonView()
        putDesignOnElements()
        
        stickerViewModel.isStickerLiked { [self] (result) in
            if result {
                setHeartButtonValue(using: "heart.fill")
                isHeartButtonTapped = true
            } else {
                setHeartButtonValue(using: "heart")
                isHeartButtonTapped = false
            }
        }
    }
    
    
    //MARK: - Buttons
    
    @IBAction func featuredHeartButton(_ sender: UIButton) {
        
        if !isHeartButtonTapped! {
            stickerViewModel.saveUserData()
            setHeartButtonValue(using: "heart.fill")
        } else {
            stickerViewModel.removeUserData()
            setHeartButtonValue(using: "heart")
        }
    }
    
    @IBAction func featuredTryMeButton(_ sender: UIButton) {
        
    }
    
}









