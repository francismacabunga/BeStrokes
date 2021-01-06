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
    func getVC(of viewController: UIViewController)
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
        
    }
    
    override func prepareForReuse() {
        stickerOption.image = nil
    }
    
    
    //MARK: - Design Elements
    
    func setDesignOnElements() {
        Utilities.setDesignOn(view: stickerContentView, color: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), amountOfCurve: 30)
        Utilities.setDesignOn(stickerLabel, font: Strings.defaultFontBold, fontSize: 15, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), textAlignment: .left, numberofLines: 1, canResize: true, minimumScaleFactor: 0.8)
        Utilities.setDesignOn(imageView: stickerOption, image: UIImage(named: Strings.optionImage))
        Utilities.setDesignOn(imageView: stickerImageView)
    }
    
    func showLoadingSkeletonView() {
        DispatchQueue.main.async { [self] in
            stickerContentView.isSkeletonable = true
            Utilities.setDesignOn(view: stickerContentView, isCircularSkeleton: true, circularSkeletonCurve: 30)
            stickerContentView.showAnimatedSkeleton()
        }
    }
    
    func hideLoadingSkeletonView() {
        stickerContentView.hideSkeleton(reloadDataAfter: true, transition: SkeletonTransitionStyle.crossDissolve(0.5))
    }
    
    func prepareStickerCollectionViewCell() {
        hideLoadingSkeletonView()
        setDesignOnElements()
    }
    
}
