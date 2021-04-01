//
//  StickerCollectionViewCell.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 12/5/20.
//

import UIKit
import SkeletonView
import Kingfisher

class StickerCollectionViewCell: UICollectionViewCell {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var stickerContentView: UIView!
    @IBOutlet weak var stickerView: UIView!
    @IBOutlet weak var stickerLabel: UILabel!
    @IBOutlet weak var stickerOptionImageView: UIImageView!
    @IBOutlet weak var stickerImageView: UIImageView!
    
    
    //MARK: - Constants / Variables
    
    private var heartButtonTapped: Bool?
    private var skeletonColor: UIColor?
    var stickerViewModel: StickerViewModel? {
        didSet {
            guard let stickerData = stickerViewModel else {return}
            stickerLabel.text = stickerData.name
            stickerImageView.kf.setImage(with: URL(string: stickerData.image))
        }
    }
    
    
    //MARK: - NIB Functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setSkeletonColor()
        showLoadingSkeletonView()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        stickerOptionImageView.image = nil
        
    }
    
    
    //MARK: - Design Elements
    
    func setDesignElements() {
        Utilities.setDesignOn(view: stickerContentView, backgroundColor: .clear)
        Utilities.setDesignOn(view: stickerView, setCustomCircleCurve: 30)
        Utilities.setDesignOn(label: stickerLabel, fontName: Strings.defaultFontBold, fontSize: 15, numberofLines: 1, textAlignment: .left, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), canResize: true, minimumScaleFactor: 0.8)
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
        }
    }
    
    @objc func setDarkMode() {
        UIView.animate(withDuration: 0.3) { [self] in
            Utilities.setDesignOn(view: stickerView, backgroundColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1))
            Utilities.setShadowOn(view: stickerView, isHidden: true)
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
    
    func prepareStickerCollectionViewCell() {
        hideLoadingSkeletonView()
        setDesignElements()
    }
    
}
