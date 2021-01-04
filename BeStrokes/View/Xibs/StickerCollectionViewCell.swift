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
    @IBOutlet weak var stickerImageView: UIImageView!
    @IBOutlet weak var stickerHeartButtonLabel: UIButton!
    
    
    //MARK: - Constants / Variables
    
    let user = Auth.auth().currentUser
    let db = Firestore.firestore()
    
    var heartButtonLogic = HeartButtonLogic()
    var isHeartButtonTapped: Bool?
    var stickerDocumentID: String?
    var connection: FeaturedCollectionViewCell?
    
    var stickerViewModel: StickerViewModel! {
        didSet {
            
            
            
            hideLoadingSkeletonView()
            putDesignOnElements()
            
            stickerDocumentID = stickerViewModel.stickerDocumentID
            stickerImageView.kf.setImage(with: stickerViewModel.image.absoluteURL)
            
            showHeartButtonValue(using: stickerDocumentID!)
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) { [self] in
                stickerLabel.text = stickerViewModel.name
            }
            
            
        }
    }
    
    
    //MARK: - NIB Functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
        showLoadingSkeletonView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        
        
        stickerContentView.isHidden = true
        stickerLabel.isHidden = true
        stickerHeartButtonLabel.setBackgroundImage(nil, for: .normal)
        stickerImageView.isHidden = true
        
    }
    
    
    //MARK: - Design Elements
    
    func putDesignOnElements() {
        
        stickerContentView.isHidden = false
        stickerContentView.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1)
        stickerContentView.layer.cornerRadius = 30
        stickerContentView.clipsToBounds = true
        
        stickerLabel.isHidden = false
        stickerLabel.textAlignment = .left
        stickerLabel.numberOfLines = 1
        stickerLabel.adjustsFontSizeToFitWidth = true
        stickerLabel.minimumScaleFactor = 0.8
        stickerLabel.font = UIFont(name: "Futura-Bold", size: 15)
        stickerLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        stickerHeartButtonLabel.isHidden = false
        stickerHeartButtonLabel.setBackgroundImage(nil, for: .normal)
        //        stickerHeartButtonLabel.setTitle("", for: .normal)
        //        stickerHeartButtonLabel.setBackgroundImage(UIImage(systemName: "heart"), for: .normal)
        //        stickerHeartButtonLabel.tintColor = .black
        
        stickerImageView.isHidden = false
        stickerImageView.contentMode = .scaleAspectFit
    }
    
    func setHeartButtonValue(using value: String) {
        
        
        
        stickerHeartButtonLabel.setTitle("", for: .normal)
        stickerHeartButtonLabel.setBackgroundImage(UIImage(systemName: value), for: .normal)
        stickerHeartButtonLabel.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        
        
        
    }
    
    func showLoadingSkeletonView() {
        DispatchQueue.main.async { [self] in
            stickerContentView.isSkeletonable = true
            stickerContentView.skeletonCornerRadius = 40
            stickerContentView.showAnimatedSkeleton()
        }
    }
    
    func hideLoadingSkeletonView() {
        stickerContentView.hideSkeleton(reloadDataAfter: false, transition: .crossDissolve(0.1))
    }
    
    func prepareStickerCollectionViewCell() {
        
        //        hideLoadingSkeletonView()
        //        putDesignOnElements()
        //        showHeartButtonValue(using: stickerDocumentID!)
        
        
        
        
        
    }
    
    
    
    func ifTrue() {
        setHeartButtonValue(using: "heart")
    }
    
    func ifFalse() {
        setHeartButtonValue(using: "heart.fill")
    }
    
    
    func showHeartButtonValue(using stickerDocumentID: String) {
        if stickerDocumentID != nil {
            heartButtonLogic.checkIfStickerLiked(using: stickerDocumentID) { [self] (result) in
                if result {
                    print(stickerDocumentID)
                    setHeartButtonValue(using: "heart.fill")
                    //                    isHeartButtonTapped = true
                } else {
                    
                    setHeartButtonValue(using: "heart")
                    //                    isHeartButtonTapped = false
                }
            }
        }
    }
    
    
    //MARK: - Buttons
    
    @IBAction func stickerHeartButton(_ sender: UIButton) {
        
        guard let tappedSticker = stickerDocumentID else {return}
        print("Tapped sticker: \(tappedSticker)")
        //
        //
        //        if !isHeartButtonTapped! {
        //            //            heartButtonLogic.saveUserData(using: stickerDocumentID)
        //            print("Not clicked")
        //            print(stickerDocumentID)
        //
        //        } else {
        //            //            heartButtonLogic.removeUserData(using: stickerDocumentID)
        //            print("Clicked")
        //            print(stickerDocumentID)
        //        }
        
        
        
        
    }
    
    
    
    
    
    
}
