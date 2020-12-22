//
//  StickersCollectionViewCell.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 12/5/20.
//

import UIKit
import SkeletonView
import Kingfisher

protocol StickersCollectViewCellDelegate {
    func transitionToStickerOptionView(value: UIViewController)
}


class StickersCollectionViewCell: UICollectionViewCell {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var stickerContentView: UIView!
    @IBOutlet weak var stickerLabel: UILabel!
    @IBOutlet weak var stickerOptionButtonLabel: UIButton!
    @IBOutlet weak var stickerImageView: UIImageView!
    
    var stickerDelegate: StickersCollectViewCellDelegate?
    
    
    //MARK: - NIB Functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        showLoadingSkeletonView()
    }
    
    func designElements() {
        stickerContentView.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1)
        stickerContentView.layer.cornerRadius = 30
        stickerContentView.clipsToBounds = true
        stickerLabel.textAlignment = .left
        stickerLabel.numberOfLines = 1
        stickerLabel.adjustsFontSizeToFitWidth = true
        stickerLabel.minimumScaleFactor = 0.8
        stickerLabel.font = UIFont(name: "Futura-Bold", size: 15)
        stickerLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        stickerOptionButtonLabel.isHidden = false
        stickerOptionButtonLabel.setTitle("...", for: .normal)
        stickerOptionButtonLabel.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        stickerOptionButtonLabel.titleLabel?.font = UIFont(name: "Futura-Bold", size: 20)
        stickerImageView.contentMode = .scaleAspectFit
    }
    
    func showLoadingSkeletonView() {
        DispatchQueue.main.async { [self] in
            stickerContentView.isSkeletonable = true
            stickerContentView.skeletonCornerRadius = 40
            stickerContentView.showAnimatedSkeleton()
        }
    }
    
    func setData(with data: StickerData) {
        
        let stickerLabel = data.name
        let stickerImage = data.image
        
        //        DispatchQueue.main.async() { [self] in
        hideLoadingSkeletonView()
        designElements()
        setStikcerLabelAndImage(with: stickerLabel, stickerImage)
        //        }
        
        
        
    }
    
    let cache = NSCache<AnyObject,AnyObject>()
    
    
    func setStikcerLabelAndImage(with name: String, _ imageURL: URL) {
        
        stickerLabel.text = name
        stickerImageView.kf.setImage(with: imageURL.absoluteURL)
        
        
        
        
        
    }
    
    
    
    
    func hideLoadingSkeletonView() {
        stickerContentView.hideSkeleton(reloadDataAfter: false, transition: .crossDissolve(0.1))
    }
    
    
    
    @IBAction func stickersOptionButton(_ sender: UIButton) {
        
        let sample = "hello u!"
        
        
        let destinationVC = StickerOptionViewController()
        


        stickerDelegate?.transitionToStickerOptionView(value: destinationVC)
        
    }
    
    
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        stickerLabel.text = nil
        stickerImageView.image = nil
        stickerOptionButtonLabel.isHidden = true
        
    }
    
}
