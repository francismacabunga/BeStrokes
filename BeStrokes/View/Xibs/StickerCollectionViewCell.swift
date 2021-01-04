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

class StickerCollectionViewCell: UICollectionViewCell {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var stickerContentView: UIView!
    @IBOutlet weak var stickerLabel: UILabel!
    @IBOutlet weak var stickerHeartButtonLabel: UIButton!
    @IBOutlet weak var stickerImageView: UIImageView!

    
    //MARK: - Constants / Variables
    
    private let user = Auth.auth().currentUser
    private let db = Firestore.firestore()
    
    private var heartButtonLogic = HeartButtonLogic()
    private var isHeartButtonTapped: Bool?
    private var stickerDocumentID: String?
 
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
        
    }
    
    override func prepareForReuse() {
        stickerHeartButtonLabel.setBackgroundImage(nil, for: .normal)
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
        stickerContentView.hideSkeleton(reloadDataAfter: false, transition: .crossDissolve(0.1))
    }
    
    func setHeartButtonValue(using value: String) {
        stickerHeartButtonLabel.setTitle("", for: .normal)
        stickerHeartButtonLabel.setBackgroundImage(UIImage(systemName: value), for: .normal)
        stickerHeartButtonLabel.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }
    
    func prepareStickerCollectionViewCell() {
        hideLoadingSkeletonView()
        setDesignOnElements()
        
        if stickerDocumentID != nil {
            showHeartButtonValue(using: stickerDocumentID!)
        }
        
    }
    
    func showHeartButtonValue(using stickerDocumentID: String) {
        heartButtonLogic.checkIfStickerLiked(using: stickerDocumentID) { [self] (result) in
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
    
    @IBAction func stickerHeartButton(_ sender: UIButton) {
        
        guard let stickerDocumentID = stickerDocumentID else {return}
    
        if !isHeartButtonTapped! {
            heartButtonLogic.saveUserData(using: stickerDocumentID)
        } else {
            heartButtonLogic.removeUserData(using: stickerDocumentID)
        }
        
    }
    
}
