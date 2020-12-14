//
//  StickersCollectionViewCell.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 12/5/20.
//

import UIKit
import SkeletonView

class StickersCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var stickerContentView: UIView!
    @IBOutlet weak var stickerLabel: UILabel!
    @IBOutlet weak var stickerOptionButtonLabel: UIButton!
    @IBOutlet weak var stickerImageView: UIImageView!
    
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
        stickerLabel.minimumScaleFactor = 0.9
        stickerLabel.font = UIFont(name: "Futura-Bold", size: 15)
        stickerLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
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
        
        DispatchQueue.main.async { [self] in
            stickerContentView.hideSkeleton(reloadDataAfter: false, transition: .crossDissolve(0.1))
        }
        
        DispatchQueue.main.async() { [self] in
    
         
                designElements()
            
            
            
            stickerLabel.text = data.name
            stickerImageView.image = UIImage(data: data.image)
        }
        
        
    }
    
    
    
    
    
    
    
    
    @IBAction func stickersOptionButton(_ sender: UIButton) {
        
    }
    
}
