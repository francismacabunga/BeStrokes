//
//  LikedStickersTableViewCell.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 1/10/21.
//

import UIKit
import SkeletonView
import Kingfisher

class LikedStickersTableViewCell: UITableViewCell {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var likedStickerContentView: UIView!
    @IBOutlet weak var likedStickerView: UIView!
    @IBOutlet weak var likedStickerHeadingLabel: UILabel!
    @IBOutlet weak var likedStickerImageView: UIImageView!
    @IBOutlet weak var likedStickerOptionImageView: UIImageView!
    @IBOutlet weak var likedStickerTryMeButton: UIButton!
    
    
    //MARK: - Constants / Variables
    
    var stickerViewModel: StickerViewModel! {
        didSet {
            likedStickerHeadingLabel.text = stickerViewModel.name
            likedStickerImageView.kf.setImage(with: stickerViewModel.image)
        }
    }
    
    
    //MARK: - NIB Funtions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        showLoadingSkeletonView()
        likedStickerHeadingLabel.text = ""
        
    }
    
    
    //MARK: - Design Elements
    
    func setDesignElements() {
        self.selectionStyle = .none
        Utilities.setDesignOn(view: likedStickerContentView, backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        Utilities.setDesignOn(view: likedStickerView, backgroundColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), setCustomCircleCurve: 30)
        Utilities.setDesignOn(label: likedStickerHeadingLabel, font: Strings.defaultFontBold, fontSize: 20, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), numberofLines: 1, textAlignment: .left, canResize: true, minimumScaleFactor: 0.8)
        Utilities.setDesignOn(button: likedStickerTryMeButton, title: Strings.tryMeButtonText, font: Strings.defaultFontBold, fontSize: 14, titleColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), isCircular: true)
        Utilities.setDesignOn(imageView: likedStickerOptionImageView, image: UIImage(named: Strings.optionImage), tintColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        Utilities.setDesignOn(imageView: likedStickerImageView)
    }
    
    func showLoadingSkeletonView() {
        DispatchQueue.main.async { [self] in
            Utilities.setDesignOn(view: contentView, backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
            likedStickerView.isSkeletonable = true
            Utilities.setDesignOn(view: likedStickerView, isSkeletonCircular: true, setCustomSkeletonCircleCurve: 30)
            likedStickerView.showAnimatedSkeleton()
        }
    }
    
    func hideLoadingSkeletonView() {
        likedStickerView.hideSkeleton(reloadDataAfter: true, transition: SkeletonTransitionStyle.crossDissolve(0.5))
    }
    
    func prepareLikedStickerCollectionViewCell() {
        hideSkeleton()
        setDesignElements()
    }
    
}
