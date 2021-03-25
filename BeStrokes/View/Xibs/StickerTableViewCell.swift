//
//  LovedStickerTableViewCell.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 1/10/21.
//

import UIKit
import SkeletonView
import Kingfisher

class StickerTableViewCell: UITableViewCell {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var stickerContentView: UIView!
    @IBOutlet weak var stickerView: UIView!
    @IBOutlet weak var stickerHeadingLabel: UILabel!
    @IBOutlet weak var stickerImageView: UIImageView!
    @IBOutlet weak var stickerOptionImageView: UIImageView!
    @IBOutlet weak var stickerTryMeButton: UIButton!
    
    
    //MARK: - Constants / Variables
    
    private var skeletonColor: UIColor?
    var stickerCellDelegate: StickerTableViewCellDelegate?
    var userStickerViewModel: UserStickerViewModel! {
        didSet {
            stickerHeadingLabel.text = userStickerViewModel.name
            stickerImageView.kf.setImage(with: URL(string: userStickerViewModel.image))
        }
    }
    
    
    //MARK: - NIB Funtions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        stickerHeadingLabel.text = ""
        setSkeletonColor()
        showLoadingSkeletonView()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        stickerHeadingLabel.text = nil
        stickerImageView.image = nil
        
    }
    
    
    //MARK: - Design Elements
    
    func setDesignElements() {
        self.selectionStyle = .none
        Utilities.setDesignOn(view: stickerContentView, backgroundColor: .clear)
        Utilities.setDesignOn(view: stickerView, setCustomCircleCurve: 30)
        Utilities.setDesignOn(label: stickerHeadingLabel, fontName: Strings.defaultFontBold, fontSize: 20, numberofLines: 1, textAlignment: .left, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), canResize: true, minimumScaleFactor: 0.8)
        Utilities.setDesignOn(button: stickerTryMeButton, title: Strings.tryMeButtonText, fontName: Strings.defaultFontBold, fontSize: 14, isCircular: true)
        Utilities.setDesignOn(imageView: stickerOptionImageView, image: UIImage(named: Strings.optionImage))
        NotificationCenter.default.addObserver(self, selector: #selector(setLightMode), name: Utilities.setLightModeAppearance, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setDarkMode), name: Utilities.setDarkModeAppearance, object: nil)
        checkThemeAppearance()
    }
    
    func checkThemeAppearance() {
        if UserDefaults.standard.bool(forKey: Strings.lightModeKey) {
            setLightMode()
        } else {
            setDarkMode()
        }
    }
    
    @objc func setLightMode() {
        UIView.animate(withDuration: 0.3) { [self] in
            Utilities.setDesignOn(view: stickerView, backgroundColor: .white)
            Utilities.setShadowOn(view: stickerView, isHidden: false, shadowColor: #colorLiteral(red: 0.6948884352, green: 0.6939979255, blue: 0.7095529112, alpha: 1), shadowOpacity: 1, shadowOffset: .zero, shadowRadius: 2)
            Utilities.setShadowOn(button: stickerTryMeButton, isHidden: false, shadowColor: #colorLiteral(red: 0.6948884352, green: 0.6939979255, blue: 0.7095529112, alpha: 1), shadowOpacity: 1, shadowOffset: .zero, shadowRadius: 2)
            Utilities.setDesignOn(button: stickerTryMeButton, titleColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), backgroundColor: .white)
        }
    }
    
    @objc func setDarkMode() {
        UIView.animate(withDuration: 0.3) { [self] in
            Utilities.setDesignOn(view: stickerView, backgroundColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1))
            Utilities.setShadowOn(view: stickerView, isHidden: true)
            Utilities.setShadowOn(button: stickerTryMeButton, isHidden: true)
            Utilities.setDesignOn(button: stickerTryMeButton, titleColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        }
    }
    
    func setSkeletonColor() {
        if UserDefaults.standard.bool(forKey: Strings.lightModeKey) {
            skeletonColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1)
        } else {
            skeletonColor = #colorLiteral(red: 0.2006691098, green: 0.200709641, blue: 0.2006634176, alpha: 1)
        }
    }
    
    func showLoadingSkeletonView() {
        DispatchQueue.main.async { [self] in
            stickerView.isSkeletonable = true
            Utilities.setDesignOn(view: stickerView, isSkeletonCircular: true, setCustomSkeletonCircleCurve: 30)
            stickerView.showSkeleton(usingColor: skeletonColor!, transition: .crossDissolve(0.3))
            stickerView.showAnimatedSkeleton()
        }
    }
    
    func hideLoadingSkeletonView() {
        stickerView.hideSkeleton(reloadDataAfter: true, transition: SkeletonTransitionStyle.crossDissolve(0.5))
    }
    
    func prepareStickerTableViewCell() {
        hideLoadingSkeletonView()
        setDesignElements()
    }
    
    
    //MARK: - Buttons
    
    @IBAction func lovedStickerTryMeButton(_ sender: UIButton) {
        if UserDefaults.standard.bool(forKey: Strings.notificationVCTappedKey) {
            UserDefaults.standard.setValue(false, forKey: Strings.isNotificationVCLoadedKey)
        }
        if UserDefaults.standard.bool(forKey: Strings.accountVCTappedKey) {
            UserDefaults.standard.setValue(false, forKey: Strings.isAccountVCLoadedKey)
        }
        
        
        let captureVC = Utilities.transition(to: Strings.captureVC, onStoryboard: Strings.userStoryboard, canAccessDestinationProperties: true)! as! CaptureViewController
        captureVC.userStickerViewModel = userStickerViewModel
        captureVC.modalPresentationStyle = .fullScreen
        stickerCellDelegate?.getVC(using: captureVC)
    }
    
}


//MARK: - Protocols

protocol StickerTableViewCellDelegate {
    func getVC(using viewController: UIViewController)
}
