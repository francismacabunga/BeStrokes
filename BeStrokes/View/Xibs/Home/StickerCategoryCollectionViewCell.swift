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
    
    var stickerCategoryViewModel: StickerCategoryViewModel? {
        didSet {
            guard let stickerCategoryData = stickerCategoryViewModel else {return}
            stickerCategoryLabel.text = stickerCategoryData.category
            let isCategorySelected = stickerCategoryData.isCategorySelected
            if UserDefaults.standard.bool(forKey: Strings.lightModeKey) {
                setLightMode()
                if isCategorySelected {
                    stickerCategoryView.backgroundColor = #colorLiteral(red: 0.9944363236, green: 0.9993038774, blue: 0, alpha: 1)
                } else {
                    stickerCategoryView.backgroundColor = .white
                }
            } else {
                setDarkMode()
                if isCategorySelected {
                    stickerCategoryView.backgroundColor = #colorLiteral(red: 0.9944363236, green: 0.9993038774, blue: 0, alpha: 1)
                } else {
                    stickerCategoryView.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1)
                }
            }
        }
    }
    
    
    //MARK: - Design Elements
    
    func setDesignElements() {
        Utilities.setDesignOn(view: stickerCategoryContentView, backgroundColor: .clear)
        Utilities.setDesignOn(view: stickerCategoryView, isCircular: true)
        Utilities.setDesignOn(label: stickerCategoryLabel, fontName: Strings.defaultFontBold, fontSize: 13, numberofLines: 1, textAlignment: .center, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), canResize: true, minimumScaleFactor: 0.9)
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
            Utilities.setShadowOn(view: stickerCategoryView, isHidden: false, shadowColor: #colorLiteral(red: 0.6948884352, green: 0.6939979255, blue: 0.7095529112, alpha: 1), shadowOpacity: 1, shadowOffset: .zero, shadowRadius: 2)
        }
    }
    
    @objc func setDarkMode() {
        UIView.animate(withDuration: 0.3) { [self] in
            Utilities.setShadowOn(view: stickerCategoryView, isHidden: true)
        }
    }
    
}
