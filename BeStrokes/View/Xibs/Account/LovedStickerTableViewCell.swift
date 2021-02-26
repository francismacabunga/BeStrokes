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
        
        lovedStickerHeadingLabel.text = ""
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        lovedStickerHeadingLabel.text = nil
        lovedStickerImageView.image = nil
        
    }
    
    
    //MARK: - Design Elements
    
    func setDesignElements() {
        self.selectionStyle = .none
        Utilities.setDesignOn(view: lovedStickerContentView, backgroundColor: .clear)
        Utilities.setDesignOn(view: lovedStickerView, setCustomCircleCurve: 30)
        Utilities.setDesignOn(label: lovedStickerHeadingLabel, fontName: Strings.defaultFontBold, fontSize: 20, numberofLines: 1, textAlignment: .left, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), canResize: true, minimumScaleFactor: 0.8)
        Utilities.setDesignOn(button: lovedStickerTryMeButton, title: Strings.tryMeButtonText, fontName: Strings.defaultFontBold, fontSize: 14, isCircular: true)
        Utilities.setDesignOn(imageView: lovedStickerOptionImageView, image: UIImage(named: Strings.optionImage))
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
            Utilities.setDesignOn(view: lovedStickerView, backgroundColor: .white)
            Utilities.setShadowOn(view: lovedStickerView, isHidden: false, shadowColor: #colorLiteral(red: 0.6948884352, green: 0.6939979255, blue: 0.7095529112, alpha: 1), shadowOpacity: 1, shadowOffset: .zero, shadowRadius: 2)
            Utilities.setShadowOn(button: lovedStickerTryMeButton, isHidden: false, shadowColor: #colorLiteral(red: 0.6948884352, green: 0.6939979255, blue: 0.7095529112, alpha: 1), shadowOpacity: 1, shadowOffset: .zero, shadowRadius: 2)
            Utilities.setDesignOn(button: lovedStickerTryMeButton, titleColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), backgroundColor: .white)
        }
    }
    
    @objc func setDarkMode() {
        UIView.animate(withDuration: 0.3) { [self] in
            Utilities.setDesignOn(view: lovedStickerView, backgroundColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1))
            Utilities.setShadowOn(view: lovedStickerView, isHidden: true)
            Utilities.setShadowOn(button: lovedStickerTryMeButton, isHidden: true)
            Utilities.setDesignOn(button: lovedStickerTryMeButton, titleColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        }
    }
    
    func transitionToCaptureVC() {
        let storyboard = UIStoryboard(name: Strings.userStoryboard, bundle: nil)
        let captureVC = storyboard.instantiateViewController(identifier: Strings.captureVC) as! CaptureViewController
        captureVC.lovedStickerViewModel = lovedStickerViewModel
        captureVC.modalPresentationStyle = .fullScreen
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
