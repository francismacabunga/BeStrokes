//
//  StickersCollectionViewCell.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 12/5/20.
//

import UIKit
import SkeletonView
import Kingfisher
import Firebase

protocol StickerCollectionViewCellDelegate {
    func isStickerHeartButtonTapped(_ value: Bool)
}

class StickerCollectionViewCell: UICollectionViewCell {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var stickerContentView: UIView!
    @IBOutlet weak var stickerLabel: UILabel!
    @IBOutlet weak var stickerHeartButtonImageView: UIImageView!
    @IBOutlet weak var stickerImageView: UIImageView!
    
    
    //MARK: - Constants / Variables
    
    private let user = Auth.auth().currentUser
    private let db = Firestore.firestore()
    
    var stickerCollectionViewCellDelegate: StickerCollectionViewCellDelegate?
    private var heartButtonLogic = HeartButtonLogic()
    private var stickerDocumentID: String?
    private var heartButtonTapped: Bool?
    
    var stickerViewModel: StickerViewModel! {
        didSet {
            stickerDocumentID = stickerViewModel.stickerDocumentID
            stickerLabel.text = stickerViewModel.name
            stickerImageView.kf.setImage(with: stickerViewModel.image.absoluteURL)
        }
    }
    
    
    //MARK: - NIB Functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        showLoadingSkeletonView()
        registerGestures()
        
    }
    
    override func prepareForReuse() {
        stickerHeartButtonImageView.image = nil
    }
    
    
    //MARK: - Design Elements
    
    func setDesignOnElements() {
        
        stickerContentView.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1)
        stickerContentView.layer.cornerRadius = 30
        stickerContentView.clipsToBounds = true
        
        stickerLabel.numberOfLines = 1
        stickerLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        stickerLabel.font = UIFont(name: "Futura-Bold", size: 15)
        stickerLabel.adjustsFontSizeToFitWidth = true
        stickerLabel.minimumScaleFactor = 0.8
        stickerLabel.textAlignment = .left
        
        stickerImageView.contentMode = .scaleAspectFit
        
    }
    
    func showLoadingSkeletonView() {
        DispatchQueue.main.async { [self] in
            stickerContentView.isSkeletonable = true
            stickerContentView.skeletonCornerRadius = 30
            stickerContentView.showAnimatedSkeleton()
        }
    }
    
    func hideLoadingSkeletonView() {
        stickerContentView.hideSkeleton(reloadDataAfter: true, transition: SkeletonTransitionStyle.crossDissolve(0.5))
    }
    
    func setHeartButtonValue(using value: String) {
        stickerHeartButtonImageView.image = UIImage(systemName: value)
        stickerHeartButtonImageView.tintColor = .black
    }
    
    func prepareStickerCollectionViewCell() {
        hideLoadingSkeletonView()
        setDesignOnElements()
        showHeartButtonValue(using: stickerDocumentID!)
    }
    
    func showHeartButtonValue(using stickerDocumentID: String) {
        heartButtonLogic.checkIfStickerLiked(using: stickerDocumentID) { [self] (result) in
            if result {
                setHeartButtonValue(using: "heart.fill")
                stickerCollectionViewCellDelegate?.isStickerHeartButtonTapped(true)
                heartButtonTapped = true
            } else {
                setHeartButtonValue(using: "heart")
                stickerCollectionViewCellDelegate?.isStickerHeartButtonTapped(false)
                heartButtonTapped = false
            }
        }
    }
    
    
    //MARK: - UIGestureHandlers
    
    func registerGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler))
        stickerHeartButtonImageView.addGestureRecognizer(tapGesture)
        stickerHeartButtonImageView.isUserInteractionEnabled = true
    }
    
    @objc func tapGestureHandler() {
        
        if heartButtonTapped! {
            heartButtonLogic.removeUserData(using: stickerDocumentID!)
        } else {
            heartButtonLogic.saveUserData(using: stickerDocumentID!)
        }
        
    }
    
}
