//
//  LovedStickerTableViewCell.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 1/10/21.
//

import UIKit
import SkeletonView
import Kingfisher

class LovedStickerTableViewCell: UITableViewCell {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var lovedStickerContentView: UIView!
    @IBOutlet weak var lovedStickerView: UIView!
    @IBOutlet weak var lovedStickerHeadingLabel: UILabel!
    @IBOutlet weak var lovedStickerImageView: UIImageView!
    @IBOutlet weak var lovedStickerOptionImageView: UIImageView!
    @IBOutlet weak var lovedStickerTryMeButton: UIButton!
    
    
    //MARK: - Constants / Variables
    
    var lovedStickerCellDelegate: LovedStickerCellDelegate?
    var lovedStickerViewModel: LovedStickerViewModel! {
        didSet {
            lovedStickerHeadingLabel.text = lovedStickerViewModel.name
            lovedStickerImageView.kf.setImage(with: URL(string: lovedStickerViewModel.image))
        }
    }
    
    
    //MARK: - NIB Funtions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        showLoadingSkeletonView()
        lovedStickerHeadingLabel.text = ""
        
    }
    
    
    //MARK: - Design Elements
    
    func setDesignElements() {
        self.selectionStyle = .none
        Utilities.setDesignOn(view: lovedStickerContentView, backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        Utilities.setDesignOn(view: lovedStickerView, backgroundColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), setCustomCircleCurve: 30)
        Utilities.setDesignOn(label: lovedStickerHeadingLabel, font: Strings.defaultFontBold, fontSize: 20, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), numberofLines: 1, textAlignment: .left, canResize: true, minimumScaleFactor: 0.8)
        Utilities.setDesignOn(button: lovedStickerTryMeButton, title: Strings.tryMeButtonText, font: Strings.defaultFontBold, fontSize: 14, titleColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), isCircular: true)
        Utilities.setDesignOn(imageView: lovedStickerOptionImageView, image: UIImage(named: Strings.optionImage), tintColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        Utilities.setDesignOn(imageView: lovedStickerImageView)
    }
    
    func showLoadingSkeletonView() {
        DispatchQueue.main.async { [self] in
            Utilities.setDesignOn(view: contentView, backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
            lovedStickerView.isSkeletonable = true
            Utilities.setDesignOn(view: lovedStickerView, isSkeletonCircular: true, setCustomSkeletonCircleCurve: 30)
            lovedStickerView.showAnimatedSkeleton()
        }
    }
    
    func hideLoadingSkeletonView() {
        lovedStickerView.hideSkeleton(reloadDataAfter: true, transition: SkeletonTransitionStyle.crossDissolve(0.5))
    }
    
    func prepareLovedStickerTableViewCell() {
        hideSkeleton()
        setDesignElements()
    }
    
    func transitionToCaptureVC() {
        let storyboard = UIStoryboard(name: Strings.userStoryboard, bundle: nil)
        let captureVC = storyboard.instantiateViewController(identifier: Strings.captureVC) as! CaptureViewController
        captureVC.lovedStickerViewModel = lovedStickerViewModel
        lovedStickerCellDelegate?.getVC(using: captureVC)
    }
    
    
    //MARK: - Buttons
    
    @IBAction func lovedStickerTryMeButton(_ sender: UIButton) {
        transitionToCaptureVC()
    }
    
}


//MARK: - Protocols

protocol LovedStickerCellDelegate {
    func getVC(using viewController: UIViewController)
}
