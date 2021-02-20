//
//  StickerCategoryCollectionViewCell.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 12/5/20.
//

import UIKit

class StickerCategoryCollectionViewCell: UICollectionViewCell {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var stickerCategoryContentView: UIView!
    @IBOutlet weak var stickerCategoryView: UIView!
    @IBOutlet weak var stickerCategoryLabel: UILabel!
    
    
    //MARK: - Constants / Variables
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var stickerCategoryViewModel: StickerCategoryViewModel! {
        didSet {
            stickerCategoryLabel.text = stickerCategoryViewModel.category
            let isCategorySelected = stickerCategoryViewModel.isCategorySelected
            if appDelegate.isLightModeOn {
                setLightMode()
                if isCategorySelected {
                    Utilities.setDesignOn(view: stickerCategoryView, backgroundColor: #colorLiteral(red: 0.9944363236, green: 0.9993038774, blue: 0, alpha: 1))
                } else {
                    Utilities.setDesignOn(view: stickerCategoryView , backgroundColor: .white)
                }
            } else {
                setDarkMode()
                if isCategorySelected {
                    Utilities.setDesignOn(view: stickerCategoryView, backgroundColor: #colorLiteral(red: 0.9944363236, green: 0.9993038774, blue: 0, alpha: 1))
                } else {
                    Utilities.setDesignOn(view: stickerCategoryView , backgroundColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1))
                }
            }
        }
    }
    
    
    //MARK: - NIB Functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    
    //MARK: - Design Elements
    
    func setDesignElements() {
        Utilities.setDesignOn(view: stickerCategoryContentView, backgroundColor: .clear)
        Utilities.setDesignOn(view: stickerCategoryView, isCircular: true)
        Utilities.setDesignOn(label: stickerCategoryLabel, font: Strings.defaultFontBold, fontSize: 13, numberofLines: 1, textAlignment: .center, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), canResize: true, minimumScaleFactor: 0.9)
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
            stickerCategoryView.layer.shadowColor = #colorLiteral(red: 0.6948884352, green: 0.6939979255, blue: 0.7095529112, alpha: 1)
            stickerCategoryView.layer.shadowOpacity = 1
            stickerCategoryView.layer.shadowOffset = .zero
            stickerCategoryView.layer.shadowRadius = 2
            stickerCategoryView.layer.masksToBounds = false
        }
    }
    
    @objc func setDarkMode() {
        UIView.animate(withDuration: 0.3) { [self] in
            stickerCategoryView.layer.shadowColor = nil
            stickerCategoryView.layer.shadowOpacity = 0
            stickerCategoryView.layer.shadowOffset = .zero
            stickerCategoryView.layer.shadowRadius = 0
            stickerCategoryView.layer.masksToBounds = true
        }
    }
    
}
