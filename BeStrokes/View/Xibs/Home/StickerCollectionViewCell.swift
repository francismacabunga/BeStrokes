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
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private var heartButtonTapped: Bool?
    private var skeletonColor: UIColor?
    var stickerViewModel: StickerViewModel! {
        didSet {
            stickerLabel.text = stickerViewModel.name
            stickerImageView.kf.setImage(with: URL(string: stickerViewModel.image))
        }
    }
    
    
    //MARK: - NIB Functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setSkeletonColor()
        showLoadingSkeletonView()
        
    }
    
    override func prepareForReuse() {
        stickerOptionImageView.image = nil
    }
    
    
    //MARK: - Design Elements
    
    func setDesignElements() {
        Utilities.setDesignOn(view: stickerContentView, backgroundColor: .clear)
        Utilities.setDesignOn(view: stickerView, setCustomCircleCurve: 30)
        Utilities.setDesignOn(label: stickerLabel, font: Strings.defaultFontBold, fontSize: 15, numberofLines: 1, textAlignment: .left, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), canResize: true, minimumScaleFactor: 0.8)
        Utilities.setDesignOn(imageView: stickerOptionImageView, image: UIImage(named: Strings.optionImage))
        Utilities.setDesignOn(imageView: stickerImageView)
        NotificationCenter.default.addObserver(self, selector: #selector(setLightMode), name: Utilities.setLightModeAppearance, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setDarkMode), name: Utilities.setDarkModeAppearance, object: nil)
        checkThemeAppearance()
    }
    
    func checkThemeAppearance() {
        if appDelegate.isLightModeOn {
            setLightMode()
        } else {
            setDarkMode()
        }
    }
    
    @objc func setLightMode() {
        UIView.animate(withDuration: 0.3) { [self] in
            stickerView.backgroundColor = .white
            
            stickerView.layer.shadowColor = #colorLiteral(red: 0.6948884352, green: 0.6939979255, blue: 0.7095529112, alpha: 1)
            stickerView.layer.shadowOpacity = 1
            stickerView.layer.shadowOffset = .zero
            stickerView.layer.shadowRadius = 2
            stickerView.layer.masksToBounds = false
        }
    }
    
    @objc func setDarkMode() {
        UIView.animate(withDuration: 0.3) { [self] in
            stickerView.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1)
            
            stickerView.layer.shadowColor = nil
            stickerView.layer.shadowOpacity = 0
            stickerView.layer.shadowOffset = .zero
            stickerView.layer.shadowRadius = 0
            stickerView.layer.masksToBounds = true
        }
    }
    
    func setSkeletonColor() {
        if appDelegate.isLightModeOn {
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
