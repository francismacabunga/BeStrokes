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
    func isStickerHeartButtonTapped(value: Bool)
}

class StickerCollectionViewCell: UICollectionViewCell {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var stickerContentView: UIView!
    @IBOutlet weak var stickerLabel: UILabel!
    @IBOutlet weak var stickerOption: UIImageView!
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
        stickerOption.image = nil
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
        
        stickerOption.image = UIImage(named: "Dots")
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
        stickerOption.image = UIImage(systemName: value)
        stickerOption.tintColor = .black
    }
    
    func prepareStickerCollectionViewCell() {
        hideLoadingSkeletonView()
        setDesignOnElements()
        
    }
    
    
    
    //MARK: - UIGestureHandlers
    
    func registerGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler))
        stickerOption.addGestureRecognizer(tapGesture)
        stickerOption.isUserInteractionEnabled = true
    }
    
    @objc func tapGestureHandler() {
        
       
        
    }
    
}
