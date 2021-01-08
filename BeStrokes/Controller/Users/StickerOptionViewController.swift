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
    @IBOutlet weak var stickerStackContentView: UIStackView!
    @IBOutlet weak var stickerUpperView: UIView!
    @IBOutlet weak var stickerMiddleView: UIView!
    @IBOutlet weak var stickerBottomView: UIView!
    @IBOutlet weak var stickerImageView: UIImageView!
    @IBOutlet weak var stickerHeartButtonImageView: UIImageView!
    @IBOutlet weak var stickerTryMeButton: UIButton!
    @IBOutlet weak var stickerNameLabel: UILabel!
    @IBOutlet weak var stickerCategoryLabel: UILabel!
    @IBOutlet weak var stickerTagLabel: UILabel!
    @IBOutlet weak var stickerDescriptionLabel: UILabel!
    
    
    //MARK: - Constants / Variables
    
    var stickerViewModel: StickerViewModel!
    private let heartButtonLogic = HeartButtonLogic()
    private var heartButtonTapped: Bool?
    
    
    //MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDesignElements()
        registerGestures()
        setStickerData()
        
    }
    
    
    //MARK: - Design Elements
    
    func setDesignElements() {
        
        Utilities.setDesignOn(view: view, color: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1))
        Utilities.setDesignOn(stackView: stickerStackContentView, color: .clear)
        Utilities.setDesignOn(view: stickerUpperView, color: .clear)
        Utilities.setDesignOn(view: stickerMiddleView, color: .clear)
        Utilities.setDesignOn(view: stickerBottomView, color: .clear)
        
        Utilities.setDesignOn(navigationBar: stickerNavigationBar, isDarkMode: true)
        
        Utilities.setDesignOn(imageView: stickerImageView, image: UIImage(systemName: Strings.unheartSticker))
        
        Utilities.setDesignOn(stickerNameLabel, font: Strings.defaultFontBold, fontSize: 35, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), textAlignment: .left, numberofLines: 1, canResize: true, minimumScaleFactor: 0.8)
        Utilities.setDesignOn(stickerCategoryLabel, font: Strings.defaultFontBold, fontSize: 15, fontColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), textAlignment: .center, numberofLines: 1, isCircular: true, backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        Utilities.setDesignOn(stickerTagLabel, font: Strings.defaultFontBold, fontSize: 15, fontColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), textAlignment: .center, numberofLines: 1, isCircular: true, backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        Utilities.setDesignOn(stickerDescriptionLabel, font: Strings.defaultFont, fontSize: 17, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), textAlignment: .left, numberofLines: 0, lineBreakMode: .byWordWrapping)
        
        Utilities.setDesignOn(button: stickerTryMeButton, title: Strings.tryMeButton, font: Strings.defaultFontBold, size: 20, titleColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), isCircular: true)
        
    }
    
    func getHeartButtonValue() {
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
        stickerNameLabel.text = stickerViewModel.name
        getHeartButtonValue()
        stickerCategoryLabel.text = stickerViewModel.category
        
        if stickerViewModel.tag != Strings.noStickerTag {
            stickerTagLabel.text = stickerViewModel.tag
        } else {
            stickerTagLabel.isHidden = true
        }
        
        stickerDescriptionLabel.text = stickerViewModel.description
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

