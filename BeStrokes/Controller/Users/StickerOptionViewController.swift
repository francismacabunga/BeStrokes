//
//  StickerOptionViewController.swift
//  BeStrokes
//
//  Created by Francis Norman Macabunga on 1/5/21.
//

import UIKit
import Kingfisher

class StickerOptionViewController: UIViewController {
    
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
    
    var stickerViewModel: StickerViewModel!
    private var heartButtonLogic = HeartButtonLogic()
    private var heartButtonTapped: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDesignElements()
        registerGestures()
        
    }
    
    func setDesignElements() {
        
        view.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1)
        stackContentView.backgroundColor = .clear
        upperView.backgroundColor = .clear
        middleView.backgroundColor = .clear
        bottomView.backgroundColor = .clear
        
        Utilities.setDarkAppearance(on: stickerNavigationBar)
        
        stickerImageView.kf.setImage(with: stickerViewModel.image)
        stickerImageView.contentMode = .scaleAspectFit
        
        stickerName.text = stickerViewModel.name
        
        stickerName.text = stickerViewModel.name
        stickerName.font = UIFont(name: "Futura-Bold", size: 35)
        stickerName.textColor = .black
        
        stickerCategory.text = stickerViewModel.category
        stickerCategory.font = UIFont(name: "Futura-Bold", size: 15)
        stickerCategory.textColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1)
        stickerCategory.textAlignment = .center
        stickerCategory.backgroundColor = .black
        stickerCategory.layer.cornerRadius = stickerCategory.bounds.height / 2
        stickerCategory.clipsToBounds = true
        
        
        if stickerViewModel.tag != "none" {
            stickerTag.text = stickerViewModel.tag
            stickerTag.font = UIFont(name: "Futura-Bold", size: 15)
            stickerTag.textColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1)
            stickerTag.textAlignment = .center
            stickerTag.backgroundColor = .black
            stickerTag.layer.cornerRadius = stickerCategory.bounds.height / 2
            stickerTag.clipsToBounds = true
        } else {
            stickerTag.isHidden = true
        }
        
        stickerDescription.text = stickerViewModel.description
        stickerDescription.numberOfLines = 0
        stickerDescription.font = UIFont(name: "Futura", size: 17)
        stickerDescription.adjustsFontSizeToFitWidth = true
        stickerDescription.minimumScaleFactor = 1
        stickerDescription.textColor = .black
        
        checkHeartButtonValue()
        
//        stickerHeartButtonImageView.image = UIImage(systemName: "heart")
//        stickerHeartButtonImageView.tintColor = .black
        
        tryMeButton.setTitle("Try me", for: .normal)
        tryMeButton.titleLabel?.font = UIFont(name: "Futura-Bold", size: 20)
        tryMeButton.titleLabel?.tintColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9647058824, alpha: 1)
        tryMeButton.backgroundColor = .black
        tryMeButton.layer.cornerRadius = tryMeButton.bounds.height / 2
        tryMeButton.clipsToBounds = true
        
    }
    
    func setHeartButtonValue(using value: String) {
        stickerHeartButtonImageView.image = UIImage(systemName: value)
        stickerHeartButtonImageView.tintColor = .black
    }
    
    func checkHeartButtonValue() {
        heartButtonLogic.checkIfStickerLiked(using: stickerViewModel.stickerDocumentID) { [self] (result) in
            if result {
                setHeartButtonValue(using: "heart.fill")
                heartButtonTapped = true
            } else {
                setHeartButtonValue(using: "heart")
                heartButtonTapped = false
             
            }
        }
        
    }
    
    
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

