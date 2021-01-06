//
//  StickerOptionViewController.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 1/5/21.
//

import UIKit
import Kingfisher

class StickerOptionViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var stickerNavigationBar: UINavigationBar!
    @IBOutlet weak var stackContentView: UIStackView!
    @IBOutlet weak var upperView: UIView!
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var stickerImageView: UIImageView!
    @IBOutlet weak var stickerHeartButtonImageView: UIImageView!
    @IBOutlet weak var tryMeButton: UIButton!
    @IBOutlet weak var stickerName: UILabel!
    @IBOutlet weak var stickerCategory: UILabel!
    @IBOutlet weak var stickerTag: UILabel!
    @IBOutlet weak var stickerDescription: UILabel!
    
    
    //MARK: - Constants / Variables
    
    var stickerViewModel: StickerViewModel!
    private var heartButtonLogic = HeartButtonLogic()
    private var heartButtonTapped: Bool?
    
    
    //MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDesignOnElements()
        registerGestures()
        setStickerData()
        
    }
    
    func setDesignOnElements() {
        
        Utilities.setDesignOn(view: view, color: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1))
        Utilities.setDesignOn(stackView: stackContentView, color: .clear)
        Utilities.setDesignOn(view: upperView, color: .clear)
        Utilities.setDesignOn(view: middleView, color: .clear)
        Utilities.setDesignOn(view: bottomView, color: .clear)
        
        Utilities.setDesignOn(navigationBar: stickerNavigationBar, isDarkMode: true)
        
        Utilities.setDesignOn(imageView: stickerImageView, image: UIImage(systemName: Strings.unheartSticker))
        
        Utilities.setDesignOn(stickerName, font: Strings.defaultFontBold, fontSize: 35, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), textAlignment: .left, numberofLines: 1, canResize: true, minimumScaleFactor: 0.8)
        Utilities.setDesignOn(stickerCategory, font: Strings.defaultFontBold, fontSize: 15, fontColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), textAlignment: .center, numberofLines: 1, isCircular: true, backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        Utilities.setDesignOn(stickerTag, font: Strings.defaultFontBold, fontSize: 15, fontColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), textAlignment: .center, numberofLines: 1, isCircular: true, backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        Utilities.setDesignOn(stickerDescription, font: Strings.defaultFont, fontSize: 17, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), textAlignment: .left, numberofLines: 0, lineBreakMode: .byWordWrapping)
        
        Utilities.setDesignOn(button: tryMeButton, title: Strings.tryMeButton, font: Strings.defaultFontBold, size: 20, titleColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), isCircular: true)
        
    }
    
    func checkHeartButtonValue() {
        
        heartButtonLogic.checkIfStickerLiked(using: stickerViewModel.stickerDocumentID) { [self] (result) in
            if result {
                Utilities.setDesignOn(imageView: stickerHeartButtonImageView, image: UIImage(systemName: Strings.heartSticker), tintColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
                heartButtonTapped = true
            } else {
                Utilities.setDesignOn(imageView: stickerHeartButtonImageView, image: UIImage(systemName: Strings.unheartSticker), tintColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
                heartButtonTapped = false
            }
        }
        
    }
    
    func setStickerData() {
        
        stickerImageView.kf.setImage(with: stickerViewModel.image)
        stickerName.text = stickerViewModel.name
        checkHeartButtonValue()
        stickerCategory.text = stickerViewModel.category
        
        if stickerViewModel.tag != Strings.noStickerTag {
            stickerTag.text = stickerViewModel.tag
        } else {
            stickerTag.isHidden = true
        }
        
        stickerDescription.text = stickerViewModel.description
        
    }
    
    
    //MARK: - UIGestureHandlers
    
    func registerGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureHandler))
        stickerHeartButtonImageView.isUserInteractionEnabled = true
        stickerHeartButtonImageView.addGestureRecognizer(tapGesture)
    }
    
    @objc func tapGestureHandler(tap: UITapGestureRecognizer) {
        if heartButtonTapped! {
            heartButtonLogic.removeUserData(using: stickerViewModel.stickerDocumentID)
        } else {
            heartButtonLogic.saveUserData(using: stickerViewModel.stickerDocumentID)
        }
    }
    
}

