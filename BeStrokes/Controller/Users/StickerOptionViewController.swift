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
    @IBOutlet weak var stickerTopView: UIView!
    @IBOutlet weak var stickerMiddleView: UIView!
    @IBOutlet weak var stickerBottomView: UIView!
    @IBOutlet weak var stickerImageView: UIImageView!
    @IBOutlet weak var stickerHeartButtonImageView: UIImageView!
    @IBOutlet weak var stickerTryMeButtonLabel: UIButton!
    @IBOutlet weak var stickerNameLabelText: UILabel!
    @IBOutlet weak var stickerCategoryLabelText: UILabel!
    @IBOutlet weak var stickerTagLabelText: UILabel!
    @IBOutlet weak var stickerDescriptionLabelText: UILabel!
    
    
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
        Utilities.setDesignOn(view: view, backgroundColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1))
        Utilities.setDesignOn(stackView: stickerStackContentView, backgroundColor: .clear)
        Utilities.setDesignOn(view: stickerTopView, backgroundColor: .clear)
        Utilities.setDesignOn(view: stickerMiddleView, backgroundColor: .clear)
        Utilities.setDesignOn(view: stickerBottomView, backgroundColor: .clear)
        Utilities.setDesignOn(navigationBar: stickerNavigationBar, isDarkMode: true)
        Utilities.setDesignOn(imageView: stickerImageView, image: UIImage(systemName: Strings.unheartSticker))
        Utilities.setDesignOn(label: stickerNameLabelText, font: Strings.defaultFontBold, fontSize: 35, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), numberofLines: 1, textAlignment: .left, canResize: true, minimumScaleFactor: 0.8)
        Utilities.setDesignOn(label: stickerCategoryLabelText, font: Strings.defaultFontBold, fontSize: 15, fontColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), numberofLines: 1, textAlignment: .center, isCircular: true, backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        Utilities.setDesignOn(label: stickerTagLabelText, font: Strings.defaultFontBold, fontSize: 15, fontColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), numberofLines: 1, textAlignment: .center, isCircular: true, backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        Utilities.setDesignOn(label: stickerDescriptionLabelText, font: Strings.defaultFont, fontSize: 17, fontColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), numberofLines: 0, textAlignment: .left, lineBreakMode: .byWordWrapping)
        Utilities.setDesignOn(button: stickerTryMeButtonLabel, title: Strings.tryMeButton, font: Strings.defaultFontBold, fontSize: 20, titleColor: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1), isCircular: true, backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
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
        stickerNameLabelText.text = stickerViewModel.name
        getHeartButtonValue()
        stickerCategoryLabelText.text = stickerViewModel.category
        
        if stickerViewModel.tag != Strings.noStickerTag {
            stickerTagLabelText.text = stickerViewModel.tag
        } else {
            stickerTagLabelText.isHidden = true
        }
        
        stickerDescriptionLabelText.text = stickerViewModel.description
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

